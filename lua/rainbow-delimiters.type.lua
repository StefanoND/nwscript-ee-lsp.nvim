---@meta

--# Utility Library #--

---Strategy to use for highlighting with rainbow-delimiters
---Must implement `on_attach`, `on_detach` and `on_reset`
---@class rainbow_delimiters.strategy
---`on_attach`: setup the highlighting on attach
---@field on_attach fun(bufnr: integer, settings: rainbow_delimiters.buffer_settings)
---`on_detach`: remove any unneccesary remaining setup on detach
---@field on_detach fun(bufnr: integer)
---`on_reset`: update the highlighting on reset
---@field on_reset fun(bufnr: integer, settings: rainbow_delimiters.buffer_settings)

---@class (exact) rainbow_delimiters.buffer_settings
---@field strategy rainbow_delimiters.strategy
---@field parser vim.treesitter.LanguageTree
---@field lang string

--# Config #--

---Configuration table for rainbow-delimiters
---@class (exact) rainbow_delimiters.config
---Strategy to use for highlighting
---@field strategy rainbow_delimiters.config.strategies?
---Query to use for highlighting
---@field query rainbow_delimiters.config.queries?
---Highlight priority of rainbow delimiters
---@field priority rainbow_delimiters.config.priorities?
---Highlight colors
---@field highlight string[]?
---Whitelist for languages to highlight
---@field whitelist rainbow_delimiters.language[]?
---Blacklist for languages not to highlight
---@field blacklist rainbow_delimiters.language[]?
---Dynamic condition whether to enable rainbow highlighting
---@field condition (fun(bufnr: number): boolean)?
---Logging with log file and log level
---@field log rainbow_delimiters.logging?

---@class rainbow_delimiters.config.strategies
---@field nwscript     (string | rainbow_delimiters.strategy | fun(bufnr: integer): string | rainbow_delimiters.strategy?)?

---@class rainbow_delimiters.config.queries
---@field nwscript     (('rainbow-delimiters' | string) | fun(bufnr: integer): ('rainbow-delimiters' | string))?

---@class rainbow_delimiters.config.priorities
---@field nwscript     (integer | fun(bufnr: integer): integer)?

---@alias rainbow_delimiters.language
---| 'nwscript'

---@class (exact) rainbow_delimiters.logging
---@field file ('rainbow_delimiters.log' | string)?
---@field level integer
