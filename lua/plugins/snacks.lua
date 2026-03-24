return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            -- Image configuration for Neovide
            image = {
                enabled = false,  -- 1. Enable it (was false)
                doc = {
                    inline = true, -- Show images in hover docs
                    float = true,  -- Show images in floating windows
                },
                -- 2. REMOVED the complex 'terminal' function. 
                -- Snacks auto-detects Neovide when that function is missing.
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
