local M = {}

M.setup = function()
  local setup = require("nwscript.configs.setup")
  setup.configComment() -- Enable "Comment.nvim" functionality for NWScript
  setup.configTreesitter() -- Enable "nvim-treesitter" syntax highlighting for NWScript
  setup.configFormatter() -- Enable "null/none-ls" auto-formatting on-save for NWScript
  setup.configLuasnip() -- Enable "LuaSnip" snippets for NWScript
  setup.configUltiSnips() -- Enable "UltiSnips" snippets for NWScript
  setup.configNeogen() -- Enable "neogen" comment generation functionality for NWScript

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.name == "nwscript_ls" then
        local bufnr = event.buf
        local functions = require("nwscript.configs.functions")
        local keymaps = require("nwscript.configs.keymaps")
        keymaps.setKeymaps(client, bufnr) -- Set keymaps
        functions.nwscriptrefresh(bufnr) -- Enable auto-refresh on save
        functions.setRoundBorder(bufnr) -- Set rounded border for prompts
        functions.setDiagnostic() -- Enable diagnostic's virtual_text, signs and update_in_insert
      end
    end,
  })
end

return M
