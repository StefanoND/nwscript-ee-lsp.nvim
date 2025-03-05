local neogen = require("neogen")

neogen.setup({
  snippet_engine = "luasnip",
  languages = {
    nwscript = require("plugins.neogen.nwscript"),
  },
})
