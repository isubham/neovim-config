
vim.keymap.set("n", "<leader>y", function()
  require("yazi").toggle()
end, { noremap = true, silent = true })

