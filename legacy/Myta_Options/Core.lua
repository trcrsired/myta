local AceAddon = LibStub("AceAddon-3.0")
local AceLocale = LibStub("AceLocale-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local Myta = AceAddon:GetAddon("Myta")
local Myta_Options = AceAddon:GetAddon("Myta_Options")

local optionsFrames = {}

function Myta_Options:OnInitialize()
	local options = Myta_Options : get_table()
	AceConfig:RegisterOptionsTable("Myta", options, nil)
	optionsFrames.general = AceConfigDialog:AddToBlizOptions("Myta", "Myta")
end