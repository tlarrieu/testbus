return {
  status = {
    running = { id = 'running', icon = '󰐌', color = nil }, -- white
    cmdline = { id = 'cmdline', icon = '', color = 'DiagnosticHint' },
    stopped = { id = 'stopped', icon = '', color = 'DiagnosticWarn' },
    success = { id = 'success', icon = '󰗠', color = 'DiagnosticOk' },
    failure = { id = 'failure', icon = '󰅙', color = 'DiagnosticError' },
    panic = { id = 'panic', icon = '󰀨', color = 'DiagnosticUnnecessary' },
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
