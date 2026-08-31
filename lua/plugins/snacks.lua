return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            -- Snacks.image requires the Kitty graphics protocol. Keep it off in Neovide/Windows Terminal.
            image = {
                enabled = false,
                doc = {
                    inline = true, -- Show images in hover docs
                    float = true,  -- Show images in floating windows
                },
            },

            -- Rest of your settings...
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            explorer = { enabled = true },
            lazygit = { enabled = true },
            notifier = { enabled = true },
            picker = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = false },
            statuscolumn = { enabled = true },
            terminal = { enabled = true },
            toggle = { enabled = true },
            words = { enabled = true },
            input = { enabled = true },
        },
    }
}
