local M = {}

local config_aug = vim.api.nvim_create_augroup("nwscript_ls_setup", { clear = true })

M.setup = function(opts)
  local functions = require("nwscript.configs.functions")
  local config = require("nwscript.configs.settings")
  local autoBuild = opts.autoBuild or false
  if autoBuild then
    if not functions.findExecutable("node") then
      vim.notify("You must have Node.js installed", vim.log.levels.ERROR)
    end
    if not functions.findExecutable("npm") then
      vim.notify("You must have npm installed", vim.log.levels.ERROR)
    end
    if functions.findExecutable("node") and functions.findExecutable("npm") then
      local path = vim.fn.stdpath("data")
      local pluginPath = path .. "/lazy/nwscript-ee-lsp.nvim"
      local bashPath = pluginPath .. "/buildlsp.sh"
      local chmod = "silent!!chmod +x " .. bashPath
      local run = bashPath
      local command = chmod .. " && " .. run
      vim.api.nvim_command(command)
    end
  end

  local setup = require("nwscript.configs.setup")
  setup.configComment() -- Enable "Comment.nvim" functionality for NWScript
  setup.configTreesitter() -- Enable "nvim-treesitter" syntax highlighting for NWScript
  setup.configFormatter() -- Enable "null/none-ls" auto-formatting on-save for NWScript
  setup.configLuasnip() -- Enable "LuaSnip" snippets for NWScript
  setup.configUltiSnips() -- Enable "UltiSnips" snippets for NWScript
  setup.configNeogen() -- Enable "neogen" comment generation functionality for NWScript
  setup.configDevIcons() -- Adds a "nvim-web-devicons" icon for NWScript

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.name == "nwscript_ls" then
        local bufnr = event.buf
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
