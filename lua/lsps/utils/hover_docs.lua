
---- ┌──────────────────┐
---- │ style hover docs │
---- └──────────────────┘

-- Enable concealing of markdown characters
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.o.conceallevel = 3
  end
})

-- Optional: Set some basic fish file detection if needed
vim.filetype.add({
  extension = {
    fish = 'fish',
  },
})
