-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

map('n', 'qq', '<CMD>q!<CR>')
map('n', '<leader>qq', '<CMD>qa!<CR>')
map('n', '<leader><cr>', '<CMD>noh<CR>')
map('n', '<leader>w', '<CMD>wa<CR>')
