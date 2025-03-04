local extractors = require("neogen.utilities.extractors")
local nodes_utils = require("neogen.utilities.nodes")
local default_locator = require("neogen.locators.default")
local i = require("neogen.types.template").item

local nwscript_function_extractor = function(node)
  local tree = {
    {
      retrieve = "first",
      node_type = "function_argument_list",
      subtree = {
        { retrieve = "all", node_type = "identifier", extract = true },
        {
          retrieve = "all",
          node_type = "assignment_expression",
          subtree = {
            { retrieve = "first", node_type = "identifier", extract = true },
          },
        },
      },
    },
  }

  local nodes = nodes_utils:matching_nodes_from(node, tree)
  local res = extractors:extract_from_matched(nodes)

  if nodes.function_definition then
    local subnodes = nodes_utils:matching_nodes_from(nodes.function_definition[1]:parent(), tree)
    local subres = extractors:extract_from_matched(subnodes)
    res = vim.tbl_deep_extend("keep", res, subres)
  end

  return {
    [i.Parameter] = res.identifier,
  }
end

return {
  parent = {
    func = { "function_definition" },
  },

  data = {
    func = {
      ["function_definition"] = {
        ["0"] = {
          extract = nwscript_function_extractor,
        },
      },
    },
  },

  locator = function(node_info, nodes_to_match)
    local result = default_locator(node_info, nodes_to_match)
    if not result then
      return nil
    end

    if not node_info.current then
      return result
    end

    return result
  end,

  template = {
    annotation_convention = "custom",
    use_default_comment = false,
    custom = {
      { nil, "/// @brief $1", { type = { "func" } } },
      { i.Parameter, "/// @param %s $1" },
      { nil, "/// @returns $1", { type = { "func" } } },
    },
  },
}
