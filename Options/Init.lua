local AceAddon = LibStub("AceAddon-3.0")
local Myta = AceAddon:GetAddon("Myta")
local Myta_Options = AceAddon:NewAddon("Myta_Options","AceEvent-3.0")
Myta_Options.options = {
	type = "group",
	name = "Myta",
	args = {profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(Myta.db)}
}
function Myta_Options:OnInitialize()
	LibStub("AceConfig-3.0"):RegisterOptionsTable("Myta", Myta_Options.options)
	Myta.db.RegisterCallback(Myta_Options, "OnProfileChanged")
	Myta.db.RegisterCallback(Myta_Options, "OnProfileCopied", "OnProfileChanged")
	Myta.db.RegisterCallback(Myta_Options, "OnProfileReset", "OnProfileChanged")
end

function Myta_Options:Myta_ChatCommand(message,input)
	if not input or input:trim() == "" then
		LibStub("AceConfigDialog-3.0"):Open("Myta")
	else
		LibStub("AceConfigCmd-3.0"):HandleCommand("Myta", "Myta",input)
	end
end

function Myta_Options:OnProfileChanged()
	Myta_Options:SendMessage("Myta_OnProfileChanged")
end

function Myta_Options.set_func(info,val)
	local id = tonumber(info[2])
	local p = Myta.db.profile[id][info[1]]
	local meta = getmetatable(p)
	local name = info[3]
	if meta[name] == val then
		val = nil
	end
	rawset(p,name,val)
	coroutine.resume(Myta[info[1]][id],0)
end

function Myta_Options.get_func(info)
	return Myta.db.profile[tonumber(info[2])][info[1]][info[3]]
end

function Myta_Options.set_func_color(info,r,g,b,a)
	local id = tonumber(info[2])
	local p = Myta.db.profile[id][info[1]]
	local n = info[3]
	local meta = getmetatable(p)
	local function mrawset(c,val)
		local nm = n..c
		if meta[nm] == val then
			val = nil
		end
		rawset(p,nm,val)
	end
	mrawset("R",r)
	mrawset("G",g)
	mrawset("B",b)
	mrawset("A",a)
	coroutine.resume(Myta[info[1]][id],0)
end

function Myta_Options.get_func_color(info)
	local id = tonumber(info[2])
	local p = Myta.db.profile[id][info[1]]
	local n = info[3]
	return p[n.."R"],p[n.."G"],p[n.."B"],p[n.."A"]
end

function Myta_Options.GenerateB(key,name,b)
	local gm = {}
	for k,v in pairs(Myta[key]) do
		gm[tostring(k)] = 
		{
			name = GetSpellInfo(k),
			type = "group",
			args = b
		}
	end
	Myta_Options.options.args[key] = 
	{
		type = "group",
		name = name,
		args = gm
	}
end