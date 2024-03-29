local has_words_before = function()
    unpack = unpack or table.unpack 
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil 
end

return {
    'hrsh7th/nvim-cmp', 
    event = 'InsertEnter',           -- load plugin when going into insert mode
    dependencies = {
        'hrsh7th/cmp-buffer',        -- buffer auto-completion
        'hrsh7th/cmp-path',          -- path auto-completion
        'L3MON4D3/LuaSnip',          -- snippet engine
        'saadparwaiz1/cmp_luasnip',  -- snippet auto-completion
    },
    config = function()

        local cmp = require('cmp')
        local luasnip = require('luasnip')

        cmp.setup({
            completion = {
                completeopt = 'menu,menuone,preview,noselect'
            },
            snippet = { -- configure how cmp interacts with snippet engine
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-space>'] = cmp.mapping.complete(),     -- show completion suggestion
                ['<C-e>'] = cmp.mapping.abort(),
                -- Use <CR>(Enter) to confirm selecton
                ['<CR>'] = cmp.mapping.confirm({select = false}),
                ["<Tab>"] = cmp.mapping(function(fallback)
                      if cmp.visible() then
                        cmp.select_next_item()
                      elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                      elseif has_words_before() then
                        cmp.complete()
                      else
                        fallback()
                      end
                    end, { "i", "s" }), -- i: insert mode; s: select mode
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                      if cmp.visible() then
                        cmp.select_prev_item()
                      elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                      else
                        fallback()
                      end
                    end, { "i", "s" }),               
            }),
            -- Sources for autocomplete
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' }
            })
        })

    end

}
