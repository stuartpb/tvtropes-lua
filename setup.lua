
io.stdout:write"Enter your troper handle: "
local handle = io.stdin:read"*l"
while string.find(handle,"%W") do
  print"Handle must be an alphanumeric string."
  io.stdout:write"Try again: "
  handle = io.stdin:read"*l"
end

if handle~="" then
  local f=assert(io.open("handle","w"))
  f:write(handle,'\n')
  f:close()
end

io.stdout:write"Enter your passphrase: "
local passphrase = io.stdin:read"*l"
while string.find(passphrase,"%W") do
  print"Passphrase must be an alphanumeric string."
  io.stdout:write"Try again: "
  passphrase = io.stdin:read"*l"
end

if passphrase~="" then
  local f=assert(io.open("passphrase","w"))
  f:write(passphrase,'\n')
  f:close()
end
