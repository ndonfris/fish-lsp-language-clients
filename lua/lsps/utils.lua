--- LSP utility functions for Neovim configuration.
--- Provides version checking, document highlighting, and LSP attach configuration.
local M = {}

--- Checks if current Neovim version meets specified requirements.
--- @param required_major number|nil Major version requirement (default: 0)
--- @param required_minor number|nil Minor version requirement (default: 11)
--- @param required_patch number|nil Patch version requirement (default: 1)
--- @return table Result containing:
---   - meets_requirement boolean: Whether version requirement is met
---   - current table: Current Neovim version information
---   - required table: Required version information
function M.check_version(required_major, required_minor, required_patch)
  -- Set defaults if not provided
  required_major = required_major or 0
  required_minor = required_minor or 11
  required_patch = required_patch or 1

  local v = vim.version()
  local meets_requirement = false

  if v.major > required_major then
    meets_requirement = true
  elseif v.major == required_major and v.minor > required_minor then
    meets_requirement = true
  elseif v.major == required_major and v.minor == required_minor and v.patch >= required_patch then
    meets_requirement = true
  end

  return {
    meets_requirement = meets_requirement,
    current = v,
    required = { major = required_major, minor = required_minor, patch = required_patch },
  }
end

-- M.document_symbols_outline = require('lsps.document-symbol-outline').document_symbols_outline()

--- Checks if current Neovim version meets the required v0.11.1.
--- Displays a warning notification if requirement is not met.
--- @return nil
function M.check_nvim_version()
  local result = M.check_version()
  local v = result.current

  if not result.meets_requirement then
    vim.notify(
      string.format("Warning: Current Neovim v%d.%d.%d doesn't meet the required v0.11.1", v.major, v.minor, v.patch),
      vim.log.levels.WARN,
      {
        title = " Neovim version check",
      }
    )
  end
end

--- Sets up document highlighting for the LSP client.
--- Creates highlight groups and autocommands for cursor-based reference highlighting.
--- @param client table LSP client object
--- @param bufnr number Buffer number
--- @return nil
function M.setup_document_highlight(client, bufnr)
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

--- Configures LSP behavior when a language server attaches to a buffer.
--- Sets up document highlighting, handlers, keybindings, and other LSP features.
--- @param client table LSP client object
--- @param bufnr number Buffer number
--- @return nil
--- @usage Typically used in the on_attach callback of LSP server setup:
---   require('lspconfig').tsserver.setup({
---     on_attach = require('lsp.utils').on_attach
---   })
function M.on_attach(client, bufnr)
  -- make sure we are using v0.11.1 of neovim
  M.check_nvim_version()

  -- Set up document highlight
  M.setup_document_highlight(client, bufnr)

  -- Enable LSP autocompletion if the client supports it
  if client.server_capabilities.completionProvider then
    vim.lsp.completion.enable(true, client.id, bufnr, {
      -- Set to true for automatic triggering, false for manual (Ctrl-X Ctrl-O)
      autotrigger = true
    })
  end

  -- Configure hover with rounded borders using winborder option
  -- This is the new recommended way instead of vim.lsp.with
  vim.opt.winborder = "rounded"

  -- Configure inlay hints if supported
  if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  -- Add this to your diagnostic configuration
  vim.diagnostic.config({
    -- Your existing diagnostic configuration...

    -- Keep diagnostic info even in insert mode
    update_in_insert = true,

    -- Configure virtual text (optional - you might want to disable this
    -- if you're already showing diagnostics in the hover window)
    virtual_text = false,
  })

  -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  --   border = "rounded",
  --   max_width = 120,
  --   wrap_at = 120,
  --   -- trim_empty_lines = true,
  -- })
  --
  -- -- Configure signature help with rounded borders
  -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  --   border = "rounded",
  -- })

  -- Enable inlay hints if supported
  -- if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
  --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  -- end

  -- hold color highlighting
  vim.cmd([[
    autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    "autocmd CursorHold  <buffer> lua vim.lsp.buf.hover({ focusable = false, silent = true })
    "autocmd CursorHoldI <buffer> lua vim.lsp.buf.signature_help({ focusable = false,silent = true})
  ]])


  -- codelens
  if vim.lsp.codelens and client.server_capabilities.codeLensProvider then
    vim.cmd([[
      autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh({ bufnr = 0 })
    ]])
  end


  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      vim.diagnostic.open_float(nil, {
        focus = false,
        scope = "cursor", -- Show diagnostics for cursor only
      })
    end,
  })

  -- Local keybindings for LSP features
  local opts = { buffer = bufnr, noremap = true, silent = true }

  --- check if the user has disabled custom keymaps
  if vim.g.enable_custom_keymaps ~= nil and not vim.g.enable_custom_keymaps then
    return nil
  end

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
  vim.keymap.set("n", "gn", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
  vim.keymap.set("n", "gp", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
  vim.keymap.set("n", "gen", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
  vim.keymap.set("n", "gep", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)

  -- Navigate to next/prev diagnostic of specific severity
  vim.keymap.set("n", "<leader>de", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, opts)

  vim.keymap.set("n", "<leader>dw", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, opts)

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

  -- refactors
  vim.keymap.set("n", "<leader>cr", function() -- Normal mode
    vim.lsp.buf.code_action({
      -- filter = function(action)
      --   -- Check if the action has a kind property
      --   if action.kind then
      --     -- Check if the action's kind contains "refactor"
      --     return action.kind:find("refactor") ~= nil
      --   end
      --   return false
      -- end,
      --- @diagnostic disable-next-line
      context = {
        only = { "refactor" },
      },
    })
  end, opts)
  vim.keymap.set("v", "<leader>cr", function() -- Visual mode
    vim.lsp.buf.code_action({
      --- @diagnostic disable-next-line
      context = {
        only = { "refactor" },
      },
      range = {
        ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
        ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
      },
    })
  end, opts)

  -- Format
  vim.keymap.set({ "x", "v", "n" }, "<leader>f", function()
    vim.lsp.buf.format({ async = true })
    vim.notify('LSP Formatted', vim.log.levels.INFO, { title = "LSP " })
  end, opts)

  -- Signature help
  vim.keymap.set("n", "<leader>s", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)

  -- Document highlight
  vim.keymap.set("n", "<leader>h", vim.lsp.buf.document_highlight, opts)

  -- Tree-sitter inspection
  vim.keymap.set("n", "<leader>i", "<cmd>InspectTree<cr>", opts)
  -- Create an autocommand group for the query filetype keymaps
  local query_group = vim.api.nvim_create_augroup("QueryFiletypeKeymaps", { clear = true })

  -- Create an autocommand that sets up the <C-c> mapping when a 'query' buffer is loaded
  vim.api.nvim_create_autocmd("FileType", {
    group = query_group,
    pattern = "query",
    callback = function(ev)
      -- Create a buffer-local keymap for <C-c> to close the buffer
      vim.keymap.set("n", "<C-c>", function()
        -- Close the current buffer
        vim.cmd("bd")
      end, { buffer = ev.buf, noremap = true, silent = true, desc = "Close query buffer" })
    end,
    desc = "Set up query buffer close keybinding"
  })

  -- Folding setup
  vim.keymap.set("n", "gfo", function()
    vim.o.foldenable = not vim.o.foldenable
    if vim.o.foldenable then
      --- @diagnostic disable-next-line: inject-field
      vim.b.foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end, opts)

  -- Set up workspace symbols
  vim.keymap.set("n", "<leader><leader>W", vim.lsp.buf.workspace_symbol, {
    noremap = true,
    silent = true,
    buffer = bufnr,
    desc = "LSP: Workspace Symbol",
  })

  vim.keymap.set("n", "<leader><leader>S", vim.lsp.buf.document_symbol, {
    noremap = true,
    silent = true,
    buffer = bufnr,
    desc = "LSP: Document Symbol",
  })

  vim.keymap.set("n", "<leader>so", require('lsps.document-symbol-outline').document_symbols_outline, {
    noremap = true,
    silent = true,
    buffer = bufnr,
    desc = "LSP: Toggle showing document symbol tree",
  })
end

return M
