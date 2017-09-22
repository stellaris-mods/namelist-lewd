pcall(require, "luarocks.loader")
local htmlparser = require("htmlparser")

local ignored = {
	["Categories"] = true,
	["Performers by occupation"] = true,
	["Category"] = true,
	["Discussion"] = true,
	["View source"] = true,
	["History"] = true,
	["Log in"] = true,
	["Main Page"] = true,
	["Browse categories"] = true,
	["List all pages"] = true,
	["Random page"] = true,
	["FAQ"] = true,
	["Help"] = true,
	["Recent changes"] = true,
	["Editors room"] = true,
	["Support Boobpedia"] = true,
	["Contact"] = true,
	["What links here"] = true,
	["Related changes"] = true,
	["Special pages"] = true,
	["Printable version"] = true,
	["Permanent link"] = true,
	["Page information"] = true,
	["Boobpedia Copyright"] = true,
	["Privacy policy"] = true,
	["About Boobpedia"] = true,
	["Disclaimers"] = true,
	["@You"] = true,
	["From mainstream to porn"] = true,
	["Retired porn stars"] = true,
}

-- amazon black breasts chubby d'Eve del descent dreams18
-- models muscular natural porn redhead short stars van with

local removepatterns = {
	["^%l*$"] = true, -- lowercase only
	["%d"] = true, -- any number
	["%)"] = true,
	["%("] = true,
	["List of .- porn stars"] = true,
	["AIKA"] = true,
}

local firstmap = {}
local secondmap = {}

for fileIndex = 1, 26 do
	local f = io.open(tostring(fileIndex) .. ".html", "r")
	local htmlstring = f:read("*all")
	f:close()

	local root = htmlparser.parse(htmlstring)
	local elements = root("li a[href]")

	for _,e in next, elements do
		local content = e:getcontent()
		if not ignored[content] then
			local count = 0
			for s in content:gmatch("%S+") do
				if s:len() > 2 then
					count = count + 1
					if count == 1 then
						firstmap[s] = true
					else
						secondmap[s] = true
					end
				end
			end
		end
	end
end

for entry in pairs(firstmap) do
	for p in pairs(removepatterns) do
		if entry:find(p) then
			firstmap[entry] = nil
			break
		end
	end
end
for entry in pairs(secondmap) do
	for p in pairs(removepatterns) do
		if entry:find(p) then
			secondmap[entry] = nil
			break
		end
	end
end

-- Just build things we can copy+paste directly into the namelist
-- code is crap, doesn't matter :P
local sortfirst = {}
local sortsecond = {}
for n in pairs(firstmap) do table.insert(sortfirst, n) end
for n in pairs(secondmap) do table.insert(sortsecond, n) end
table.sort(sortfirst)
table.sort(sortsecond)

local maxlen = 120
local c = ""
local f = io.open("names.txt", "w")
for _, v in next, sortfirst do
	c = c .. v .. " "
	if c:len() > maxlen then
		f:write(c .. "\n")
		c = ""
	end
end
f:write(c .. "\n\n\n")
c = ""
for _, v in next, sortsecond do
	c = c .. v .. " "
	if c:len() > maxlen then
		f:write(c .. "\n")
		c = ""
	end
end
f:write(c)
f:close()
