-- TODO: this is probably overkill to use a plugin for this
return {
  "FotiadisM/tabset.nvim",
  config = function()
    require("tabset").setup({
      defaults = {
        tabwidth = 2,
        expandtab = true
      },
    })
  end
}
