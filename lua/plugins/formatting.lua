return {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
        formatters_by_ft = {
            javascript = { 'prettier' },
            typescript = { 'prettier' },
            javascriptreact = { 'prettier' },
            typescriptreact = { 'prettier' },
            svelte = { 'prettier' },
            css = { 'prettier' },
            html = { 'prettier' },
            vue = { 'prettier' },
            json = { 'prettier' },
            yaml = { 'prettier' },
            markdown = { 'prettier' },
            graphql = { 'prettier' },
            liquid = { 'prettier' },
            lua = { 'stylua' },
            python = { 'isort', 'black' },
        },
    },
    init = function()
        vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
            require('conform').format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = 'Format file or range (in visual mode)' })
    end,
}
