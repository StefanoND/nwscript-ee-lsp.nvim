local M = {}

M.setKeymaps = function(client, bufnr)
  local lopts = { buffer = bufnr, noremap = true, remap = false }
  local kmn = function(key, func, opt)
    vim.keymap.set("n", key, func, opt)
  end
  local ext = function(desc)
    vim.tbl_deep_extend("force", lopts, { desc = desc })
  end
  local compile = ":terminal nasher compile "
  local install = ":terminal nasher install "
  local unpack = ":terminal nasher unpack "

  -- Will keep using nwnsc since nwn_script_comp doesn't compile includes
  -- And doesn't support external pragma directives
  if require("which-key") ~= nil then
    local wk = require("which-key")
    wk.add({
      {
        mode = { "n" },
        {
          { "<leader>nb", compile .. "-f '%:p'<CR>", ext("Compile current script") },
          { "<leader>ncb", compile .. "--clean -f '%:p'<CR>", ext("Clear cache and compile current script") },
          { "<leader>nB", compile .. "all<CR>", ext("Compile all scripts") },
          { "<leader>ncB", compile .. "--clean all<CR>", ext("Clear cache and Compile all scripts") },
          { "<leader>ni", install .. "-y main<CR>", ext("Pack project into module") },
          { "<leader>nci", install .. "--clean -y main<CR>", ext("Clear cache and Pack project into module") },
          { "<leader>nu", unpack .. "-y main<CR>", ext("Unpack module to project folder") },
          { "<leader>ncu", unpack .. "--clean -y main<CR>", ext("Unpack module to project folder") },
          { "<leader>tg", ":NWScriptTagGen<CR>", ext("Generate ctags for current project") },
          { "<leader>tG", ":NWScriptTagGenAll<CR>", ext("Generate ctags for project inc. external dirs.") },
        },
      },
    })
  else
    kmn("<leader>nb", compile .. "-f '%:p'<CR>", ext("Compile current script"))
    kmn("<leader>ncb", compile .. "--clean -f '%:p'<CR>", ext("Clear cache and compile current script"))
    kmn("<leader>nB", compile .. "all<CR>", ext("Compile all scripts"))
    kmn("<leader>ncB", compile .. "--clean all<CR>", ext("Clear cache and Compile all scripts"))
    kmn("<leader>ni", install .. "-y main<CR>", ext("Pack project into module"))
    kmn("<leader>nci", install .. "--clean -y main<CR>", ext("Clear cache and Pack project into module"))
    kmn("<leader>nu", unpack .. "-y main<CR>", ext("Unpack module to project folder"))
    kmn("<leader>ncu", unpack .. "--clean -y main<CR>", ext("Unpack module to project folder"))
    kmn("<leader>tg", ":NWScriptTagGen<CR>", ext("Generate ctags for current project"))

    -- Check plugins/lsp/nwscript.lua for more information.
    kmn("<leader>tG", ":NWScriptTagGenAll<CR>", ext("Generate ctags for project inc. external dirs."))
  end
end

return M
