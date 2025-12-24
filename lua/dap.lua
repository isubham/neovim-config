local dap = require('dap')

print("setting dap")

-- Node.js adapter
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { os.getenv("HOME") .. '/.local/share/nvim/dap-vscode-js/out/src/nodeDebug.js' },
}

-- JS/TS configuration
dap.configurations.javascript = {
  {
    type = 'node2',
    request = 'launch',
    name = 'Launch Node',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
}

-- For TypeScript, same config but with ts-node
dap.configurations.typescript = {
  {
    type = 'node2',
    request = 'launch',
    name = 'Launch TS',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    runtimeArgs = { '-r', 'ts-node/register' },
    console = 'integratedTerminal',
  },
}

local dapui = require('dapui')
dapui.setup()

vim.keymap.set('n', '<F5>', dap.continue, { desc = "Start/Continue" })
vim.keymap.set('n', '<F10>', dap.step_over, { desc = "Step Over" })
vim.keymap.set('n', '<F11>', dap.step_into, { desc = "Step Into" })
vim.keymap.set('n', '<F12>', dap.step_out, { desc = "Step Out" })
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = "Open REPL" })
vim.keymap.set('n', '<leader>du', dapui.toggle, { desc = "Toggle DAP UI" })


