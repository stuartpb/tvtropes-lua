local tvtropes = require "tvtropes"

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

local success, code, msg = tvtropes.post(
  "WikiSandbox",
  "Test out stuff here.\n\nI {{Tropers/"..handle.."}}! I CLOBBER!",
  handle, passphrase,
  "tvtropes-lua test")

if success then
  print "Posted successfully! Go to http://tvtropes.org/pmwiki/pmwiki.php/Main/WikiSandbox to confirm!"
else
  if code == 401 then
    io.stderr:write("Credentials rejected. ",
	  "Check your handle and passphrase and try again.\n")
  else
	io.stderr:write("Error (",code,"): ",msg,'\n')
  end
end
