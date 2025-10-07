vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

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
    }
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
    file_ignore_patterns = { ".git/" }
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })

