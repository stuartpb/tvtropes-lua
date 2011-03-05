local tvtropes = require "tvtropes"
local post_known = require "tvtropes_post_known"

local success, code, msg = post_known(
  "WikiSandbox",
  "Test out stuff here.\n\nI {{Tropers/"..handle.."}}! I CLOBBER!",
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
