local M = {}

local config_aug = vim.api.nvim_create_augroup("nwscript_ls_lsp_setup", { clear = true })

M.enableCodelens = function(events)
  local codelens_aug = vim.api.nvim_create_augroup("nwscript_ls_codelens", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = config_aug,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "nwscript_ls" then
        vim.api.nvim_create_autocmd(events, {
          group = codelens_aug,
          buffer = args.buf,
          callback = vim.lsp.codelens.refresh,
          desc = "Refresh nwscript_ls codelens",
        })
        vim.lsp.codelens.refresh()
      end
    end,
    desc = "Create codelens autocmd on Lsp Attach",
  })

  vim.api.nvim_create_autocmd("LspDetach", {
    group = config_aug,
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "nwscript_ls" then
        vim.api.nvim_clear_autocmds({ group = codelens_aug, buffer = args.buf })
      end
    end,
    desc = "Clear codelens autocmd on Lsp Detach",
  })
end

M.setup = function(opts)
  local functions = require("nwscript.configs.functions")
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

  local config = require("nwscript.configs.settings")

  if config.codelens.enable then
    M.enableCodelens(config.codelens.events)
  end

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
