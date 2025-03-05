local config = function()
  -- Create NWScript grammar
  local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  parser_config.nwscript = {
    install_info = {
      url = "https://github.com/tinygiant98/tree-sitter-nwscript",
      files = { "src/parser.c" },
      generate_requires_npm = false,
      requires_generate_from_grammar = false,
    },
    filestype = "nwscript",
  }

  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "nwscript",
    },
  })
end

return {
  config(),
}
