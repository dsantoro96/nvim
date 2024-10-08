require('zvott.remap')
require('zvott.lazy')
require('zvott.set')

local augroup = vim.api.nvim_create_augroup
local ZvottGroup = augroup('Zvott', {})

local autocmd = vim.api.nvim_create_autocmd

autocmd({'BufWritePre'}, {
    group = ZvottGroup,
    pattern = '*',
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = ZvottGroup,
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set('n', 'gi', function() vim.lsp.buf.implementation() end, opts)
        vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set('n', '<leader>vd', function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set('n', '<leader>vca', function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set('n', '<leader>vrr', function() vim.lsp.buf.references() end, opts)
        vim.keymap.set('n', '<leader>vrn', function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set('i', '<C-h>', function() vim.lsp.buf.signature_help() end, opts)
    end
})
