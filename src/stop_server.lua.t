##md-prev
@define+=
function M.stop_server()
  if server then
    server:close()
    server = nil
    print("Server is not running anymore.")
  else
    print("No server was running.")
  end
end
