--encoding: UTF-8

--Required to post pages
local tvtropes=require "tvtropes"
--Required for encoding Wikipedia article titles
local urlencode=require "urlencode"

--Arrested Development data----------------------------------------------------
adeps={
  {
    "Pilot",
    "Top Banana",
    "Bringing Up Buster",
    "Key Decisions",
    "Visiting Ours",
    "Charity Drive",
    "My Mother, The Car",
    "In God We Trust",
    "Storming the Castle",
    "Pier Pressure",
    "Public Relations",
    "Marta Complex",
    "Beef Consommé",
    "Shock and Aww",
    "Staff Infection",
    "Missing Kitty",
    "Altar Egos",
    "Justice Is Blind",
    "Best Man for the GOB",
    "Whistler's Mother",
    "Not Without My Daughter",
    "Let 'Em Eat Cake"
  },
  {
    "The One Where Michael Leaves",
    "The One Where They Build a House",
    "¡Amigos!",
    "Good Grief",
    "Sad Sack",
    "Afternoon Delight",
    "Switch Hitter",
    "Queen for a Day",
    "Burning Love",
    "Ready, Aim, Marry Me",
    "Out on a Limb",
    "Hand to God",
    "Motherboy XXX",
    "The Immaculate Election",
    "Sword of Destiny",
    "Meat the Veals",
    "Spring Breakout",
    "Righteous Brothers",
  },
  {
    "The Cabin Show",
    "For British Eyes Only",
    "Forget-Me-Now",
    "Notapusy",
    "Mr. F",
    "The Ocean Walker",
    "Prison Break-In",
    "Making a Stand",
    "S.O.B.s",
    "Fakin' It",
    "Family Ties",
    "Exit Strategy",
    "Development Arrested"
  },
}
-------------------------------------------------------------------------------

--Interwiki data---------------------------------------------------------------
local tokens={}

do --wikipedia
  --Numbers for episodes with ambiguous titles, Wikipedia-wise,
  --whose article titles end with "(Arrested Development)"
  local disambigeps={
    {1,2,8,11,20,21,22}, --Season 1
    {5,6,8,9,11,12,18}, --Season 2
    {10,11,12} --Season 3
  }

  --construct lookup table
  local disambiguated={}
  for s=1,#disambigeps do
    disambiguated[s]={}
    for i=1,#disambigeps[s] do
      disambiguated[s][disambigeps[s][i]]=true
    end
  end

  --Function that returns the Wikipedia URL
  function tokens.wikipedia(s,e)
    local pagename=adeps[s][e]
    pagename=string.gsub(pagename,' ','_')
    pagename=urlencode.string(pagename)
    if disambiguated[s][e] then
      --Technically, parentheses don't have to be percent-encoded
      --for HTTP URIs because they're unused sub-delims
      --per section 2.2 of RFC 3986, so we concatenate after
      --the function that percent-encodes all sub-delims
      pagename=pagename.."_(Arrested_Development)"
    end

    return "http://en.wikipedia.org/wiki/"..pagename
  end
end

--Function that returns the URL of the Arrested Development Wikia entry
function tokens.wikia(s,e)
    local pagename=adeps[s][e]
    pagename=string.gsub(pagename,' ','_')
    pagename=urlencode.string(pagename)
    return "http://arresteddevelopment.wikia.com/wiki/"..pagename
end

do --Balboa Observer-Picayune
  --Season 1 episodes that are listed at different numbers
  local s1flips={ [5]=6, [6]=5, [7]=8, [8]=7, [16]=18, [17]=16, [18]=17 }

  --Function the returns the URL of the episode's page on the-op.com
  function tokens.theop(s,e)
    --correct OutOfOrder Season 1 episodes
    if s==1 then e = s1flips[e] or e end
    return string.format("http://the-op.com/episode/%i%02i",s,e)
  end
end

do --IMDB
  --why hello, unreadable block of arbitrary indices, it sure sucks
  --that I have to use you
  local ttnums={
    { 0515236, 0515256, 0515212, 0515223, 0515257,
      0515214, 0515231, 0515221, 0515247, 0515235,
      0515238, 0515226, 0515210, 0515244, 0515246,
      0515228, 0515208, 0515222, 0515211, 0515258,
      0515232, 0515224, },
    { 0515253, 0515254, 0515209, 0515219, 0515243,
      0515207, 0515248, 0515239, 0515213, 0515240,
      0515234, 0515220, 0515229, 0515251, 0515255,
      0515227, 0515245, 0515241, },
    { 0515250, 0515249, 0515218, 0515233, 0515230,
      0515252, 0515237, 0515225, 0515242, 0515216,
      0515217, 0515215, 0757386, }
  }

  --Function that returns the URL for the episode's IMDB page
  function tokens.imdb(s,e)
    return string.format("http://www.imdb.com/title/tt%07i/",ttnums[s][e])
  end
end

do --Hulu, you know, just in case
  local watchnums={
    {    589,  1786,   585,  1781,  1785,
         580,   590,   588,   586,   575,
         576,   579,   577,   644,  1783,
         591,   582,   584,   578,   581,
         583,   587},
    {   6641,  6644,  6643,  6638,  6639,
       12883, 13226, 12561, 12609, 12298,
       12271, 12901, 13248, 13267, 13276,
       13206, 12232, 12532},
    {   6640,  6642,  6635,  6636,  6637,
       12497, 17189, 12523, 13139, 12225,
       12317, 12194, 12215},
  }

  function tokens.hulu(s,e)
    return string.format(
      "http://hulu.com/watch/%i", watchnums[s][e])
  end
end

do --Netflix Watch Instantly
  --It's largely sequential, but not quite.
  --I printed out all the numbers and moved them around
  --to fit the correct order (which is both inconsistent
  --in IDs to Netflix order and Netflix to DVD order).
  local movieids={
    { 70133673, 70133674, 70133675, 70133677, 70133676,
      70133678, 70133680, 70133679, 70133681, 70133682,
      70133683, 70133684, 70133685, 70133686, 70133687,
      70133688, 70133689, 70133690, 70133691, 70133692,
      70133693, 70133694, },
    { 70133695, 70133696, 70133697, 70133698, 70133699,
      70133700, 70133701, 70133702, 70133703, 70133704,
      70133705, 70133706, 70133707, 70133708, 70133711,
      70133709, 70133710, 70133712, },
    { 70133713, 70133714, 70133715, 70133716, 70133717,
      70133718, 70133720, 70133719, 70133721, 70133722,
      70133723, 70133724, 70133725, }
  }

  function tokens.netflix(s,e)
    return string.format(
      "http://www.netflix.com/WiPlayer?movieid=%i",movieids[s][e])
  end
end

-------------------------------------------------------------------------------

--Arrested Development TV Tropes Recap stuff-----------------------------------
local ad_ep_links
do
  local template=[=[
%%STARTLINKS%%
----
Interwiki: [[$wikipedia Wikipedia]] -- [[$wikia Wikia]] -- [[$theop Balboa Observer-Picayune]] -- [[$imdb IMDB]]

Watch now: [[$hulu Hulu]] -- [[$netflix Netflix]]
----
%%ENDLINKS%%
]=]
  function ad_ep_links(s,e)
    return (string.gsub(template,"%$(%w+)",function(token) return tokens[token](s,e) end))
  end
end

--Function that returns the page name of the episode's TVTropes Recap page.
local function recap_pagename(s,e)
  --get the ep title
  local title=adeps[s][e]
  --replace the é in Beef Consommé
  title=string.gsub(title,'é','e')
  --transform to CamelCased WikiWord
  title=string.gsub(title,' (%l?)',string.upper)
  --Remove all non-alphanumeric characters
  title=string.gsub(title,'%W','')

  return string.format("Recap/ArrestedDevelopmentS%iE%i%s",s,e,title)
end

local function post_ad_recap_starter(s,e)
  return tvtropes.post(
    recap_pagename(s,e),
    string.format(
      "\n\n%s\n!The ''ArrestedDevelopment'' episode \"%s\" provides examples of:\n\n",
        ad_ep_links(s,e),adeps[s][e]),
    "STUART",
    "Adding interwiki links and example header automatically (Ask me about Lua)")
end

local function update_links(reason)
  return function(s,e)
    --until comment syntax is changed, Amigos is manual-only
    if s==2 and e==3 then
      print "(Skipping Amigos because the links go all screwy)"
    --as is Beef Consomme
    elseif s==1 and e==13 then
      print "(Skipping Beef Consomme because the links go all screwy)"
    else
      local pagename=recap_pagename(s,e)
      local pageasis=tvtropes.get(pagename)
      local gsubsafelinks = string.gsub(ad_ep_links(s,e),"%%","%%%%")
      local success
      while not success do
        local code
        success, code = tvtropes.post(pagename,
          string.gsub(pageasis,"%%%%STARTLINKS%%%%.-%%%%ENDLINKS%%%%",gsubsafelinks),
          "STUART",reason)
        if not success then print("Retrying... "..code) end
      end
    end
  end
end

local function for_all_eps(f)
  for s=1,#adeps do
    for e=1,#adeps[s] do
      print(string.format('Doing Season %i Episode %i, "%s"...',s,e,adeps[s][e]))
      f(s,e)
    end
  end
end
-------------------------------------------------------------------------------

--Okay, put your executing commands down here.
