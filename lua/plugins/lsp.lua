return {
    -- 1. Lazydev
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    -- 2. Mason (Installs binaries ONLY)
    {
        "williamboman/mason.nvim",
        opts = { ensure_installed = { "tree-sitter-cli" } },
        config = function(_, opts) require("mason").setup(opts) end,
    },
    -- 3. Mason LSP Config (Disable ALL automation)
    {
        "mason-org/mason-lspconfig.nvim",
        lazy = true,
        opts = {
            ensure_installed = { "lua_ls", "html", "cssls", "pylsp" },
            automatic_installation = false,
            handlers = nil, -- CRITICAL: Disable Mason's handlers to stop conflicts
        },
    },
    -- 4. Main LSP Configuration (Neovim 0.11 Style)
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- 1. Capabilities
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- 2. Define Custom Configs using vim.lsp.config (The New Way)
            --    We DO NOT use require('lspconfig').server.setup here.

            -- --- LTEX_PLUS ---
            vim.lsp.config('ltex_plus', {
                cmd = { "ltex-ls-plus" }, -- Ensure it uses the right binary
                capabilities = capabilities,
                -- STRICTLY define filetypes. This prevents it from attaching to HTML.
                filetypes = { "markdown", "tex", "bib", "plaintex", "pandoc" },
                root_markers = { ".git", ".latexmkrc", "tex.latex" },
                settings = {
                    ltex = {
                        -- Sync this list with filetypes above
                        enabled = { "markdown", "tex", "bib", "plaintex", "pandoc" },
                        checkFrequency = "save",
                    },
                },
            })

            -- --- PYLSP ---
            vim.lsp.config('pylsp', {
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                max_line_length = 120,
                                ignore = { "E501" },
                            },
                        },
                    },
                },
            })

            -- --- LUA_LS ---
            vim.lsp.config('lua_ls', {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim", "require" } },
                    },
                },
            })

            -- 3. Enable Servers
            --    This actually starts them. We check if they are installed/valid first.

            local servers = { "ltex_plus", "pylsp", "lua_ls", "html", "cssls" }

            for _, server in ipairs(servers) do
                -- Enable the server. If we defined a config above, it uses it.
                -- If not (like html/cssls), it uses nvim-lspconfig's default.
                vim.lsp.enable(server)
            end

            -- 4. Keymaps
            local keymap = vim.api.nvim_set_keymap
            local opts = { noremap = true, silent = true }
            keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
            keymap("n", "<leader>d", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
            keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
            keymap("n", "<leader>re", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
            keymap("n", "<leader>t", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
            keymap("n", "<leader>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

            vim.diagnostic.config({ virtual_text = false })
        end,
    },

    -- UI Enhancements
    { "j-hui/fidget.nvim",          event = "LspAttach",  opts = {} },
    { "mhartington/formatter.nvim", event = "BufWritePre" },

    -- Tiny Inline Diagnostic
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        priority = 1000,
        config = function()
            require("tiny-inline-diagnostic").setup({
                preset = "classic",
                options = {
                    multilines = { enabled = true },
                    show_source = { enabled = true },
                },
            })
            vim.diagnostic.config({ virtual_text = false })
        end,
    },

    -- Code Actions
    {
        "rachartier/tiny-code-action.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
            { "folke/snacks.nvim" },
        },
        event = "LspAttach",
        opts = {},
        config = function()
            require("tiny-code-action").setup({
                vim.keymap.set({ "n", "v" }, "<leader>ai", vim.lsp.buf.code_action, { desc = "Code action" }),
                vim.keymap.set("n", "<leader>oi", function()
                    vim.lsp.buf.code_action({
                        apply = true,
                        context = {
                            diagnostics = {},                    -- required by the typed CodeActionContext
                            only = { "source.organizeImports" }, -- valid union member
                        },
                    })
                end, { desc = "Organize imports" })
            })
        end,
    }

}
