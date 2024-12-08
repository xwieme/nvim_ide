return {
  "L3MON4D3/LuaSnip",
  config = function()
    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/luasnippets/" })
    require("luasnip").config.setup({
      update_events = "TextChanged,TextChangedI",
      enable_autosnippets = true,
    })
  end,
}
