local file = require('testbus.file')

---@class State
---@field namespace function
---@field has_run function
---@field is_done function
---@field start function
---@field cmdline function
---@field stop function
---@field panic function
---@field fail function
---@field succeed function
---@field current function
local _M = {}

---@enum Status
Status = {
  RUNNING = 'running',
  CMDLINE = 'cmdline',
  STOPPED = 'stopped',
  SUCCESS = 'success',
  FAILURE = 'failure',
  PANIC = 'panic',
}

_M.namespace = function() return vim.api.nvim_create_namespace('testbus') end

_M.has_run = function() return vim.g.testbus_status ~= nil end
_M.is_running = function()
  return vim.g.testbus_status == Status.RUNNING
      or vim.g.testbus_status == Status.CMDLINE
end
_M.is_done = function() return not _M.is_running() end

---@param fun fun() the function starting the test, it should write to a file and to STDOUT
---@param path string the path to the output json
_M.start = function(fun, path)
  if _M.is_running() then return false end
  file.rm(path)
  vim.diagnostic.set(_M.namespace(), 0, {}, {})
  vim.g.testbus_bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(vim.g.testbus_bufnr, _M.namespace(), 0, -1)
  vim.g.testbus_status = Status.RUNNING
  vim.g.testbus_failures = nil
  fun()
end
_M.cmdline = function() vim.g.testbus_status = Status.CMDLINE end
_M.stop = function() vim.g.testbus_status = Status.STOPPED end
_M.panic = function() vim.g.testbus_status = Status.PANIC end
_M.fail = function(count)
  vim.g.testbus_status = Status.FAILURE
  vim.g.testbus_failures = count
end
_M.succeed = function() vim.g.testbus_status = Status.SUCCESS end

_M.current = function() return vim.g.testbus_status end
_M.error_count = function() return vim.g.testbus_failures or 0 end

return _M
