--[[
]]

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local is_vscode = vim.g.vscode ~= nil

local VSCODE_ACTIONS = {
  buffers = "workbench.action.showAllEditors",
  close_editor = "workbench.action.closeActiveEditor",
  code_action = "editor.action.quickFix",
  definition = "editor.action.revealDefinition",
  diagnostics_next = "editor.action.marker.next",
  diagnostics_previous = "editor.action.marker.prev",
  explorer = "workbench.view.explorer",
  file_search = "workbench.action.quickOpen",
  find_in_files = "workbench.action.findInFiles",
  focus_down = "workbench.action.focusBelowGroup",
  focus_left = "workbench.action.focusLeftGroup",
  focus_right = "workbench.action.focusRightGroup",
  focus_up = "workbench.action.focusAboveGroup",
  hover = "editor.action.showHover",
  implementation = "editor.action.goToImplementation",
  new_file = "workbench.action.files.newUntitledFile",
  next_editor = "workbench.action.nextEditor",
  previous_editor = "workbench.action.previousEditor",
  references = "editor.action.goToReferences",
  rename = "editor.action.rename",
  save = "workbench.action.files.save",
  split_down = "workbench.action.splitEditorDown",
  split_right = "workbench.action.splitEditorRight",
  terminal = "workbench.action.terminal.toggleTerminal",
  unfold_all = "editor.unfoldAll",
  fold_all = "editor.foldAll",
}


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

local function setupVSCode()
  local vscode = require("vscode")

  local function action(name)
    return function()
      vscode.action(name)
    end
  end

  local function map(modes, lhs, action_name, description)
    vim.keymap.set(modes, lhs, action(action_name), {
      desc = description,
      silent = true,
    })
  end

  map("n", "<leader>w", VSCODE_ACTIONS.save, "Save")
  map("n", "<leader>q", VSCODE_ACTIONS.close_editor, "Close editor")
  map("n", "<leader>ws", VSCODE_ACTIONS.split_down, "Split editor down")
  map("n", "<leader>wv", VSCODE_ACTIONS.split_right, "Split editor right")
  map("n", "<leader>wq", VSCODE_ACTIONS.close_editor, "Close editor")
  map("n", "<leader>h", VSCODE_ACTIONS.previous_editor, "Previous editor")
  map("n", "<leader>l", VSCODE_ACTIONS.next_editor, "Next editor")
  map("n", "<leader>d", VSCODE_ACTIONS.close_editor, "Close editor")
  map("n", "<leader>wh", VSCODE_ACTIONS.focus_left, "Focus left editor group")
  map("n", "<leader>wj", VSCODE_ACTIONS.focus_down, "Focus lower editor group")
  map("n", "<leader>wk", VSCODE_ACTIONS.focus_up, "Focus upper editor group")
  map("n", "<leader>wl", VSCODE_ACTIONS.focus_right, "Focus right editor group")
  map("n", "<leader>tn", VSCODE_ACTIONS.new_file, "New editor")
  map("n", "<leader>tc", VSCODE_ACTIONS.close_editor, "Close editor")
  map("n", "<leader>th", VSCODE_ACTIONS.previous_editor, "Previous editor")
  map("n", "<leader>tl", VSCODE_ACTIONS.next_editor, "Next editor")
  map("n", "<leader>tt", VSCODE_ACTIONS.terminal, "Toggle terminal")
  map("n", "<leader><leader>", VSCODE_ACTIONS.file_search, "Find files")
  map("n", "<leader>fw", VSCODE_ACTIONS.find_in_files, "Find in files")
  map("n", "<leader>fb", VSCODE_ACTIONS.buffers, "Show open editors")
  map("n", "<leader>n", VSCODE_ACTIONS.explorer, "Show Explorer")
  map("n", "-", VSCODE_ACTIONS.explorer, "Show Explorer")
  map("n", "gd", VSCODE_ACTIONS.definition, "Go to definition")
  map("n", "gr", VSCODE_ACTIONS.references, "Go to references")
  map("n", "gi", VSCODE_ACTIONS.implementation, "Go to implementation")
  map("n", "K", VSCODE_ACTIONS.hover, "Show hover")
  map("n", "<leader>rn", VSCODE_ACTIONS.rename, "Rename symbol")
  map({ "n", "x" }, "<leader>ca", VSCODE_ACTIONS.code_action, "Code action")
  map("n", "[d", VSCODE_ACTIONS.diagnostics_previous, "Previous diagnostic")
  map("n", "]d", VSCODE_ACTIONS.diagnostics_next, "Next diagnostic")
  map("n", "zR", VSCODE_ACTIONS.unfold_all, "Unfold all")
  map("n", "zM", VSCODE_ACTIONS.fold_all, "Fold all")
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
    vim.keymap.set('n', '<Leader>d', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
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
       vim.lsp.start({
         name = "ts_ls",
         cmd = { "typescript-language-server", "--stdio" },
         root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", ".git" }),
       })
      -- vim.lsp.start({
      --   name = "tsgo",
      --   cmd = { "tsgo", "--lsp", "--stdio" },
      --   root_dir = vim.fs.root(0, { "package.json", "tsconfig.json", ".git" }),
      -- })
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

local function setupTelescopeBufferSwitcher()
  vim.keymap.set('n', '<leader><Tab>', function()
    require('telescope.builtin').buffers({
      sort_mru = true,              -- Sort by most recently used
      ignore_current_buffer = true, -- Don't show current buffer
      previewer = false,            -- Faster without preview
      layout_config = {
        height = 0.4,
        width = 0.6,
      },
    })
  end, { desc = 'Switch buffers' })

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
      hidden = true,  -- show dot files
    },
    pickers = {
      find_files = {
        hidden = true,  -- Show hidden files in find_files
      },
    },
  })

  local builtin = require("telescope.builtin")

  vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "Live grep" })
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

  setupTelescopeBufferSwitcher()
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
      cond = not is_vscode,
    },

    -- 2. Syntax & Parsing
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
      lazy = false,
      cond = not is_vscode,
    },

    -- 3. Fuzzy Finder
    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      cond = not is_vscode,
    },

    -- 4. Debugging (DAP)
    {
      "mfussenegger/nvim-dap",
      cond = not is_vscode,
      dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "theHamsta/nvim-dap-virtual-text",
      },
    },
    {
      "mason-org/mason.nvim",
      cond = not is_vscode,
      opts = {}
    },
    {
      "mxsdev/nvim-dap-vscode-js",
      cond = not is_vscode,
      dependencies = {
        "mfussenegger/nvim-dap"
      }
    },

    -- 5. File Manager
    {
      "mikavilpas/yazi.nvim",
      event = "VeryLazy",
      cond = not is_vscode,
      opts = { open_for_directories = true },
    },

    -- time spend coding
    {
      'wakatime/vim-wakatime',
      lazy = false,
      cond = not is_vscode,
    },

    -- code folding
    {
      "kevinhwang91/nvim-ufo",
      cond = not is_vscode,
      dependencies = {
        "kevinhwang91/promise-async"
      }
    },

    -- auto complete
    {
      'saghen/blink.cmp',
      version = '*', -- or use latest release
      cond = not is_vscode,
      dependencies = 'rafamadriz/friendly-snippets',
      opts = {
        keymap = { preset = 'default' }, -- Ctrl-space: trigger, Ctrl-y: accept
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        -- Enables auto-brackets for functions
        completion = { accept = { auto_brackets = { enabled = true } } }
      }
    },

    -- file tree
    {
      'stevearc/oil.nvim',
      cond = not is_vscode,
      config = function()
        require("oil").setup({
          default_file_explorer = true,
          view_options = {
          show_hidden = true,
        },
    })

  end,
}

  })
end

local function setupCodeFolding()

    vim.o.foldcolumn = '1' -- Optional: shows fold indicators in the gutter
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Using ufo provider requires remapping zR and zM
    vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
    vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

    require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
            return {'treesitter', 'indent'} -- Use treesitter as main provider
        end
    })
end

local function setupOilFileTree() 
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end



local function setupKeyBinding()

  local group = vim.api.nvim_create_augroup("ReactComponentFolding", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  pattern = { "javascriptreact", "typescriptreact" },
  callback = function(opts)
    vim.keymap.set("n", "<leader>cr", function()
      vim.cmd("normal! zM")
      local original_pos = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_win_set_cursor(0, { 1, 0 })
      local match = vim.fn.search([[\v^\s*return\s*(\(|<)]], "W")
      if match > 0 then
        vim.cmd("normal! zv")
        vim.cmd("normal! zz")
      else
        vim.api.nvim_win_set_cursor(0, original_pos)
      end
    end, { buffer = opts.buf })
  end,
})

end


local function init()
  customizations()
  setupLazy()
  installPackages()

  if is_vscode then
    setupVSCode()
    return
  end

  keyMaps()
  setupLSP()
  -- setupDAP()
  setupTelescope()
  setupTreeSitter()
  setupOilFileTree()
  setupYazi()
  setupColorScheme()
  setupCodeFolding()
  setupKeyBinding()
end

init()
