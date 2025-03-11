local M = {}

M.setKeymaps = function()
  local kmn = function(key, func, desc)
    vim.keymap.set("n", key, func, { silent = true, desc = desc or "" })
  end
  -- local compile = ":!nasher compile "
  -- local install = ":!nasher install "
  -- local unpack = ":!nasher unpack "

  local functions = require("nwscript.configs.functions")

  -- Will keep using nwnsc since nwn_script_comp doesn't compile includes
  -- And doesn't support external pragma directives
  if require("which-key") ~= nil then
    local wk = require("which-key")
    wk.add({
      mode = { "n" },
      {
        {
          "<leader>nwc",
          function()
            functions.nasherCompile(false)
          end,
          desc = "Compile current script",
        },
        {
          "<leader>nwC",
          function()
            functions.nasherCompile(true)
          end,
          desc = "Compile all scripts",
        },
        {
          "<leader>nwi",
          function()
            functions.nasherInstallMod("main", "-y")
          end,
          desc = "Pack project into module",
        },
        {
          "<leader>nwu",
          function()
            functions.nasherUnpackMod("main", "-y")
          end,
          desc = "Unpack module to project folder",
        },
      },
    })
  else
    kmn("<leader>nwc", function()
      functions.nasherCompile(false)
    end, "Compile current script")
    kmn("<leader>nwC", function()
      functions.nasherCompile(true)
    end, "Compile all scripts")
    kmn("<leader>nwi", function()
      functions.nasherInstallMod("main", "-y")
    end, "Pack project into module")
    kmn("<leader>nwu", function()
      functions.nasherUnpackMod("main", "-y")
    end, "Unpack module to project folder")
  end
end

return M
