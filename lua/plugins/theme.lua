return {
    {
        -- 安装主题
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,  -- 高优先级，确保主题首先加载
    },
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        event = "VeryLazy",
        config = function()
            -- 可选：配置 kanagawa
            require("kanagawa").setup({
                -- 你的配置
            })
        end,
    },
    {
        "scottmckendry/cyberdream.nvim",
        name = "cyberdream",
        event = "VeryLazy",
        config = function()
            require("cyberdream").setup({
                -- 你的配置
            })
        end,
    },
    {
        "neanias/everforest-nvim",
        name = "everforest",
        event = "VeryLazy",
        config = function()
            require("everforest").setup({
                -- 你的配置
            })
        end,
    },

    -- 主题切换器
    {
        "zaldih/themery.nvim",
        lazy = false,  -- 立即加载，不延迟
        dependencies = {
            "catppuccin/nvim",
            "kanagawa",      -- 添加依赖确保主题先加载
            "cyberdream",
            "everforest",
        },
        config = function()
            require("themery").setup({
                -- 主题存放目录（通常不需要配置，除非你自定义主题）
                -- themesDir = vim.fn.stdpath("config") .. "/lua/themes",

                -- 预设主题列表
                themes = {
                    -- Catppuccin 系列（需要设置 flavour）
                    {
                        name = "Catppuccin Latte",
                        colorscheme = "catppuccin-latte",
                        before = [[
                        vim.g.catppuccin_flavour = "latte"
                    ]],
                    },
                    {
                        name = "Catppuccin Frappe",
                        colorscheme = "catppuccin-frappe",
                        before = [[
                        vim.g.catppuccin_flavour = "frappe"
                    ]],
                    },
                    {
                        name = "Catppuccin Macchiato",
                        colorscheme = "catppuccin-macchiato",
                        before = [[
                        vim.g.catppuccin_flavour = "macchiato"
                    ]],
                    },
                    {
                        name = "Catppuccin Mocha",
                        colorscheme = "catppuccin-mocha",
                        before = [[
                        vim.g.catppuccin_flavour = "mocha"
                    ]],
                    },

                    -- Kanagawa 系列
                    {
                        name = "Kanagawa Wave",
                        colorscheme = "kanagawa-wave",
                    },
                    {
                        name = "Kanagawa Dragon",
                        colorscheme = "kanagawa-dragon",
                    },
                    {
                        name = "Kanagawa Lotus",
                        colorscheme = "kanagawa-lotus",
                    },

                    -- Cyberdream
                    {
                        name = "Cyberdream",
                        colorscheme = "cyberdream",
                        -- cyberdream 支持暗色/亮色切换（如果需要）
                        -- before = [[
                        --     vim.g.cyberdream_style = "dark"  -- 或 "light"
                        -- ]],
                    },

                    -- Everforest 系列（需要设置变体）
                    {
                        name = "Everforest Hard",
                        colorscheme = "everforest",
                        before = [[
                        vim.g.everforest_background = "hard"
                    ]],
                    },
                    {
                        name = "Everforest Medium",
                        colorscheme = "everforest",
                        before = [[
                        vim.g.everforest_background = "medium"
                    ]],
                    },
                    {
                        name = "Everforest Soft",
                        colorscheme = "everforest",
                        before = [[
                        vim.g.everforest_background = "soft"
                    ]],
                    },
                },

                -- 实时预览（默认 true）
                livePreview = true,

                -- 自定义命令名（默认 :Themery）
                command = "Themery",

                -- 主题预览窗口尺寸
                width = 45,   -- 稍微窄一点
                height = 20,

                -- 显示当前主题标记
                showCurrent = true,
            })
        end,
    },

    -- 快捷键配置（建议单独放在 keymaps.lua，而不是 themery 的 keymap 字段里）
    -- 注意：themery 的配置中没有 keymap 字段，需要单独设置
}
