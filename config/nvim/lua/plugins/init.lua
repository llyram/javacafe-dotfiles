local fn = vim.fn

local dir = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(dir)) > 0 then
  bootstrap =
    fn.system(
    {
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      dir
    }
  )
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

vim.cmd(
  [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]
)

local present, packer = pcall(require, "packer")
if not present then
  return
end

packer.init(
  {
    display = {
      open_fn = function()
        return require("packer.util").float({border = "rounded"})
      end
    }
  }
)

return packer.startup(
  function(use)
    use("nvim-lua/plenary.nvim")

    use("ap/vim-css-color")
    use("folke/which-key.nvim")
    use("famiu/bufdelete.nvim")
    use("lambdalisue/suda.vim")
    use("rcarriga/nvim-notify")
    use("windwp/nvim-autopairs")
    use("windwp/nvim-ts-autotag")
    use("wbthomason/packer.nvim")
    use("akinsho/toggleterm.nvim")
    use("lukas-reineke/indent-blankline.nvim")

    -- Tab/Status/Tree
    use {
      "akinsho/bufferline.nvim",
      tag = "v1.2.0",
      require = 'kyazdani42/nvim-web-devicons',
    }

    use("kyazdani42/nvim-tree.lua")
    use("nvim-lualine/lualine.nvim")
    use("kyazdani42/nvim-web-devicons")

    -- Completion
    use("hrsh7th/nvim-cmp")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/cmp-cmdline")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-nvim-lsp-signature-help")

    -- Snippets
    use("L3MON4D3/LuaSnip")
    use("rafamadriz/friendly-snippets")

    -- LSP
    use("stevearc/aerial.nvim")
    use("onsails/lspkind-nvim")
    use("neovim/nvim-lspconfig")
    use("sgur/vim-editorconfig")
    use("kosayoda/nvim-lightbulb")
    use("mhartington/formatter.nvim")
    use("williamboman/nvim-lsp-installer")

    -- Telescope
    use("nvim-telescope/telescope.nvim")
    use("nvim-telescope/telescope-ui-select.nvim")
    use("nvim-telescope/telescope-media-files.nvim")
    use({"nvim-telescope/telescope-fzf-native.nvim", run = "make"})
    use({"AckslD/nvim-neoclip.lua", requires = {"nvim-telescope/telescope.nvim"}})

    -- Treesitter
    use(
      {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
      }
    )

    use(
      {
        "iamcco/markdown-preview.nvim",
        run = "cd app && yarn install"
      }
    )

    -- Git
    use("airblade/vim-gitgutter")

    -- Comments
    use(
      {
        "numToStr/Comment.nvim",
        config = function()
          require("Comment").setup()
        end
      }
    )

    use(
      {
        "norcalli/nvim-colorizer.lua", 
        config = function()
          require("colorizer").setup()
        end
      }
    )
    
    -- Zen
    use(
      {
        "folke/zen-mode.nvim",
        config = function()
          require("zen-mode").setup({})
        end
      }
    )
    use(
      {
        "folke/twilight.nvim",
        config = function()
          require("twilight").setup({})
        end
      }
    )

    -- Folds
    use("anuvyklack/pretty-fold.nvim")

    -- Startup and Session
    use("goolord/alpha-nvim")
    use(
      {
        "Shatur/neovim-session-manager",
        requires = {"nvim-telescope/telescope.nvim"}
      }
    )

    -- Langs
    use("jxnblk/vim-mdx-js")

    if bootstrap then
      require("packer").sync()
    end
  end
)
