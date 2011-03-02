local tvtropes = require "tvtropes"

--Function that gets strings from files
local function getdata(filename)
  local f=assert(io.open(filename))
  local ret=f:read"*l"
  f:close()
  return ret
end

local author = getdata "handle"
local passphrase = getdata "passphrase"

local success, code, msg = tvtropes.post(
  "WikiSandbox",
  string.gsub("Test out stuff here.\n\nI {{Tropers/$author}}! I CLOBBER!","$author",author),
  author, passphrase,
  "tvtropes-lua test")

if success then
  print "Posted successfully! Go to http://tvtropes.org/pmwiki/pmwiki.php/Main/WikiSandbox to confirm!"
else
  if code == 401 then
    io.stderr:write"Credentials rejected. Check your username and passphrase and try again."
  else
	io.stderr:write("Error (",code,"): ",msg,'\n')
  end
end
