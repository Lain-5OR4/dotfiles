require('base')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup("plugins", opts) -- load lua/plugins/*.lua

-- keymap
vim.keymap.set('i', 'jj', '<Esc>')
vim.keymap.set('n', '<Space>h', '^')
vim.keymap.set('n', '<Space>l', '$')
vim.keymap.set('i', '<C-h>', '<Left>')
vim.keymap.set('i', '<C-j>', '<Down>')
vim.keymap.set('i', '<C-k>', '<Up>')
vim.keymap.set('i', '<C-l>', '<Right>')
vim.keymap.set('n', '<S-Tab>', ':tabnew<CR>')
vim.keymap.set('n', '<Space>n', ':bnext<CR>')
vim.keymap.set('n', '<Space>tt', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<Space>tr', ':NvimTreeRefresh<CR>')
vim.keymap.set('n', '<Space>tff', ':NvimTreeFindFile<CR>')
-- Telescope keymap
vim.keymap.set('n', '<Space>ff', ':Telescope find_files<CR>')
vim.keymap.set('n', '<Space>fg', ':Telescope live_grep<CR>')

vim.cmd("set whichwrap+=<,>,[,],h,l")
