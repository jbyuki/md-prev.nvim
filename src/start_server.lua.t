##md-prev
@define+=
function M.start_server(port)
  @create_tcp_server
  @listen_server
end

@variables+=
local server

@create_tcp_server+=
if server then
  server:shutdown()
  server = nil
end

server = vim.loop.new_tcp()
server:bind("127.0.0.1", port or 0)

if not server:getsockname() then
  vim.api.nvim_echo({{"ERROR: Server start failed. Choosing a different port might help. For example to connect to port 8082, call start_server(8082)", "ErrorMsg"}}, true, {})
  return 
end

port = server:getsockname().port
vim.api.nvim_echo({{("Server started on port %d"):format(port), "Normal"}}, true, {})

@listen_server+=
local ret, err = server:listen(128, function(err)
	local sock = vim.loop.new_tcp()
	server:accept(sock)
	local conn
	@client_internal_variables
	@register_socket_read_callback
end)

@register_socket_read_callback+=
sock:read_start(function(err, chunk)
	if chunk then
		@read_message_tcp
	else
		sock:shutdown()
		sock:close()
	end
end)

@client_internal_variables+=
local http_data = ""

local remaining = 0
local first_chunk

@read_message_tcp+=
http_data = http_data .. chunk
if string.match(http_data, "\r\n\r\n$") then
  @send_markdown_html
	http_data = ""
end

@send_markdown_html+=
vim.schedule(function()
  local encoded = "No markdown :("
  if vim.bo.filetype == "markdown" then
    @get_current_buffer_content
    @render_markdown
  end
	sock:write("HTTP/1.1 200 OK\r\n")
	sock:write("Content-Type: text/html\r\n")
	sock:write("Content-Length: " .. string.len(encoded) .. "\r\n")
	sock:write("\r\n")
	sock:write(encoded)
end)
