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
        {
          "<leader>tg",
          function()
            functions.nwScriptTagGen(false)
          end,
          desc = "Generate ctags for current project",
        },
        {
          "<leader>tG",
          function()
            functions.nwScriptTagGen(true)
          end,
          desc = "Generate ctags for project inc. external dirs.",
        },

        -- { "<leader>nwc", compile .. "-f '%:p'<CR>", desc = "Compile current script" },
        -- { "<leader>nwC", compile .. "all<CR>", desc = "Compile all scripts" },
        -- { "<leader>nwi", install .. "-y main<CR>", desc = "Pack project into module" },
        -- { "<leader>nwu", unpack .. "-y main<CR>", desc = "Unpack module to project folder" },
        -- { "<leader>tg", ":NWScriptTagGen<CR>", desc = "Generate ctags for current project" },
        -- { "<leader>tG", ":NWScriptTagGenAll<CR>", desc = "Generate ctags for project inc. external dirs." },
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
    kmn("<leader>tg", function()
      functions.nwScriptTagGen(false)
    end, "Generate ctags for current project")
    kmn("<leader>tG", function()
      functions.nwScriptTagGen(true)
    end, "Generate ctags for project inc. external dirs.")

    -- kmn("<leader>nwc", compile .. "-f '%:p'<CR>", "Compile current script")
    -- kmn("<leader>nwC", compile .. "all<CR>", "Compile all scripts")
    -- kmn("<leader>nwi", install .. "-y main<CR>", "Pack project into module")
    -- kmn("<leader>nwu", unpack .. "-y main<CR>", "Unpack module to project folder")
    -- kmn("<leader>tg", ":NWScriptTagGen<CR>", "Generate ctags for current project")
    -- kmn("<leader>tG", ":NWScriptTagGenAll<CR>", "Generate ctags for project inc. external dirs.")
  end
end

return M
