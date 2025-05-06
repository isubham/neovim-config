
vim.keymap.set("n", "<leader>n", function()
  require("yazi").toggle()
end, { noremap = true, silent = true })

