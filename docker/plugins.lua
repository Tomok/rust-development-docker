-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Collection of common configurations for the Nvim LSP client
  use 'neovim/nvim-lspconfig'

  -- Completion framework

  use { 'hrsh7th/nvim-cmp', 
    requries= {'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-vsnip', 'hrsh7th/vim-vsnip', 'hrsh7th/cmp-path', 'hrsh7th/cmp-buffer'}
  }

  --To enable more of the features of rust-analyzer, such as inlay hints and more!
  use 'simrat39/rust-tools.nvim'


  --" Fuzzy finder
  --" Optional
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  --
  --" Color scheme
  use 'arcticicestudio/nord-vim'
  --
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'tpope/vim-fugitive'
  --
  use 'majutsushi/tagbar'
  use 'Raimondi/delimitMate'
  use {
    'saecki/crates.nvim',
    tag = 'v0.2.1'
  }
  --
  use 'ron-rs/ron.vim'
  --
end)

-- other plugins used in the past:
--
--"Plug 'scrooloose/syntastic'
--"Plug 'airblade/vim-gitgutter'
--"Plug 'Valloric/YouCompleteMe'
--"Plug 'neoclide/coc.nvim', {'branch': 'release'}
--
