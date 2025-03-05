vim.api.nvim_set_var("do_filetype_lua", 1)
vim.filetype.add({
  extension = {
    nss = "nwscript",
  },
  pattern = {
    [".*%.nss$"] = "nwscript",
  },
})
