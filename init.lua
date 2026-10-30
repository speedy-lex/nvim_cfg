vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")
vim.cmd("colorscheme unokai")

vim.lsp.inlay_hint.enable()
vim.diagnostic.config({
    virtual_text = {
        prefix = "!",
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
vim.opt.number = true

vim.opt.relativenumber = true

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
        "nvim-tree/nvim-web-devicons" -- nerdfont support
    },
    {
        "nvim-telescope/telescope.nvim",
        config = function()
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
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                options = { theme = 'seoul256' },
            }
        end
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",

            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require('neogit').setup {
                kind = "split"
            }
            vim.keymap.set(
                "n",
                "<leader>gi",
                function()
                    vim.cmd("Neogit")
                end
            )
        end
    },
    {
        "lewis6991/gitsigns.nvim",
    },
    {
        'mrcjkb/rustaceanvim',
        lazy = false,
        config = function()
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
            vim.keymap.set(
                "n", 
                "<leader>.", 
                function()
                    vim.cmd.RustLsp('codeAction')
                end,
                { silent = true, buffer = bufnr }
            )
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        dependencies = {
            "neovim-treesitter/treesitter-parser-registry",
        },
        config = function()
            require("nvim-treesitter").setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            require("nvim-treesitter").install({
                "rust",
                "c",
                "cpp",
                "wgsl",
                "zig",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "rust", "c", "cpp", "wgsl", "zig" },
                callback = function()
                    vim.treesitter.start()
                end,
            })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        config = function()
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            vim.lsp.enable("zls")
            vim.lsp.enable("clangd")
            vim.lsp.enable("lua_ls")
        end,
        dependencies = { 'hrsh7th/nvim-cmp' },
    },
    {
        'L3MON4D3/LuaSnip',
        dependencies = { 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets' },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-k>'] = cmp.mapping.scroll_docs(-4),
                ['<C-j>'] = cmp.mapping.scroll_docs(4),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
            }),
        })

        -- Command-line completions
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
            }, {
                { name = 'cmdline' }
            }),
            matching = { disallow_symbol_nonprefix_matching = false }
        })
        end,
    },
}

local opts = {}

require("lazy").setup(plugins, opts)

