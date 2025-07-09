local glyphs = require('testbus.glyphs')
local adapters = require('testbus.adapters')
local state = require('testbus.state')
local config = require('testbus.config')

local M = {}

---- Drawer --------------------------------------------------------------------
---@enum Outcome
Outcome = {
  PASSED = 'passed',
  FAILED = 'failed',
  MIXED = 'mixed',
}
---@class Report
---@field bufnr integer buffer number to update
---@field outcomes table<string, Outcome> list of outcomes, indexed by line number
---@field diag table<vim.Diagnostic> list of diagnostics with errors
---@param report Report the state to be drawn
local draw = function(report)
  for lnum, outcome in pairs(report.outcomes) do
    local _, col = vim.api.nvim_buf_get_lines(report.bufnr, lnum, lnum + 1, true)[1]:find('^%s*')
    local mark = { id = lnum, virt_text_pos = 'inline', virt_text = { assert(config.markers[outcome]), { ' ', 'Normal' } } }
    vim.api.nvim_buf_set_extmark(report.bufnr, state.namespace(), lnum, col, mark)
  end
  vim.diagnostic.set(state.namespace(), report.bufnr, report.diag, config.diagnostics)
end
--------------------------------------------------------------------------------

local handlers = {
  ruby = adapters.rspec
}

---- Public interface ----------------------------------------------------------
M.setup = function(opts)
  config = vim.tbl_deep_extend('force', config, opts)
end

M.run = {
  nearest = function() state.start(config.run.nearest, config.json_path) end,
  file = function() state.start(config.run.file, config.json_path) end,
  last = function() state.start(config.run.last, config.json_path) end,
}

M.statusline = {
  icon = function()
    return state.has_run() and (
      '󰙨 → ' .. (
        (state.error_count() > 0)
        and glyphs.number(state.error_count())
        or (config.status[state.current()] or {}).icon
      )
    ) or ''
  end,
  color = function() return (config.status[state.current()] or {}).color end,
}

M.redraw = function(data)
  local success, result = handlers.ruby(data, config.json_path)
  if success and result then draw(result) end
end

M.interrupt = function() if state.is_running() then state.stop() end end

return M
