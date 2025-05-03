-- fish-lsp.lua configuration
local M = {}

-- Function to set up document highlight
local function setup_document_highlight(client, bufnr)
  -- Check if client supports documentHighlight
  if client.server_capabilities.documentHighlightProvider then
    -- Create highlight groups for document highlights
    vim.api.nvim_set_hl(0, "LspReferenceText", { bg = "#3c3836" })
    vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = "#3c3836" })
    vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = "#3c3836" })

    -- Create autocommands for highlight on cursor hold
    local highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })

    vim.api.nvim_create_autocmd("CursorHold", {
      group = highlight_group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.document_highlight()
      end,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      group = highlight_group,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.clear_references()
      end,
    })
  end
end

-- Function to configure LSP on attach
local function on_attach(client, bufnr)
  -- Set up document highlight
  setup_document_highlight(client, bufnr)

  -- Configure hover with rounded borders
  vim.opt.winborder = 'rounded'
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    max_width = 120,
  })

  -- Configure signature help with rounded borders
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  -- Enable inlay hints if supported
  if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  -- hold color highlighting                                                                     
  vim.cmd([[                                                                                     
    autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()                            
    autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()                            
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()                              
  ]])                                                                                            

  -- codelens                                                                                    
  if vim.lsp.codelens and client.server_capabilities.codeLensProvider then
    vim.cmd([[                                                                                     
      autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh({ bufnr = 0 }) 
    ]])                                                                                            
  end

  -- Local keybindings for LSP features
  local opts = { buffer = bufnr, noremap = true, silent = true }

  -- Codelens
  vim.keymap.set("n", "gcl", vim.lsp.codelens.run, opts)

  -- Go-to definition
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

  -- Go-to implementation
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)

  -- Hover
  vim.keymap.set("n", "gs", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  -- Jump to diagnostic
  vim.keymap.set("n", "gn", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "gen", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "gep", vim.diagnostic.goto_prev, opts)

  -- Go-to reference
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

  -- Rename
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

  -- Quickfix function
  local function quickfix()
    vim.lsp.buf.code_action({
      filter = function(a)
        return a.isPreferred
      end,
      apply = true,
    })
  end

  -- Code actions
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>qf", quickfix, opts)

  -- Format
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, opts)

  -- Signature help
  vim.keymap.set("n", "<leader>s", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)

  -- Document highlight
  vim.keymap.set("n", "<leader>h", vim.lsp.buf.document_highlight, opts)

  -- Tree-sitter inspection
  vim.keymap.set("n", "<leader>i", "<cmd>InspectTree<cr>", opts)

  -- Folding setup
  vim.keymap.set("n", "gfo", function()
    vim.o.foldenable = not vim.o.foldenable
    if vim.o.foldenable then
      vim.b.foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end, opts)
end

-- Initialize the fish LSP using v0.11.1 native LSP config
function M.setup()
  -- Create capabilities
  local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    -- Add any additional capabilities if needed
    {}
  )

  -- Register autocommand to setup fish-lsp for fish files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "fish",
    callback = function()
      -- Start the LSP server for fish files
      local client_id = vim.lsp.start({
        name = "fish",
        cmd = { "fish-lsp", "start" },
        root_dir = function()
          local root = vim.fs.find({ ".git", "fish" }, { upward = true })[1]
          return root and vim.fs.dirname(root) or vim.fn.getcwd()
        end,
        capabilities = capabilities,
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
      })

      -- If server started successfully, attach to buffer
      if client_id then
        vim.lsp.buf_attach_client(0, client_id)
      end
    end,
  })
end

return M
