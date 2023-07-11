return {
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = function()
            local nu = require("null-ls")
            nu.setup({
                sources = { nu.builtins.formatting.eslint.with ({ prefer_local = "node_modules/.bin", }),
                nu.builtins.formatting.prettier,
                },
            })
        end,
    },
}
