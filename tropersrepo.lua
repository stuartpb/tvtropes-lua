--Script that posts the latest version of the TV Tropes
--scripts to my contributor page.

--Any edit to the functionality of this script tends to generate
--about fifteen or 20 edits to the page: see ProximalErrorProbability.

local tvtropes = require "tvtropes"

local target = "Tropers/STUART"
local user="STUART"

local scripts={
  "urlencode.lua",
  "tvtropes.lua",
  "tropersrepo.lua",
  "arrdev_recap.lua",
}

local function scriptfolder(name,script)
  return string.format(
    "[[folder:%s]]\n%s\n[[/folder]]",
    name,script)
end

local function revsection()
  local folders={
    "%%START".."SCRIPTS%%",
    "[[foldercontrol]]"
  }
  local headers=#folders

  for i=1, #scripts do
    local slines={}
    for line in io.lines(scripts[i]) do

      if line=="" then
        slines[#slines+1]='\\\\'
      else
        --escape everything, and only fiddle with
        --what must be fiddled with
        local escaped = line

        --split anything that would end the escaped region
        escaped=string.gsub(escaped,"=]","=]=[=]")

        --skip tildes because of that thing it does where it
        --replaces them with thorns
        escaped=string.gsub(escaped,"~","=]~[=")

        --also split the folder controls, because hurf durf that ignores
        --non-formatting
        escaped=string.gsub(escaped,"folder]]","folder]=]][=")

        --do I hate this? yes, I do.
        --escape _every single instance of adjacent spaces_
        --to keep them from being folded on commit
        escaped=string.gsub(escaped,"  +",function(s)
          return string.gsub(s," "," =][=")
        end)

        slines[#slines+1]=string.format("@@[=%s=]@@",escaped)
      end
    end

    local content=table.concat(slines,'\n')
    folders[i+headers]=scriptfolder(scripts[i],content)
  end

  folders[#folders+1]="%%END".."SCRIPTS%%"

  return table.concat(folders,"\n\n")
end

local function push(notes)
  local gssscripts=string.gsub(revsection(),"%%","%%%%")

  print(string.format("Getting current version of %s...",target))

  local current=tvtropes.get(target)

  local updated=string.gsub(current,
    "%%%%START".."SCRIPTS%%%%.-%%%%END".."SCRIPTS%%%%",
    gssscripts)

  print(string.format("Posting new version of %s...",target))


  local posted, errcode, msg=tvtropes.post(target,updated,user,notes)
  if not posted then
    io.write("Error code ", errcode, ":\n  ",msg,"\n")
  end
end

--Executing code---------------------------------------------------------------

push()
