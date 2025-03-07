local M = {}

M.nwscriptrefresh = function(bufnr)
  local augroup = vim.api.nvim_create_augroup("NWScript", {})
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.cmd("LspRestart")
    end,
  })
end

M.setRoundBorder = function(bufnr)
  if require("lsp_signature") ~= nil then
    require("lsp_signature").on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded",
      },
    }, bufnr)
  end
end

M.setDiagnostic = function()
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  })
end

return M
