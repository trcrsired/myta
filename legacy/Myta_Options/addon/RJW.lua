if not IsAddOnLoaded("Myta_RJW") or select(2,UnitClass("player")) ~= "MONK"  then return end

local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")
local Myta_RJW = AceAddon:GetAddon("Myta_RJW")
local Myta_Options = AceAddon:GetAddon("Myta_Options")
local Myta_Options_UI = Myta_Options.UI
local Myta_Options_Module = Myta_Options.Module

local options = 
{
	name = GetSpellInfo(196725),
	type = "group",
	args = Myta_Options_Module:CreateRangeOptions()
}

options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(Myta_RJW.db)
options.args.profile.order = -1

Myta_Options:push("Myta_RJW",options)