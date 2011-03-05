local tvtropes = require "tvtropes"
local tvtropes_post = tvtropes.post

--Function that gets strings from files
local function getdata(filename)
  local f=io.open(filename)
  if f then
    local ret=f:read"*l"
    f:close()
    return ret
  else
    return nil
  end
end

local handle = getdata "handle"
local passphrase = getdata "passphrase"

if not handle then
  io.stdout:write"Enter your troper handle: "
  handle = io.stdin:read"*l"
  while string.find(handle,"%W") or handle == "" do
    print"Handle must be an alphanumeric string."
    io.stdout:write"Try again: "
    handle = io.stdin:read"*l"
  end
end

if not passphrase then
  io.stdout:write"Enter your passphrase: "
  passphrase = io.stdin:read"*l"
  while string.find(passphrase,"%W") or passphrase == "" do
    print"Passphrase must be an alphanumeric string."
    io.stdout:write"Try again: "
    passphrase = io.stdin:read"*l"
  end
end

return function (post, body, reason)
	return tvtropes_post(post, body, handle, passphrase, reason)
end
