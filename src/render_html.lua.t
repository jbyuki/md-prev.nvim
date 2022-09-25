##md-prev
@get_current_buffer_content+=
local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

@render_markdown
local markdown = require("markdown")
encoded = markdown(table.concat(lines, "\n"))
