local AceAddon = LibStub("AceAddon-3.0")
local Myta_Options = AceAddon:GetAddon("Myta_Options")
local Myta_Options_UI = Myta_Options.UI
local Myta_Options_Module = Myta_Options.Module
local options

function Myta_Options_Module:CreateRangeOptions()
	return options or 
	{
		Bar = Myta_Options_UI:CreateBarOptions(),
		Grid = Myta_Options_UI:CreateGridOptions(),
		Timer = Myta_Options_UI:CreateTimerOptions(),
		enable =
		{
			name = ENABLE,
			type = "toggle",
			set = function(info,val)
				local addon = AceAddon:GetAddon(info[1])
				addon.db.profile.enable = val
				addon:PLAYER_SPECIALIZATION_CHANGED()
			end,
			get = function(info)
				local addon = AceAddon:GetAddon(info[1])
				return addon.db.profile.enable
			end,
			width = "full",
		}
	}
end

function Myta_Options_Module:CreateRaidCDOptions()
	return 
	{
		Bar = Myta_Options_UI:CreateBarOptions(),
		Grid = Myta_Options_UI:CreateGridOptions(),
		Timer = Myta_Options_UI:CreateTimerOptions(),
		enable =
		{
			name = ENABLE,
			type = "toggle",
			set = function(info,val)
				local addon = AceAddon:GetAddon(info[1])
				addon.db.profile.enable = val
				addon:PLAYER_SPECIALIZATION_CHANGED()
			end,
			get = function(info)
				local addon = AceAddon:GetAddon(info[1])
				return addon.db.profile.enable
			end,
			width = "full",
		},
		RaidCDPrepareTime =
		{
			name = "Prepare Time",
			type = "range",
			min = 0,
			max = 600,
			set = function(info,val)
				local addon = AceAddon:GetAddon(info[1])
				addon.db.profile.RaidCDPrepareTime = val
			end,
			get = function(info)
				local addon = AceAddon:GetAddon(info[1])
				return addon.db.profile.RaidCDPrepareTime
			end,
		}
	}
end

local dps_options

function Myta_Options_Module:CreateDPSOptions()
	return dps_options or 
	{
		Grid = Myta_Options_UI:CreateGridOptions(),
		Timer = Myta_Options_UI:CreateTimerOptions(),
		enable =
		{
			name = ENABLE,
			type = "toggle",
			set = function(info,val)
				local addon = AceAddon:GetAddon(info[1])
				addon.db.profile.enable = val
				addon:PLAYER_SPECIALIZATION_CHANGED()
			end,
			get = function(info)
				local addon = AceAddon:GetAddon(info[1])
				return addon.db.profile.enable
			end,
			width = "full",
		}
	}
end