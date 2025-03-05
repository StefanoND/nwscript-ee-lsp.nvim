local M = {}

-- Add support for NWN:EE's LSP
-- Thanks to implicit-image and his repo: https://github.com/implicit-image/lsp-nwscript.el
-- Which I somehow manged to "convert" from emacs to neovim

-- NWN:EE's LSP
-- Original author: https://github.com/PhilippeChab/nwscript-ee-language-server
-- Current maintainer: https://github.com/implicit-image/nwscript-ee-language-server

-- Change these to the correct path
local nwnPaths = {
  docs = os.getenv("NWN_HOME"),
  -- docs = os.getenv("HOME") .. "/Documents/Neverwinter Nights",
  -- docs = "/home/USERNAME/Documents/Neverwinter Nights",
  -- docs = "~/Documents/Neverwinter Nights",
  -- docs = os.getenv("UserProfile") .. "/My Documents/Neverwinter Nights",
  -- docs = "C:/Users/USERNAME/My Documents/Neverwinter Nights",
  root = os.getenv("NWN_ROOT"),
  -- root = os.getenv("HOME") .. "/.local/share/steam/steamapps/common/Neverwinter Nights",
  -- root = "/home/USERNAME/.local/share/steam/steamapps/common/Neverwinter Nights",
  -- root = "~/.local/share/steam/steamapps/common/Neverwinter Nights",
  -- root = "C:/Program Files (x86)/Steam/steamapps/common/Neverwinter Nights",
}

-- Includes
-- Must be array, too lazy to make it work with tables
-- Seems that the root path of the project is enough. I'm using Nasher so it might be helping
local nwIncludes = {
  tostring(vim.fn.getcwd()),
  -- tostring(vim.fn.getcwd()) .. "/src",
  -- tostring(vim.fn.getcwd()) .. "/src/nss",
}

-- "List of base include dirs for Neverwinter Nights Enhanced Edition."
-- Must be array, too lazy to make it work with tables
local nwneeBaseIncludes = {}

-- "List of base include dirs for Neverwinter Nights Diamond."
-- Must be array, too lazy to make it work with tables
local nwnBaseIncludes = {}

-- "List of base include dirs for Neverwinter Nights 2"
-- Must be array, too lazy to make it work with tables
local nwn2BaseIncludes = {}

-- Ignore
-- Must be array, too lazy to make it work with tables
local nwIgnores = {
  -- "/path/to/ignore",
  -- "/file/to/ignore.nss",
  -- "/path/to/ignore/dir1/subdir1",
  -- "/path/to/ignore/dir1/subdir2",
  -- "/path/to/ignore/dir1/ignore1.nss",
  -- "/path/to/ignore/dir1/ignore2.nss",
}

local lsp = ["nwscript-ee-lsp"]

local nwSettings = {
  single_file_support = true,
  M.lsp == {
    completion = {
      addParamsToFunctions = true,
    },
    hovering = {
      addCommentsToFunctions = true,
    },
    formatter = {
      enabled = true,
      verbose = true,
      executable = "clang-format",
      ignoreGlobs = nwIgnores,
    },
    compiler = {
      enabled = true,
      os = vim.uv.os_uname().sysname,
      verbose = true,
      reportWarnings = true,
      nwnHome = nwnPaths.docs,
      nwnInstallation = nwnPaths.root,
      nwneeBaseIncludes = nwneeBaseIncludes,
      nwnBaseIncludes = nwnBaseIncludes,
      nwn2BaseIncludes = nwn2BaseIncludes,
      workspaceIncludes = nwIncludes,
    },
  },
}

return M
