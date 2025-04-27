-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.6',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

	use({ 
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	})
	use( 'nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
	use( 'theprimeagen/harpoon')
	use('mbbill/undotree')
	use('lervag/vimtex')
	use('SirVer/ultisnips')

	--- Auto completion with YCM ---
	use('ycm-core/YouCompleteMe')
	--- 	Important 	---
	-- When installing YCM the server does not work initially, since it requires a build.
	-- To do this complete the following steps
	-- 
	-- 1. cd into packer dir
	-- 	cd ~/.local/share/nvim/site/pack/packer/start/YouCompleteMe
	-- 
	-- 2. Deactivate conda since ycm needs another python intallation
	-- 	conda deactivate
	--
	-- 3. Run install script to build
	--	 python3 install.py --all
	use("Pocco81/auto-save.nvim")
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
  use('goolord/alpha-nvim')
  use('williamboman/mason.nvim')
  use('williamboman/mason-lspconfig.nvim')
  use('neovim/nvim-lspconfig')
end)
