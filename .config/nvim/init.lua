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
  print(lazypath)
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup("plugins", opts) -- load lua/plugins/*.lua

-- normal settings
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.textwidth = 0
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.clipboard = "unnamedplus"
vim.opt.whichwrap = "b,s,[,],<,>"
-- vim.opt.syntax = "on"
vim.opt.termguicolors = true -- for iceberg colorscheme
vim.opt.swapfile = false

-- keymap
vim.keymap.set('i','jj','<Esc>')

