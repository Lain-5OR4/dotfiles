-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------
-- Important settings to load prior to package installation
-- termguicolors -> colorizer throws an error
-- fileencoding -> If not set first, "modifiable is off" during package installation

vim.opt.termguicolors = true
vim.opt.fileencoding = 'utf-8'
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.textwidth = 0
vim.opt.autoindent = true
vim.opt.hlsearch = true
vim.opt.clipboard = "unnamedplus"
vim.opt.whichwrap = "b,s,[,],<,>"
vim.opt.ignorecase = true
vim.opt.mouse = "a"
vim.opt.hidden = true
vim.opt.number = true
vim.wo.number = true
--vim.opt.syntax = "on"
vim.opt.swapfile = false
vim.opt.list = true
vim.opt.listchars = { tab = ">.", trail = '-', extends = '>', precedes = '<', nbsp = '%', eol = '↵' }
