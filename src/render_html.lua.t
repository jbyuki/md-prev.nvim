##md-prev
@get_current_buffer_content+=
local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

@render_markdown
local md = require("md")
encoded = md(table.concat(lines, "\n"))
