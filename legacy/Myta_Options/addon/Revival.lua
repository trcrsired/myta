if not IsAddOnLoaded("Myta_Revival") or select(2,UnitClass("player")) ~= "MONK"  then return end

local AceAddon = LibStub("AceAddon-3.0")
local Myta_Revival = AceAddon:GetAddon("Myta_Revival")
local Myta_Options = AceAddon:GetAddon("Myta_Options")
local Myta_Options_UI = Myta_Options.UI
local Myta_Options_Module = Myta_Options.Module

local options = 
{
	name = GetSpellInfo(115310),
	type = "group",
	args = Myta_Options_Module:CreateRaidCDOptions()
}

options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(Myta_Revival.db)
options.args.profile.order = -1

Myta_Options:push("Myta_Revival",options)