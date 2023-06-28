return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          "typescript",
          "javascript",
          "python",
          "rust",
          "go",
          "lua",
          "bash",
          "html",
          "css",
          "vim",
          "yaml",
          "ini",
          "dart",
          "cpp",
          "tsx",
          "graphql",
          "c",
          "json",
          "dockerfile",
          "markdown",
          "diff"
        },
        highlight = {
          enable = true,
        },
      }
    end,
}
