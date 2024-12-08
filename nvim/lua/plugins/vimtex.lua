return {
  "lervag/vimtex",
  lazy = false,
  config = function()
    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } }
    vim.g.vimtex_view_method = "zathura"
  end,
}
