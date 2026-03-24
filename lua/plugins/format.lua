return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    -- Web / React
                    javascript = { "prettier" },
                    javascriptreact = { "prettier" },
                    typescript = { "prettier" },
                    typescriptreact = { "prettier" },
                    html = { "prettier" },
                    css = { "prettier" },
                    json = { "prettier" },
                    yaml = { "prettier" },
                    markdown = { "prettier" },

                    -- Lua
                    lua = { "stylua" },

                    -- Python
                    python = { "autopep8" },

                    -- Shell
                    sh = { "beautysh" },

                    -- LaTeX
                    tex = { "latexindent" },
                },

                format_on_save = {
                    timeout_ms = 1000,
                    lsp_format = "fallback",
                },

                -- Configure formatters for 4-space indentation
                formatters = {
                    -- Configure stylua for 4-space indentation
                    stylua = {
                        prepend_args = {
                            "--indent-type", "Spaces",
                            "--indent-width", "4"
                        },
                    },

                    -- Configure prettier for 4-space indentation
                    prettier = {
                        prepend_args = {
                            "--tab-width", "4",
                            "--use-tabs", "false"
                        },
                    },

                    -- Configure autopep8 for 4-space indentation
                    autopep8 = {
                        prepend_args = {
                            "--indent-size", "4"
                        },
                    },

                    -- Configure beautysh for 4-space indentation
                    beautysh = {
                        prepend_args = {
                            "--indent-size", "4"
                        },
                    },

                    -- Configure latexindent for 4-space indentation
                    latexindent = {
                        prepend_args = {
                            "--yaml", "defaultIndent: '    '"
                        },
                    },
                },
            })

            -- Set vim options for 4-space indentation
            vim.opt.tabstop = 4      -- Number of spaces that a <Tab> counts for
            vim.opt.shiftwidth = 4   -- Number of spaces to use for each step of (auto)indent
            vim.opt.expandtab = true -- Use spaces instead of tabs
            vim.opt.softtabstop = 4  -- Number of spaces that a <Tab> counts for while editing
        end,
    },
}
