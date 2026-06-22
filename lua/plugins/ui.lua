return {

    -- 设置默认 colorscheme（在 themery 加载后）
    -- 如果你希望启动时自动应用上次保存的主题，themery 会自动处理
    -- 否则可以这样设置默认主题：
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
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            -- configurations go here
        }
    },

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
            vim.g.barbar_auto_setup = true
            vim.keymap.set("n", "<S-l>", "<Cmd>BufferNext<CR>", { silent = true, noremap = true })
            vim.keymap.set("n", "<S-h>", "<Cmd>BufferPrevious<CR>", { silent = true, noremap = true })
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
    -- Indent Guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
        config = function()
            local highlight = {
                "BlueLight", "Blue", "Cobalt", "Indigo", "Violet", "Purple", "DeepPurple","Coral"
            }

            local hooks = require("ibl.hooks")

            -- 注册高亮设置，使用指定的颜色
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "BlueLight", { fg = "#8AB4F8", nocombine = true })  -- 浅蓝
                vim.api.nvim_set_hl(0, "Blue", { fg = "#61AFEF", nocombine = true })        -- 亮蓝
                vim.api.nvim_set_hl(0, "Cobalt", { fg = "#5C6BC0", nocombine = true })      -- 靛蓝
                vim.api.nvim_set_hl(0, "Indigo", { fg = "#9575CD", nocombine = true })      -- 浅紫
                vim.api.nvim_set_hl(0, "Violet", { fg = "#BA68C8", nocombine = true })      -- 紫罗兰
                vim.api.nvim_set_hl(0, "Purple", { fg = "#CE93D8", nocombine = true })      -- 淡紫（已替换）
                vim.api.nvim_set_hl(0, "DeepPurple", { fg = "#F06292", nocombine = true })  -- 粉红（已替换）
                vim.api.nvim_set_hl(0, "Coral", { fg = "#FF8A65", nocombine = true })      -- 珊瑚橙
                -- 然后在 highlight 列表中添加 "Coral"
            end)

            -- 配置 indent-blankline
            require("ibl").setup({
                indent = {
                    highlight = highlight,  -- 使用高亮组名称列表
                    char = "│",             -- 缩进线字符
                    priority = 2,
                },

                -- 作用域高亮
                scope = {
                    enabled = true,
                    show_start = true,
                    show_end = true,
                    highlight = { "BlueLight" },  -- 作用域使用第一个颜色
                    priority = 500,
                },

                -- 排除的文件类型
                exclude = {
                    filetypes = {
                        "help",
                        "startify",
                        "dashboard",
                        "lazy",
                        "mason",
                        "Neogit",
                        "NvimTree",
                        "TelescopePrompt",
                        "alpha",
                        "toggleterm",
                    },
                    buftypes = { "terminal", "nofile" },
                },
            })
        end,
    },
    -- Showkeys
    { "nvzone/showkeys", event = "VeryLazy", config = function() require("showkeys").setup({ position = "top-right" }) end },

}
