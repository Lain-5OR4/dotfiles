-- statusline
-- themes: https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
return {
    {
        'nvim-lualine/lualine.nvim',
        init = function()
            require('lualine').setup{
            	-- options = { theme = 'palenight' }
            	options = { theme = 'everforest' },
                sections = {
                    lualine_a = {'mode'},
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {'filename'},
                    lualine_x = {'encoding', 'fileformat', 'filetype'},
                    lualine_y = {},--{'progress'}, 
                    lualine_z = {'location'}
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {'progress'},
                    lualine_z = {}
                },
            }
        end,
    },
}
