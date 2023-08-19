return {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup{
            defaults = { prompt_prefix = "🔭>" },
        }
    	local builtin = require('telescope.builtin')
    	vim.keymap.set('n', '<Space>ff', builtin.find_files, {})
    end,
}
