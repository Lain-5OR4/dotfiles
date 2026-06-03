return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('telescope').setup{
            defaults = { prompt_prefix = "🔭>" },
        }
    	local builtin = require('telescope.builtin')
        -- LSPが有効なバッファでのみ有効にする設定
        vim.api.nvim_create_autocmd('LspAttach', {
          callback = function(ev)
            local opts = { buffer = ev.buf }
            -- 常に一覧を出したい場合は jump_type="never" を追加
            vim.keymap.set('n', 'gd', function() builtin.lsp_definitions({ jump_type="never" }) end, opts)
            vim.keymap.set('n', 'gr', builtin.lsp_references, opts)
            vim.keymap.set('n', 'gi', builtin.lsp_implementations, opts)
            vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, opts)
            -- 標準のLSP機能を使うもの
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          end,
        })
        -- vim.keymap.set('n', '<Space>ff', builtin.find_files, {})
    end,
}
