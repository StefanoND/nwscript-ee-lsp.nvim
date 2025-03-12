local M = {}

-- Uses system's Env Var to find NWN_HOME (NWN:EE's Documents)
M.nwDocuments = os.getenv("NWN_HOME")

-- Uses system's Env Var to find NWN_ROOT (NWN:EE's Install)
M.nwRoot = os.getenv("NWN_ROOT")

-- Will include this folder (Current Working Directory) and all its subfolders for indexing scripts
M.nwIncludes = {
  tostring(vim.fn.getcwd()),
}

return M
