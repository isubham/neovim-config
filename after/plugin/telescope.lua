local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

vim.keymap.set('n', '<leader><leader>', builtin.git_files, {})

vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})

vim.keymap.set('n', '<leader>b', function()

  builtin.find_files {
    cwd = vim.cmd("buffers")
  }

end)

