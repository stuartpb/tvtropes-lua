--Required to send to TVTropes site.
local http = require "socket.http"

--It's a pain to write the stupid "source" that LuaSocket expects
local ltn12 = require "ltn12"

--Required to create page post data.
local urlencode = require "urlencode"

--module table
local tvtropes={}

--Function that returns the authenticated TVTropes URL for the given page.
local function pageurl(page)
  return "http://tvtropes.org/pmwiki/pmwiki.php/"..page
end

local function fullname(page)
  --Require pagename
  assert(type(page)=="string","Destination page name required")
  --If no namespace specified, assume Main
  if not string.find(page,'/') then page="Main/"..page end

  return page
end

--Function that posts the given page.
function tvtropes.post(page, body, author, passphrase, reason)

  --Variable validation

  --Validate page name
  page=fullname(page)

  --Assert that there's a body to send
  assert(type(body)=="string","Page body required")

  --Validate that the author and body are both only
  --letters and numbers (a TVTropes sanity check,
  --and this verifies that the Cookie field is valid)
  assert(not string.find(author,"%W"),
    "Author name must be only alphanumeric characters")
  assert(not string.find(passphrase,"%W"),
    "Passphrase must be only alphanumeric characters")

  local responsebody

  local function rcvbody(input)
    responsebody=input
  end

  local form = urlencode.table{
    action="post", post="save",
    pagename=page, text=body,
    author=author,
    reason=reason or "" --reason needs to be in the table
  }

  local response = {
    http.request{
      url=pageurl(page),
      method="POST",
      headers={
        ["Content-Length"]=#form,
        ["Content-Type"]="application/x-www-form-urlencoded",
        ["Cookie"]=table.concat{
          "author=",author,"; ",
          "troperhandle=",author,"; ",
          "mazeltov=",passphrase,"; ",
          "tos=yes"
        },
      },--headers
      source=ltn12.source.string(form), --source
      sink=rcvbody
    }} --response

  --Error on any socket errors
  assert(response[1],response[2])

  --If it doesn't return Found, return nil, the status, and the body:
  --sometimes it just rejects the password for some reason.
  if tonumber(response[2])~=302 then
    return nil, response[2], responsebody
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
    pageurl(page)..'?action=source')

  --Trigger error on socket failure
  assert(body,code)

  --Return the source converted back from the HTML conversion
  return html2plain(body)
end

return tvtropes
