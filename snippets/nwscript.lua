-- Boilerplate {{{
local ls = require("luasnip")
local s = ls.s --> snippet
local i = ls.i --> insert node
local t = ls.t --> text node

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local l = require("luasnip.extras").lambda

local snippets, autosnippets = {}, {}

local group = vim.api.nvim_create_augroup("NWScript Snippets", { clear = true })
local file_pattern = "*.nss"
-- }}}

--- Creates a snippet {{{
local function cs(trigger, nodes, opts)
  local snippet = s(trigger, nodes)
  local target_table = snippets

  local pattern = file_pattern
  local keymaps = {}

  if opts ~= nil then
    -- check for custom pattern
    if opts.pattern then
      pattern = opts.pattern
    end

    -- if opts is a string
    if type(opts) == "string" then
      if opts == "auto" then
        target_table = autosnippets
      else
        table.insert(keymaps, { "i", opts })
      end
    end

    -- if opts is a table
    if type(opts) == "table" then
      for _, keymap in ipairs(opts) do
        if type(keymap) == "string" then
          table.insert(keymaps, { "i", keymap })
        else
          table.insert(keymaps, keymap)
        end
      end
    end

    -- set autocmd for each keymap
    if opts ~= "auto" then
      for _, keymap in ipairs(keymaps) do
        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = pattern,
          group = group,
          callback = function()
            vim.keymap.set(keymap[1], keymap[2], function()
              ls.snip_expand(snippet)
            end, { noremap = true, silent = true, buffer = true })
          end,
        })
      end
    end
  end

  -- insert snippet into appropriate table
  table.insert(target_table, snippet)
end --}}}

-- Snippets go here --

-- -- placeholder snippet {{{
-- cs(
--   "",
--   fmt(
--     [[
-- {}
--     ]],
--     {
--       i(0),
--     }
--   )
-- ) --}}}

-- void main snippet {{{
cs(
  "main",
  fmt(
    [[
void main()
{{
    {}
}}
{}
    ]],
    {
      i(1, "// TODO"),
      i(0),
    }
  )
) --}}}

-- Starting Conditional function snippet {{{
cs(
  "condit",
  fmt(
    [[
int StartingConditional()
{{
	return {};
}}
{}
    ]],
    {
      i(1, "// TODO"),
      i(0),
    }
  )
) --}}}

-- #include directive {{{
cs(
  "#inc",
  fmt(
    [[
#include "{}"
{}
    ]],
    {
      i(1, "file"),
      i(0),
    }
  )
) -- }}}

-- if conditional snippet {{{
cs(
  "if",
  fmt(
    [[
if ({})
{{
	{}
}}
{}
    ]],
    {
      i(1, "condition"),
      i(2, "// TODO"),
      i(0),
    }
  )
) --}}}

-- for loop snippet {{{
cs(
  "for",
  fmt(
    [[
for ({} = 0; {} < {}; {}++)
{{
    {}
}}
{}
    ]],
    {
      d(1, function(_, snip)
        return sn(1, i(1, snip.captures[1]))
      end),
      rep(1),
      i(2, "num"),
      rep(1),
      i(3, "// TODO"),
      i(4),
    }
  )
) --}}}

-- while loop snippet {{{
cs(
  "while",
  fmt(
    [[
while ({})
{{
	{}
}}
{}
    ]],
    {
      i(1, "condition"),
      i(2, "// TODO"),
      i(0),
    }
  )
) --}}}

-- do while loop snippet {{{
cs(
  "dowhile",
  fmt(
    [[
do
{{
	{}
}}
while ({})
{}
    ]],
    {
      i(1, "// TODO"),
      i(2, "condition"),
      i(0),
    }
  )
) --}}}

-- struct snippet {{{
cs(
  "struct",
  fmt(
    [[
struct {}
{{
  {}
}};
{}
    ]],
    {
      i(1, "name"),
      i(2, "// TODO"),
      i(0),
    }
  )
) --}}}

-- function definition snippet {{{
cs(
  "funcdef",
  fmt(
    [[
{} {}({})
{{
	{}
}}
{}
    ]],
    {
      i(1, "void"),
      i(2, "FunctionName"),
      i(3, "overloads"),
      i(4, "// TODO"),
      i(0),
    }
  )
) --}}}

-- function prototype snippet {{{
cs(
  "funcprot",
  fmt(
    [[
// ---< {} >---
// ---< {} >---
// {}
{} {}({});
{}
    ]],
    {
      i(1, "FunctionName"),
      f(function(_, snip)
        return snip.env["TM_FILENAME_BASE"]
      end),
      i(2, "description"),
      i(3, "definition"),
      rep(1),
      i(4, "overloads"),
      i(0),
    }
  )
) --}}}

-- constant definition snippet {{{
cs(
  "const",
  fmt(
    [[
{}
    ]],
    {
      i(0),
    }
  )
) --}}}

-- Commented block section {{{
cs(
  "cblock",
  fmt(
    [[
// -----------------------------------------------------------------------------
// {}{}
// -----------------------------------------------------------------------------
{}
    ]],
    {
      f(function(args)
        return string.rep(" ", (38 - math.floor(args[1][1]:len() / 2)))
      end, { 1 }),
      i(1, "header title"),
      i(0),
    }
  )
) -- }}}

-- Commented divider line {{{
cs(
  "cline",
  fmt(
    [[
// -----------------------------------------------------------------------------
{}
    ]],
    {
      i(0),
    }
  )
) -- }}}

-- Commented divider line with text {{{
cs(
  "ctext",
  fmt(
    [[
// ----- {} {}
{}
    ]],
    {
      i(1, "text"),
      f(function(args)
        return string.rep("-", 70 - args[1][1]:len())
      end, { 1 }),
      i(0),
    }
  )
) -- }}}

-- File metadata {{{
cs(
  "meta",
  fmt(
    [[
/// ----------------------------------------------------------------------------
/// @file   {}
/// @author {} ({}) <{}>
/// @brief  {}
/// ----------------------------------------------------------------------------
{}
    ]],
    {
      f(function(_, snip)
        return snip.env["TM_FILENAME"]
      end),
      i(1, "Name"),
      i(2, "Nick"),
      i(3, "email"),
      i(4, "Description"),
      i(0),
    }
  )
) -- }}}

-- Boilerplate --
return snippets, autosnippets

-- vim:foldenable foldmethod=marker
