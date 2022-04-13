if not IsAddOnLoaded("Myta_EF") or select(2,UnitClass("player")) ~= "MONK"  then return end

local AceAddon = LibStub("AceAddon-3.0")
local Myta_SotC = AceAddon:GetAddon("Myta_SotC")
local Myta_Options = AceAddon:GetAddon("Myta_Options")
local Myta_Options_UI = Myta_Options.UI
local Myta_Options_Module = Myta_Options.Module

local options = 
{
	name = GetSpellInfo(191837),
	type = "group",
	args = Myta_Options_Module:CreateDPSOptions()
}

options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(Myta_SotC.db)
options.args.profile.order = -1

Myta_Options:push("Myta_SotC",options)