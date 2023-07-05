return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate", -- :MasonUpdate updates registry contents
        init = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            { "williamboman/mason.nvim" },
            { "neovim/nvim-lspconfig" },
        },
        init = function()
            require("mason-lspconfig").setup()
            require("lspconfig").rust_analyzer.setup {}
        end,
    },
    -- {
    --     'neovim/nvim-lspconfig',
    --     init = function()
    --       require('lspconfig') -- load lsp config
    --     end,
    --     dependencies = {
    --       'nvim-lua/lsp-status.nvim',
    --     }
    -- },
}
