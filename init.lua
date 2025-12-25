--[[
]]

vim.g.mapleader = " "
vim.g.maplocalleader = " "


local function customizations()
  --- registers
  -- copy and paste from system clipboard
  vim.opt.clipboard = "unnamedplus"

  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.softtabstop = 2
  vim.opt.expandtab = true
  vim.o.number = true
  -- search
  -- ignore node_modules and .git
  vim.opt.grepprg = "rg --vimgrep --smart-case --hidden --glob '!.git/*' --glob '!node_modules/*'"

  vim.opt.path:append("**")

  vim.opt.wildignore:append({
    "**/.git/**",
    "**/node_modules/**",
  })
end


local function keyMaps()
  -- keymaps
  -- n -> normal, t -> terminal mode
  -- leader key

  -- save
  vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true })
  vim.keymap.set("n", "<leader>q", ":q<CR>", { silent = true })

  -- config reload
  vim.keymap.set("n", "<leader>r", function()
    vim.cmd("source ~/.config/nvim/init.lua")
  end)

  -- window split
  vim.keymap.set("n", "<leader>ws", ":split<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { noremap = true, silent = true })

  -- window close
  vim.keymap.set("n", "<leader>wq", [[<C-w>q]], { noremap = true, silent = true })

  -- buffer switch
  vim.keymap.set("n", "<leader>h", ":bprev<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>l", ":bnext<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>d", ":bdelete<CR>", { noremap = true, silent = true })



  -- window switch
  vim.keymap.set("n", "<leader>wh", [[<C-w>h]], { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>wl", [[<C-w>l]], { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>wk", [[<C-w>k]], { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>wj", [[<C-w>j]], { noremap = true, silent = true })

  -- Window resize (leader + r + hjkl)
  vim.keymap.set("n", "<leader>rh", "<cmd>vertical resize -5<CR>", { silent = true })
  vim.keymap.set("n", "<leader>rl", "<cmd>vertical resize +5<CR>", { silent = true })
  vim.keymap.set("n", "<leader>rj", "<cmd>resize +5<CR>", { silent = true })
  vim.keymap.set("n", "<leader>rk", "<cmd>resize -5<CR>", { silent = true })


  -- tabs
  -- open/close
  vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>")
  vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>")

  -- movement
  vim.keymap.set("n", "<leader>th", "<cmd>tabprevious<CR>")
  vim.keymap.set("n", "<leader>tl", "<cmd>tabnext<CR>")

  -- open terminal, config
  vim.keymap.set("n", "<leader>tt", "<cmd>tabnew<CR><cmd>terminal<CR>")
  vim.keymap.set("n", "<leader>ti", "<cmd>tabnew<CR><cmd>edit ~/.config/nvim/init.lua<CR>")

  -- terminal mode
  vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
  vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
  vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
  vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
  vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })

  -- editor layout
  -- toggle line number
  vim.keymap.set("n", "<leader>sl", function()
    vim.o.number = not vim.o.number
  end)
end

local function setupLSP()
  local function enable_format_on_save(client, bufnr)
    -- only if this LSP supports formatting
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            bufnr = bufnr,
            timeout_ms = 2000,
          })
        end,
        desc = "LSP format on save",
      })
    end
  end

  local function setupLSPKeymaps(opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
  end


  -- LSP configuration
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
      local opts = { buffer = ev.buf }
      setupLSPKeymaps(opts)

      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      -- enable_format_on_save(client, ev.buf)
    end,
  })

  --- lua lsp
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
      vim.lsp.start({
        name = "lua_ls",
        cmd = { "lua-language-server" },
        root_dir = vim.fs.root(0, { ".git", ".luarc.json" }),
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })
    end,
  })

  -- typescript lsp
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    callback = function()
      -- vim.lsp.start({
      --   name = "ts_ls",
      --   cmd = { "typescript-language-server", "--stdio" },
      --   root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", ".git" }),
      -- })
      vim.lsp.start({
        name = "tsgo",
        cmd = { "tsgo", "--lsp", "--stdio" },
        root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", ".git" }),
      })
    end,
  })

  -- some lsp customizations
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })
end


local function setupTelescope()
  -- package manager
  --[[
  mkdir -p ~/.local/share/nvim/site/pack/plugins/start
  cd ~/.local/share/nvim/site/pack/plugins/start
  git clone https://github.com/nvim-lua/plenary.nvim
  git clone https://github.com/nvim-telescope/telescope.nvim
  ]]

  -- telescope
  require("telescope").setup({
    defaults = {
      file_ignore_patterns = {
        "node_modules",
        ".git/",
      },
    },
  })

  local builtin = require("telescope.builtin")

  vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
  vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help" })
  --[[
  -- preview scrolling
  <C-d> / <C-u>

  -- Open file in split
  <C-x>  horizontal
  <C-v>  vertical
  <C-t>  tab
  ]]
end

local function setupTreeSitter()
  --- treesitter config
  require("nvim-treesitter").setup {
    ensure_installed = { "lua", "javascript", "typescript", "tsx", "go", "scss", "jsdoc" }, -- languages
    highlight = {
      enable = true,                                      -- enable TS-based highlighting
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
  }
end


local function setupYazi()
  -- 1. Initialize the plugin (required even for manual installs)
  require('yazi').setup({
    open_for_directories = true,
  })

  -- 2. Your custom function
  local function open_yazi()
    require('yazi').yazi()
  end

  -- 3. The keymap
  vim.keymap.set("n", "<leader>n", open_yazi, { desc = "Open Yazi" })
end

local function setupColorScheme()
  require('nightfox').setup({
    options = {
      -- true black background for that M1/OLED look
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = "italic",
        keywords = "bold",
        types = "italic,bold",
      }
    }
  })

  vim.cmd("colorscheme carbonfox")
end

local function setupDAP()

  local dap = require('dap')

  local vimDebugServerFullPath = { os.getenv("HOME") .. "/js-debug/out/src/vsDebugServer.js", "${port}" }
  print(vimDebugServerFullPath)

  -- 1. Configure the Adapter
  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      -- Path to the binary you just built
      args = { os.getenv("HOME") .. "/js-debug/src/nodeDebug.js", "${port}" },
    }
  }

  -- 2. Configure the Language
  -- for _, language in ipairs({ "typescript", "javascript", "typescriptreact" }) do
  --   dap.configurations[language] = {
  --     {
  --       type = "pwa-node",
  --       request = "launch",
  --       name = "Launch file",
  --       program = "${file}",
  --       cwd = "${workspaceRoot}",
  --     },
  --     {
  --       type = "pwa-node",
  --       request = "attach",
  --       name = "Attach",
  --       processId = require'dap.utils'.pick_process,
  --       cwd = "${workspaceRoot}",
  --     }
  --   }


  -- end

  dap.configurations.typescript = {
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to Bun",
      -- Bun's default inspect port is 6499
      address = "localhost",
      port = 6499,
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
    }
  }

  -- Optional: Add this so JavaScript files can use the same config
  -- dap.configurations.javascript = dap.configurations.typescript

  local function setupNodeDap()
    dap.adapters.node2 = {
      type = 'executable',
      command = 'node',
      args = {os.getenv('HOME') .. '/js-debug/out/src/nodeDebug.js'},
    }
    dap.configurations.javascript = {
      {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
      },
      {
        -- For this to work you need to make sure the node process is started with the `--inspect` flag.
        name = 'Attach to process',
        type = 'node2',
        request = 'attach',
        processId = require'dap.utils'.pick_process,
      },
    }
  end

  setupNodeDap()

  -- 3. UI and Keymaps
  require("nvim-dap-virtual-text").setup()
  local dapui = require("dapui")
  dapui.setup()

  -- Auto-open UI when debugging starts
  dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
  dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end

  vim.keymap.set('n', '<leader>dc', function() dap.continue() end)
  vim.keymap.set('n', '<leader>dj', function() dap.step_over() end)
  vim.keymap.set('n', '<leader>dl', function() dap.step_into() end)
  vim.keymap.set('n', '<leader>dk', function() dap.step_out() end)
  vim.keymap.set('n', '<leader>dh', function() dap.toggle_breakpoint() end)

end

local function setupLazy()

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
end

local function installPackages()
  require("lazy").setup({
    -- 1. Theme
    {
      "EdenEast/nightfox.nvim",
    },

    -- 2. Syntax & Parsing
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      lazy = false,
    },

    -- 3. Fuzzy Finder
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- 4. Debugging (DAP)
    {
      "mfussenegger/nvim-dap",
      dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
      },
    },

    -- 5. File Manager
    {
      "mikavilpas/yazi.nvim",
      event = "VeryLazy",
      opts = { open_for_directories = true },
    },

    { 'wakatime/vim-wakatime', lazy = false }
  })
end

local function init()
  customizations()
  keyMaps()
  setupLazy()
  installPackages()
  setupLSP()
  setupTelescope()
  setupTreeSitter()
  setupYazi()
  setupColorScheme()
  setupDAP()
end

init()
