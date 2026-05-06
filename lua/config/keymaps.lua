-- Diagnostic navigation
vim.api.nvim_set_keymap("n", "<leader>gj", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gk", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true })

-- Basic Mappings
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-L>", "<Right>", { noremap = true, silent = true })
vim.keymap.set("n", "<Space>", ":", { noremap = true, silent = false })
vim.api.nvim_set_keymap("i", "jd", "<Esc>jA", { noremap = true })

-- Tab & Window Management
vim.keymap.set("n", "<S-Left>", ":tabp<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Right>", ":tabn<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>w", "<C-w>w", { noremap = true, silent = true })

-- Editing Shortcuts
vim.keymap.set("i", "<C-Z>", "<Esc>zzi", { noremap = true, silent = true })
-- vim.keymap.set("i", "<C-O>", "<C-Y>,", { noremap = true, silent = true })
-- vim.keymap.set("i", "<C-A>", '<Esc>ggVG$"+y', { noremap = true, silent = true }) -- Select All Copy
-- vim.keymap.set("n", "<Esc><Esc>", ":w<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<F12>", "gg=G", { noremap = true, silent = true }) -- Format File
vim.keymap.set("i", "<C-v>", '<Esc>"*pa', { noremap = true, silent = true })
vim.keymap.set("i", "<C-a>", "<Esc>^", { noremap = true, silent = true })
vim.keymap.set("i", "<C-e>", "<Esc>$", { noremap = true, silent = true })
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })
-- in visual mode, use <ctrl-a> to select all and copy
-- first gg to go to the top, then VG to select all, then +y to copy to clipboard
vim.keymap.set("n", "<C-a>", "ggVG+y", { noremap = true, silent = true })
vim.keymap.set("v", "<F2>", ":g/^\\s*$/d<CR>", { noremap = true, silent = true })       -- Delete empty lines
vim.keymap.set("n", "<C-F2>", ":vert diffsplit<CR>", { noremap = true, silent = true }) -- Diff split
-- vim.keymap.set("n", "tt", ":%s/\\t/    /g<CR>", { noremap = true, silent = false }) -- Tabs to spaces

-- Command & Terminal Paste
vim.api.nvim_set_keymap("c", "<C-v>", "<C-r>+", { noremap = true })
vim.api.nvim_set_keymap("t", "<C-v>", '<C-\\><C-n>"+pa', { noremap = true })
