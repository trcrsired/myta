if select(2,UnitClass("player")) ~= "MONK" then
	return
end

local Myta = LibStub("AceAddon-3.0"):GetAddon("Myta")
local property

function Myta.Module.range()
	if property == nil then
		local pairs = pairs
		local p =
		{
			enable = true
		}
		local pr = Myta.UI.GetBarProperty()
		local k,v
		for k,v in pairs(pr) do
			p[k]=v
		end
		pr = Myta.UI.GetGridProperty()
		for k,v in pairs(pr) do
			p[k]=v
		end
		pr = Myta.UI.GetTimerProperty()
		for k,v in pairs(pr) do
			p[k]=v
		end
		property=
		{
			profile = p
		}
	end
	return property
end

function Myta.Module.raidcd()
	local tb = Myta.Module.range()
	local b =
	{
		RaidCDPrepareTime = 8
	}
	for k,v in pairs(tb.profile) do
		b[k] = v
	end
	return {profile = b}
end

local dps_property

function Myta.Module.dps()
	if dps_property == nil then
		local pairs = pairs
		local p =
		{
			enable = true
		}
		pr = Myta.UI.GetGridProperty()
		for k,v in pairs(pr) do
			p[k]=v
		end
		pr = Myta.UI.GetTimerProperty()
		for k,v in pairs(pr) do
			p[k]=v
		end
		dps_property=
		{
			profile = p
		}
	end
	return dps_property
end