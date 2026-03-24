return {
    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        tag = "0.1.8",
        dependencies = {
            "nvim-telescope/telescope-file-browser.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        -- Move keymaps here so they work BEFORE the plugin loads
        keys = {
            -- { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" }, when i use it, it defaultly open the neovide.exe path.
            -- so i change it to open the current working directory, means the buffer file's path. use <leaeder>fn to open recent files, and
            -- change to this path.
            { "<leader>fn", function() require("telescope.builtin").find_files({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Find Files in Current Buffer's Path NOW" },
            -- {"<leader>fn", function() require("telescope.builtin").oldfiles({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Recent Files" },
            { "<leader>ff", "<cmd>Telescope find_files<cr>",                                                          desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",                                                           desc = "Live Grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",                                                             desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>",                                                           desc = "Help Tags" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                                                            desc = "Recent Files" }, -- ✨ NEW
            { "<leader>fc", "<cmd>Telescope file_browser path=" .. vim.fn.stdpath("config") .. "<cr>",                desc = "Config Files" },
            -- vim.keymap.set("n", "<leader>fd", function() require("telescope.builtin").diagnostics() end, { noremap = true, silent = true })
        },
        config = function()
            local actions = require('telescope.actions')
            require("telescope").setup({
                defaults = {
                    -- previewer = false,
                    file_sorter = require("telescope.sorters").get_fzf_sorter,
                    generic_sorter = require("telescope.sorters").get_fzf_sorter,
                    set_env = { CONFIRM = false },
                    prompt_prefix = "🔍 ",
                    mappings = {
                        i = { ["jw"] = actions.close },
                        -- add the normal mode mappings if needed
                        -- use <Ctrl-J> to close!!!not jw
                        n = { ["<C-j>"] = actions.close },
                    },
                    color_devicons = true,
                    layout_strategy = "horizontal",
                    layout_config = {
                        preview_cutoff = 1,
                        prompt_position = "bottom",
                        height = 0.9,
                        width = 0.9,
                        bottom_pane = { height = 0.6, preview_cutoff = 1, prompt_position = "top" },
                        center = { height = 0.6, preview_cutoff = 1, prompt_position = "top", width = 100 },
                        cursor = { height = 0.6, preview_cutoff = 1, width = 100 },
                        horizontal = { height = 0.6, preview_cutoff = 1, prompt_position = "top", width = 100, preview_width = 0.6 },
                        vertical = { height = 0.6, preview_cutoff = 1, prompt_position = "top", width = 100, preview_width = 0.6 },
                    },
                    winblend = 10,
                    border = {},
                    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                    file_ignore_patterns = { "node_modules", ".git/", ".dll", ".exe", "dist/", "build/", "target/" },
                },
            })
            require("telescope").load_extension("fzf")
        end,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons", -- optional, but recommended
        },
        lazy = false,                      -- neo-tree will lazily load itself
    },

    -- Toggleerm
    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        keys = { "<leader>tt", "<leader>tf", "<leader>tv", "<leader>tg", "<leader>tp" },
        config = function()
            local toggleterm = require("toggleterm")
            local Terminal = require("toggleterm.terminal").Terminal

            toggleterm.setup({
                size = 10,
                open_mapping = [[<c-\>]],
                shading_factor = 2,
                start_in_insert = true,
                persist_size = true,
                direction = "horizontal", -- default direction
                close_on_exit = true,
                float_opts = { border = "curved", winblend = 3 },

                -- Windows: default to PowerShell (pwsh) if available
                shell = vim.fn.has("win32") == 1 and "pwsh" or vim.o.shell,
            })

            -- Optional: better terminal keymaps when ToggleTerm opens
            function _G.set_toggleterm_keymaps()
                local opts = { buffer = 0 }
                -- Exit terminal-mode to normal-mode
                vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], opts)
                -- Window navigation from terminal
                vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
                vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
                vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
                vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
            end

            vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_toggleterm_keymaps()")

            -- Basic toggles (no custom command, just ToggleTerm)
            vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { silent = true, desc = "ToggleTerm (horizontal)" })
            vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>",
                { silent = true, desc = "ToggleTerm (vertical)" })
            vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>",
                { silent = true, desc = "ToggleTerm (float)" })
            vim.keymap.set("n", "<leader>t1", "<cmd>1ToggleTerm<cr>", { desc = "Terminal 1" })
            vim.keymap.set("n", "<leader>t2", "<cmd>2ToggleTerm<cr>", { desc = "Terminal 2" })
            vim.keymap.set("n", "<leader>t3", "<cmd>3ToggleTerm direction=float<cr>", { desc = "Terminal 3 (float)" })
            vim.keymap.set("n", "<leader>t4", "<cmd>4ToggleTerm direction=vertical<cr>",
                { desc = "Terminal 4 (vertical)" })

            ----------------------------------------------------------------------
            -- Dedicated terminals (each one keeps its own state)
            ----------------------------------------------------------------------

            -- Lazygit (float)
            local lazygit = Terminal:new({
                cmd = "lazygit",
                hidden = true,
                direction = "float",
                float_opts = { border = "curved" },
            })
            vim.keymap.set("n", "<leader>tg", function() lazygit:toggle() end, { desc = "LazyGit (float)" })

            -- Python REPL (horizontal)
            local py = Terminal:new({ cmd = "python", hidden = true, direction = "horizontal" })
            vim.keymap.set("n", "<leader>tp", function() py:toggle() end, { desc = "Python REPL" })

            -- Node REPL (vertical example)
            local node = Terminal:new({ cmd = "node", hidden = true, direction = "vertical" })
            vim.keymap.set("n", "<leader>tn", function() node:toggle() end, { desc = "Node REPL (vertical)" })

            -- PowerShell terminal (useful if you want a *separate* pwsh from default shell)
            local pwsh = Terminal:new({
                cmd = (vim.fn.has("win32") == 1) and "pwsh" or "bash",
                hidden = true,
                direction = "horizontal",
            })
            vim.keymap.set("n", "<leader>ts", function() pwsh:toggle() end, { desc = "Shell (pwsh/bash)" })
        end,
    },
    -- Auto Save
    {
        "Pocco81/auto-save.nvim",
        event = "VeryLazy",
        config = function()
            require("auto-save").setup({
                enabled = true,
                execution_message = { message = function() return "Ciallo～(∠・ω< )⌒★" end, dim = 0.18, cleaning_interval = 1250 },
                trigger_events = { "InsertLeave" },
                debounce_delay = 135,
                conditions = { exists = true, filetype_is_not = {}, modifiable = true },
                write_all_buffers = false,
                on_off_commands = true,
                execution_message_on_off = true,
            })
        end,
    },

    -- Utilities
    { "vim-scripts/CaptureClipboard",   event = "VeryLazy" },
    { "vim-scripts/Vim-Script-Updater", cmd = "VimScriptUpdate" },
    { "christoomey/vim-tmux-navigator", lazy = true },
    { "folke/which-key.nvim",           event = "VeryLazy",     config = function() require("which-key").setup({}) end },
    { "folke/todo-comments.nvim",       event = "BufReadPre" },
    { "folke/twilight.nvim",            event = "VeryLazy",     opts = {} },

    -- Flash
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },

    -- Impatient (Accelerator)
    { "lewis6991/impatient.nvim" },
    { "dstein64/vim-startuptime", lazy = true },

    -- -- Sidekick
    -- {
    -- "folke/sidekick.nvim",
    -- opts = {
    -- cli = { mux = { enabled = false } },
    -- nes = { enabled = false },
    -- },
    -- config = function(_, opts)
    -- require("sidekick").setup(opts)
    -- end,
    -- keys = {
    -- { "<tab>",      function() if not require("sidekick").nes_jump_or_apply() then return "<Tab>" end end, expr = true,                    desc = "Goto/Apply Next Edit Suggestion" },
    -- { "<c-.>",      function() require("sidekick.cli").toggle() end,                                       desc = "Sidekick Toggle",       mode = { "n", "t", "i", "x" } },
    -- { "<leader>aa", function() require("sidekick.cli").toggle() end,                                       desc = "Sidekick Toggle CLI" },
    -- { "<leader>as", function() require("sidekick.cli").select() end,                                       desc = "Select CLI" },
    -- { "<leader>ad", function() require("sidekick.cli").close() end,                                        desc = "Detach a CLI Session" },
    -- { "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end,                       mode = { "x", "n" },            desc = "Send This" },
    -- { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end,                       desc = "Send File" },
    -- { "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end,                  mode = { "x" },                 desc = "Send Visual Selection" },
    -- { "<leader>ap", function() require("sidekick.cli").prompt() end,                                       mode = { "n", "x" },            desc = "Sidekick Select Prompt" },
    -- { "<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,      desc = "Sidekick Toggle Claude" },
    -- },
    -- },

    -- Comments
    {
        "preservim/nerdcommenter",
        event = "VeryLazy",
        init = function()
            vim.g.NERDCreateDefaultMappings = 1
            vim.g.NERDSpaceDelims = 1
            vim.g.NERDCompactSexyComs = 1
        end
    },

    -- codi
    {
        "metakirby5/codi.vim",
        cmd = "Codi",
    },

    -- change the ime
    -- {
    -- "StellarDeca/winime.nvim",
    -- opts = {
    -- winime_core = {
    -- grammer_analysis_mode = "Auto",  -- 可选: "Auto" | "TreeSitter" | "String"
    -- },
    -- },
    -- event = { "VimEnter", "VeryLazy" },
    -- dependencies = (function()
    -- -- ⚠️ 注意: mode 应与 opts.winime_core.grammer_analysis_mode 一致
    -- local mode = "Auto"
    -- if mode == "TreeSitter" then
    -- return { "nvim-treesitter/nvim-treesitter" }
    -- elseif mode == "Auto" then
    -- return {
    -- "nvim-treesitter/nvim-treesitter",
    -- event = { "BufEnter", "BufNewFile" },
    -- }
    -- end
    -- return {}
    -- end)(),
    -- }
    -- { "m4xshen/hardtime.nvim", lazy = false, dependencies = { "MunifTanjim/nui.nvim" },
    -- opts = {},
    -- },


    {
        'brianhuster/live-preview.nvim',
        lazy = true,
        ft = { "markdown", "html" },
        dependencies = {
            -- You can choose one of the following pickers
            'nvim-telescope/telescope.nvim',
        },
        require('livepreview.config').set(),
    },

    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            -- add options here
            -- or leave it empty to use the default settings
        },
        keys = {
            -- suggested keymap
            { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
        },
    }
}
