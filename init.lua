vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.lsp.inlay_hint.enable()
vim.diagnostic.config({
    virtual_text = {
        prefix = "!",  -- can be "■", "●", "▎", "x"
        spacing = 2,
    },
    textDocument = {
        semanticTokens = {
            multilineTokenSupport = true,
        },
    },
    severity_sort = true,
    update_in_insert = false,
    underline = true,
    signs = true,
})
vim.opt.clipboard = "unnamedplus"

vim.g.mapleader = "."

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

local plugins = {
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
    },
    {
        "nvim-telescope/telescope.nvim"
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",

            "nvim-telescope/telescope.nvim",
        },
    },
    {
        "lewis6991/gitsigns.nvim",
    },
    {
        'mrcjkb/rustaceanvim',
        lazy = false,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require'nvim-treesitter.configs'.setup {
                ensure_installed = { "rust", "c", "cpp" },
                highlight = {
                    enable = true,              -- false will disable the whole extension
                    additional_vim_regex_highlighting = false,
                },
            }
        end
    },
    --[{
    --    "hrsh7th/nvim-cmp",
    --    dependencies = {
    --       "hrsh7th/cmp-nvim-lsp",
    --        "L3MON4D3/LuaSnip",
    --        "saadparwaiz1/cmp_luasnip",
    --    },
    --    lazy = false,
    --},
}
local opts = {}

require("lazy").setup(plugins, opts)

require("onedarkpro").setup({
    colors = {
        bg = "#111111",
    }
})

vim.cmd("colorscheme onedark_dark")

local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close
            },
        },
    },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fd', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = 'Telescope git files' })

require('neogit').setup {
    kind = "split"
}

vim.keymap.set(
  "n", 
  "<leader>.", 
  function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    -- or vim.lsp.buf.codeAction() if you don't want grouping.
  end,
  { silent = true, buffer = bufnr }
)
vim.g.rustaceanvim = {
    server = {
        settings = {
            ["rust-analyzer"] = {
                check = {
                    command = "clippy",
                    features = "all",
                    extraArgs = { "--target-dir", "./target/rust-analyzer" },
                },
                diagnostics = {
                    enable = true,
                },
            },
        },
    },
}

