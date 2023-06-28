-- statusline
-- themes: https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
return {
    {
        'nvim-lualine/lualine.nvim',
        init = function()
            require('lualine').setup{
            	options = { theme = 'palenight' }
            }
        end,
    },
}
