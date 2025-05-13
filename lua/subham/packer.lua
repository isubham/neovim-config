-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- fuzzy search
  use {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
  	-- or                   , branch = '0.1.x',
  	requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- colorscheme
  use({
	'rose-pine/neovim',
	as = 'rose-pine',
	config = function()
		vim.cmd('colorscheme rose-pine')
	end
})

use( 'nvim-treesitter/nvim-treesitter', {run= ':TSUpdate'})

-- playground
use('nvim-treesitter/playground')


use('mbbill/undotree')

use('tpope/vim-fugitive')

use {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  requires = {
    -- LSP Support
    {'neovim/nvim-lspconfig'},             -- Required
    {                                      -- Optional
      'williamboman/mason.nvim',
      run = function()
        vim.cmd('MasonUpdate')
      end,
    },
    {'williamboman/mason-lspconfig.nvim'}, -- Optional

    -- Autocompletion
    {'hrsh7th/nvim-cmp'},     -- Required
    {'hrsh7th/cmp-nvim-lsp'}, -- Required
    {'L3MON4D3/LuaSnip'},     -- Required
  }
}


-- org mode 
use {'nvim-orgmode/orgmode', config = function()
  require('orgmode').setup{}
end
}


-- buffer line 
use {'akinsho/bufferline.nvim',
    tag = "*",
    requires = 'nvim-tree/nvim-web-devicons'
 }

-- powerline
use {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true }
}

-- nightowl
--
use {
  "EdenEast/nightfox.nvim",
  as = 'nightfox',
	config = function()
		vim.cmd('colorscheme nightfox')
	end

}

--
-- yazi
use {
  "mikavilpas/yazi.nvim",
  requires = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim"
  },
  config = function()
    require("yazi").setup()
  end
}

end)



-- TODO dap mode for debugging
--





