return {
    { "tree-sitter/tree-sitter-html", ft = "html" },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "BufReadPre",
        config = function()
            local util = require("config.util")
            local candidates = {}
            for _, root in ipairs({ os.getenv("SCOOP"), os.getenv("USERPROFILE") .. "/scoop" }) do
                if root then
                    table.insert(candidates, root .. "/apps/msys2/current/mingw64/bin")
                end
            end
            local gcc = util.find_executable("gcc", candidates)

            if gcc then
                require("nvim-treesitter.install").compilers = { gcc }
            end

            require("nvim-treesitter.configs").setup({
                ensure_installed = { "c", "lua", "python" },
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
