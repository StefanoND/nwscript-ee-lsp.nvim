local M = {}

M.setKeymaps = function(client, bufnr)
  local kmn = function(key, func, desc)
    vim.keymap.set("n", key, func, { buffer = bufnr, silent = true, desc = desc or "" })
  end

  local funcs = require("nwscript.configs.functions")

  if require("which-key") ~= nil then
    local wk = require("which-key")
    wk.add({
      mode = { "n" },
      {
        {
          "<leader>nwc",
          function()
            funcs.nasherCompile(false)
          end,
          desc = "Compile current script",
        },
        {
          "<leader>nwC",
          function()
            funcs.nasherCompile(true)
          end,
          desc = "Compile all scripts",
        },
        {
          "<leader>nwm",
          function()
            funcs.nasherInstall("main", "-y")
          end,
          desc = "Pack and install project into module",
        },
        {
          "<leader>nwM",
          function()
            funcs.nasherUnpack("main", "-y")
          end,
          desc = "Unpack module to project folder",
        },
        {
          "<leader>nwh",
          function()
            funcs.nasherInstall("haks", "-y")
          end,
          desc = "Pack and install project into separate haks",
        },
        {
          "<leader>nwH",
          function()
            funcs.nasherUnpack("haks", "-y")
          end,
          desc = "Unpack haks to project folder",
        },
        {
          "<leader>nwt",
          function()
            funcs.nasherInstall("tlk", "-y")
          end,
          desc = "Pack and install project into tlk",
        },
        {
          "<leader>nwT",
          function()
            funcs.nasherUnpack("tlk", "-y")
          end,
          desc = "Unpack tlk to project folder",
        },
      },
    })
  else
    kmn("<leader>nwc", function()
      funcs.nasherCompile(false)
    end, "Compile current script")
    kmn("<leader>nwC", function()
      funcs.nasherCompile(true)
    end, "Compile all scripts")
    kmn("<leader>nwm", function()
      funcs.nasherInstall("main", "-y")
    end, "Pack project into module")
    kmn("<leader>nwM", function()
      funcs.nasherUnpack("main", "-y")
    end, "Unpack module to project folder")
    kmn("<leader>nwh", function()
      funcs.nasherInstall("haks", "-y")
    end, "Pack project into module")
    kmn("<leader>nwH", function()
      funcs.nasherUnpack("haks", "-y")
    end, "Unpack module to project folder")
    kmn("<leader>nwt", function()
      funcs.nasherInstall("tlk", "-y")
    end, "Pack project into module")
    kmn("<leader>nwT", function()
      funcs.nasherUnpack("tlk", "-y")
    end, "Unpack module to project folder")
  end
end

return M
