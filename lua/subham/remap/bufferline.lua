--- bufferline mapping
vim.keymap.set("n", "<leader>x", function()
  vim.cmd("bdelete")
end)



vim.keymap.set("n", "<leader>h", function()
  vim.cmd("BufferLineCyclePrev")
end)

vim.keymap.set("n", "<leader>l", function()
  vim.cmd("BufferLineCycleNext")
end)
