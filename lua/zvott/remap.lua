vim.g.mapleader = ' '

-- Open netrw
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- Move current or selected line/s up or down
vim.keymap.set("n", "<A-J>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-K>", ":m .-2<CR>==")

vim.keymap.set("i", "<A-J>", "<Esc>:m .+1<CR>==")
vim.keymap.set("i", "<A-K>", "<Esc>:m .-2<CR>==")

vim.keymap.set("v", "<A-J>", ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<A-K>', ":m '<-2<CR>gv=gv")

-- Formats through vim's lsp
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

-- Paste without yanking selection
vim.keymap.set('x', '<leader>p', [["_dP]])

-- Yanks to system clipboard
vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

-- Delete without copy
vim.keymap.set({'n', 'v'}, '<leader>d', [["_d]])

-- Find and replace in current buffer
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Make current file executable
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<CR>', { silent = true })
