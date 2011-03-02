--Required to send to TVTropes site.
local http = require"socket.http"

--Required to create page post data.
local urlencode = require "urlencode"

local tvtropes={}

--Function that returns the authenticated TVTropes URL for the given page.
local function authpageurl(page)
  return "http://:foamy@tvtropes.org/pmwiki/pmwiki.php/"..page
end

local function fullname(page)
  --Require pagename
  assert(type(page)=="string","Destination page name required")
  --If no namespace specified, assume Main
  if not string.find(page,'/') then page="Main/"..page end

  return page
end

--Function that posts the given page.
function tvtropes.post(page, body, author, reason)

  page=fullname(page)

  assert(type(body)=="string","Page body required")

  local response =
    {http.request(authpageurl(page),
      urlencode.table{
        action="post", post="save",
        pagename=page, text=body,
        author=author or "Anonymous",
        reason=reason or ""
      })}

  --Error on any socket errors
  assert(response[1],response[2])

  --If it doesn't return Found, return nil, the status, and the body:
  --sometimes it just rejects the password for some reason.
  if tonumber(response[2])~=302 then
    return nil, response[2], response[1]
  else return true
  end
end

--Technically, this is kind of a general function, but it's designed exclusively around
--TVTropes' source converter, so it's kept in here.
local html2plain
do
  local ents = {quot='"', amp='&', lt='<', gt='>'}

  function html2plain(src)
    src=string.gsub(src,"<br/>","\n")
    src=string.gsub(src,"&(%w-);",ents)
    return src
  end
end

--Function that gets a given page source.
function tvtropes.get(page)

  page=fullname(page)

  local body, code = http.request(
    authpageurl(page)..'?action=source')

  --Trigger error on socket failure
  assert(body,code)

  --Return the source converted back from the HTML conversion
  return html2plain(body)
end

return tvtropes
