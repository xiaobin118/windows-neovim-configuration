return {
    {
        "kawre/leetcode.nvim",
        build = ":TSUpdate html",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            -- your existing opts ...
            arg = "leetcode.nvim",
            lang = "python3",
            cn = {
                enabled = true,
                translator = true,
                translate_problems = true,
            },
            storage = {
                home = vim.fn.stdpath("data") .. "/leetcode",
                cache = vim.fn.stdpath("cache") .. "/leetcode",
            },
            plugins = {
                non_standalone = true,
            },
            logging = true,
            injector = {},
            cache = {
                update_interval = 60 * 60 * 24 * 7,
            },
            editor = {
                reset_previous_code = true,
                fold_imports = true,
            },
            console = {
                open_on_runcode = true,
                dir = "row",
                size = { width = "90%", height = "75%" },
                result = { size = "60%" },
                testcase = { virt_text = true, size = "40%" },
            },
            description = {
                position = "left",
                width = "40%",
                show_stats = true,
            },
            picker = {
                provider = "telescope",
            },
            hooks = {
                enter = {},
                question_enter = {},
                leave = {},
            },
            keys = {
                toggle = { "q" },
                confirm = { "<CR>" },
                reset_testcases = "r",
                use_testcase = "U",
                focus_testcases = "H",
                focus_result = "L",
            },
            image_support = false,
        },

        -- add this block:
        config = function(_, opts)
            -- setup leetcode.nvim with your opts
            require("leetcode").setup(opts)

            -- then add your FileType autocmd
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "leetcode",
                callback = function()
                    vim.opt_local.cursorline = false
                end,
            })
        end,
    },
}
