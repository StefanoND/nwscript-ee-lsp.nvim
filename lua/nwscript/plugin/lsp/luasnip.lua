local luasnip = require("luasnip")
local path = os.getenv("XDG_CONFIG_HOME") .. "/nvim/snippets"

-- require("luasnip.loaders.from_lua").lazy_load()
require("luasnip.loaders.from_lua").lazy_load({ paths = path })
luasnip.filetype_extend("nwscript", { "nwscriptdoc" })
