return {
    { "tree-sitter/tree-sitter-html", ft = "html" },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPre",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "lua", "python", "javascript" },
                auto_install = false,
                highlight = { enable = true },
                indent = { enable = true },
                sync_install = false,
            })
        end,
    },
    { "nvim-treesitter/nvim-treesitter-context", event = "BufReadPre", submodules = false },
    {
        "windwp/nvim-ts-autotag",
        event = "BufReadPre",
        ft = { "html", "javascriptreact", "typescriptreact", "xml", "jsx", "tsx" },
        config = function()
            require("nvim-ts-autotag").setup({
                ft = { "html", "xml", "jsx", "tsx", "javascriptreact", "typescriptreact" },
                opts = { enable_close = true, enable_rename = true, enable_close_on_slash = false },
                per_filetype = { ["html"] = { enable_close = true } },
            })
        end
    },
}
