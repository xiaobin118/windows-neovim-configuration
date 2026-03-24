return {
    -- Markdown / HTML / CSS
    -- { "rstacruz/sparkup", ft = { "html", "css" } },
    {
        "OXY2DEV/markview.nvim",
        ft = "markdown",
        config = function()
            require("markview").setup()
        end,
    },
    -- {
    -- "iamcco/markdown-preview.nvim",
    -- cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    -- ft = { "markdown" },
    -- build = function() vim.fn["mkdp#util#install"]() end,
    -- },
    -- { "vim-scripts/synmark.vim", event = "VeryLazy" },

    -- JS
    { "pangloss/vim-javascript",     ft = "javascript" },

    -- SQL
    { "vim-scripts/SQLComplete.vim", ft = "sql" },

    -- Latex
    {
        "lervag/vimtex",
        lazy = false,
        ft = { "tex", "latex" },
        init = function()
            vim.g.vimtex_view_method = "general"
            vim.g.vimtex_view_sumatrapdf_exe = [[D:\SumatraPDF\SumatraPDF.exe]]
            vim.g.vimtex_view_sumatrapdf_options = "-reuse-instance -forward-search @tex @line @pdf"
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                build_dir = "",
                options = { "-xelatex", "-interaction=nonstopmode", "-synctex=1", "-file-line-error" },
            }
        end,
    },

    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
            settings = {
                -- spawn additional tsserver instance to calculate diagnostics on it
                separate_diagnostic_server = true,

                -- "change"|"insert_leave" determine when the client asks the server about diagnostic
                publish_diagnostic_on = "insert_leave",

                -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
                -- "remove_unused_imports"|"organize_imports") -- or string "all"
                -- to include all supported code actions
                -- specify commands exposed as code_actions
                expose_as_code_action = "all", -- CHANGED: "all" is usually better than {}

                -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
                -- not exists then standard path resolution strategy is applied
                tsserver_path = nil,

                -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
                -- (see 💅 `styled-components` support section)
                tsserver_plugins = {},

                -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
                -- memory limit in megabytes or "auto"(basically no limit)
                tsserver_max_memory = "auto",

                -- described below
                tsserver_format_options = {},
                tsserver_file_preferences = {},

                -- locale of all tsserver messages, supported locales you can find here:
                -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
                tsserver_locale = "en",

                -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
                complete_function_calls = false,
                include_completions_with_insert_text = true,

                -- CodeLens
                -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
                -- possible values: ("off"|"all"|"implementations_only"|"references_only")
                code_lens = "off",

                -- by default code lenses are displayed on all referencable values and for some of you it can
                -- be too much this option reduce count of them by removing member references from lenses
                disable_member_code_lens = true,

                -- JSXCloseTag
                -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
                -- that maybe have a conflict if enable this feature. )
                jsx_close_tag = {
                    enable = false,
                    filetypes = { "javascriptreact", "typescriptreact" },
                }
            },
        },
    },

    {
        "tpope/vim-dadbod",
        lazy = true,
        event = "VeryLazy",
        ft = { "sql", "mysql", "plsql" },
        keys = {
            vim.keymap.set("v", "<leader>rs", ":DB<CR>", { desc = "DB: run selection" })
        }
    },

    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = { "tpope/vim-dadbod" },
        event = "VeryLazy",
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
        init = function()
            -- Where DBUI stores UI state (Windows path is fine)
            vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "\\db_ui"
            -- Optional: auto-execute queries in a new split
            vim.g.db_ui_execute_on_save = 0
        end,
    },

    {
        "kristijanhusak/vim-dadbod-completion",
        dependencies = { "tpope/vim-dadbod" },
        event = "VeryLazy",
        ft = { "sql", "mysql", "plsql" },
        init = function()
            -- Use omni completion (<C-x><C-o>) or wire into nvim-cmp if you use it
            vim.g.dadbod_completion_mark = "DB"
        end,
    },

}
