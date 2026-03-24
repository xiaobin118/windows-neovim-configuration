return {
    --  Completions
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
            "kdheepak/cmp-latex-symbols",
            "onsails/lspkind-nvim",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            require("luasnip.loaders.from_vscode").lazy_load()

            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text",
                        symbol_map = { Copilot = "", LazyDev = "" },
                        maxwidth = { menu = 50, abbr = 50 },
                        ellipsis_char = "...",
                        show_labelDetails = true,
                    }),
                },
                sources = cmp.config.sources({
                    { name = "lazydev",  group_index = 0 },
                    { name = "nvim_lsp", group_index = 2 },
                    { name = "luasnip",  group_index = 2 },
                    {
                        name = "buffer",
                        option = {
                            get_bufnrs = function()
                                local bufs = {}
                                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                                    if vim.api.nvim_buf_is_loaded(buf) and vim.fn.buflisted(buf) == 1 then
                                        table.insert(bufs, buf)
                                    end
                                end
                                return bufs
                            end,
                        },
                    },
                    { name = "path" },
                    { name = "latex_symbols" },
                }),
            })
        end,
    },

    -- CMP Vimtex (RESTORED)
    {
        "micangl/cmp-vimtex",
        ft = { "markdown", "tex", "latex" },
        event = "BufReadPre",
    },

    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({ check_ts = true })
        end,
    },
}
