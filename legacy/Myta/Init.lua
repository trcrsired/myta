if select(2,UnitClass("player")) ~= "MONK" then
	return
end

local Myta = LibStub("AceAddon-3.0"):NewAddon("Myta", "AceEvent-3.0","AceConsole-3.0")
Myta.UI = {}
Myta.Module = {}
--------------------------------------------------------------------------------------
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigCmd = LibStub("AceConfigCmd-3.0")
--------------------------------------------------------------------------------------

function Myta:OnInitialize()
	self:RegisterChatCommand("Myta", "ChatCommand")
end

function Myta:OnEnable()
	LoadAddOn("Myta_EF")
	LoadAddOn("Myta_Revival")
	LoadAddOn("Myta_RJW")
	LoadAddOn("Myta_SotC")
end

function Myta:ChatCommand(input)
	if IsAddOnLoaded("Myta_Options") == false then
		local loaded , reason = LoadAddOn("Myta_Options")
		if loaded == false then
			self:Print("Myta_Options: "..reason)
			return
		end
	end
	if not input or input:trim() == "" then
		AceConfigDialog:Open("Myta")
	else
		AceConfigCmd:HandleCommand("Myta", "Myta","")
		AceConfigCmd:HandleCommand("Myta", "Myta",input)
	end
end