local tvtropes = require "tvtropes"

local success, code, msg = tvtropes.post(
  "WikiSandbox","CLOBBER","STUART","tvtropes-lua test")

if success then
  print "Posted successfully! Go to http://tvtropes.org/pmwiki/pmwiki.php/Main/WikiSandbox to confirm!"
else
  io.stderr:write("Error (",code,"): ",msg,'\n')
end
