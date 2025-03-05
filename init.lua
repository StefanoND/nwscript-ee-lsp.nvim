-- Opt-in to use filetype.lua
-- ./nwscript-ee-lsp.nvim/filetype.lua
vim.g.do_filetype_lua = 1

-- ./nwscript-ee-lsp.nvim/lua/nwscript
require("nwscript")
-- ./nwscript-ee-lsp.nvim/lua/lspconfig
require("lspconfig")
