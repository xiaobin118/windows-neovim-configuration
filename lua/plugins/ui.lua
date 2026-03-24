return {
    -- Themes
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },

    -- Tailwind Tools (RESTORED)
    -- {
    -- "luckasRanarison/tailwind-tools.nvim",
    -- name = "tailwind-tools",
    -- build = ":UpdateRemotePlugins",
    -- dependencies = {
    -- "nvim-treesitter/nvim-treesitter",
    -- "nvim-telescope/telescope.nvim",
    -- "neovim/nvim-lspconfig",
    -- },
    -- opts = {},
    -- ft = { "css" },
    -- event = "BufReadPre",
    -- },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "AndreM222/copilot-lualine" },
        config = function()
            require("lualine").setup({
                options = {
                    theme = "catppuccin",
                    icons_enabled = true,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {},
                    always_divide_middle = true,
                    show_colors = true,
                },
                sections = {
                    lualine_a = {},
                    lualine_b = {
                        "branch",
                        "diff",
                        {
                            "diagnostics",
                            sources = { "nvim_diagnostic" },
                            symbols = { error = " ", warn = " ", info = " ", hint = " " },
                        },
                    },
                    lualine_c = { "filename" },
                    lualine_x = { "copilot", "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                },
            })
        end,
    },

    -- Bufferline
    {
        "romgrk/barbar.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-web-devicons" },
        init = function()
            vim.g.barbar_auto_setup = false
        end,
    },

    -- UI Enhancements
    { "MunifTanjim/nui.nvim",        lazy = true },

    -- Smear Cursor
    {
        "sphamba/smear-cursor.nvim",
        event = "VeryLazy",
        config = function()
            require("smear_cursor").setup({
                enabled = false,
            })
        end,
    },

    -- Tiny Glimmer
    {
        "rachartier/tiny-glimmer.nvim",
        event = "VeryLazy",
        priority = 10,
        opts = {},
        config = function()
            require("tiny-glimmer").setup({})
        end,
    },

    -- Transparent
    {
        "xiyaowong/transparent.nvim",
        lazy = false,
        config = function()
            require("transparent").setup({
                groups = {
                    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
                    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
                    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
                    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
                    'EndOfBuffer',
                },
                -- table: additional groups that should be cleared
                extra_groups = {},
                -- table: groups you don't want to clear
                exclude_groups = {},
                -- function: code to be executed after highlight groups are cleared
                -- Also the user event "TransparentClear" will be triggered
                on_clear = function() end
            })
        end,
    },

    -- Colors
    {
        "brenoprata10/nvim-highlight-colors",
        ft = { "css", "scss", "html", "javascript", "typescript", "lua" },
        config = function()
            require("nvim-highlight-colors").setup({
                render = "background",
                filetypes = { "css", "html", "javascript", "javascriptreact", "vue", "lua" },
                enable_named_colors = true,
                enable_tailwind = true,
            })
        end,
    },

    -- Indent Guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            local highlight = {
                "BlueLight", "Blue", "Cobalt", "Indigo", "Violet", "Purple", "DeepPurple",
            }
            local hooks = require("ibl.hooks")
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "BlueLight", { fg = "#8AB4F8" })
                vim.api.nvim_set_hl(0, "Blue", { fg = "#61AFEF" })
                vim.api.nvim_set_hl(0, "Cobalt", { fg = "#5C6BC0" })
                vim.api.nvim_set_hl(0, "Indigo", { fg = "#7986CB" })
                vim.api.nvim_set_hl(0, "Violet", { fg = "#9C27B0" })
                vim.api.nvim_set_hl(0, "Purple", { fg = "#BA68C0" })
                vim.api.nvim_set_hl(0, "DeepPurple", { fg = "#AB47B0" })
            end)
            require("ibl").setup({
                indent = {
                    highlight = highlight
                },
            })
        end,
    },

    -- Showkeys
    { "nvzone/showkeys", event = "VeryLazy", config = function() require("showkeys").setup({ position = "top-right" }) end },
}
