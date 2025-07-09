---@class StatusConfig
---@field icon string
---@field color string?

---@class StatusesConfig
---@field running StatusConfig
---@field cmdline StatusConfig
---@field stopped StatusConfig
---@field success StatusConfig
---@field failure StatusConfig
---@field panic StatusConfig

---@class MarkerConfig
---@field [1] string icon
---@field [2] string color or highlight group

---@class MarkersConfig
---@field passed MarkerConfig virtual text for passed test
---@field mixed MarkerConfig virtual text for partially passed test
---@field failed MarkerConfig virtual text for failed tests

---@class RunConfig
---@field nearest fun() function to run nearest test
---@field file fun() function to run current file
---@field last fun() function to run last tests

---@class Config
---@field status StatusesConfig
---@field markers MarkersConfig
---@field diagnostics vim.diagnostics.Opts
---@field json_path string path to the JSON output by tests
---@field run RunConfig
return {
  status = {
    running = { icon = '󰐌', color = nil }, -- white
    cmdline = { icon = '', color = 'DiagnosticHint' },
    stopped = { icon = '', color = 'DiagnosticWarn' },
    success = { icon = '󰗠', color = 'DiagnosticOk' },
    failure = { icon = '󰅙', color = 'DiagnosticError' },
    panic = { icon = '󰀨', color = 'DiagnosticUnnecessary' },
  },
  markers = {
    passed = { ' ✔ ', 'DiagnosticPass' },
    mixed  = { ' ✘ ', 'DiagnosticMixed' },
    failed = { ' ✘ ', 'DiagnosticFail' },
  },
  diagnostics = { virtual_lines = true, virtual_text = false, underline = false },
  json_path = '/tmp/testbus.json',
  run = {
    nearest = vim.cmd.TestNearest,
    file = vim.cmd.TestFile,
    last = vim.cmd.TestLast
  },
}
