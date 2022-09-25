-- Generated using ntangle.nvim
local M = {}
local server

function M.version()
  return "0.0.1"
end
function M.start_server(port)
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

  local ret, err = server:listen(128, function(err)
  	local sock = vim.loop.new_tcp()
  	server:accept(sock)
  	local conn
  	local http_data = ""

  	local remaining = 0
  	local first_chunk

  	sock:read_start(function(err, chunk)
  		if chunk then
  			http_data = http_data .. chunk
  			if string.match(http_data, "\r\n\r\n$") then
  			  vim.schedule(function()
  			    local encoded = "No markdown :("
  			    if vim.bo.filetype == "markdown" then
  			      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

  			      local markdown = require("markdown")
  			      encoded = markdown(table.concat(lines, "\n"))
  			    end
  			  	sock:write("HTTP/1.1 200 OK\r\n")
  			  	sock:write("Content-Type: text/html\r\n")
  			  	sock:write("Content-Length: " .. string.len(encoded) .. "\r\n")
  			  	sock:write("\r\n")
  			  	sock:write(encoded)
  			  end)
  				http_data = ""
  			end

  		else
  			sock:shutdown()
  			sock:close()
  		end
  	end)

  end)

end

function M.stop_server()
  if server then
    server:shutdown()
    server = nil
    print("Server is not running anymore.")
  else
    print("No server was running.")
  end
end
return M

