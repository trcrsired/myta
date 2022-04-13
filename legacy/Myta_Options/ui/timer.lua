local AceAddon = LibStub("AceAddon-3.0")
local Myta_Options = AceAddon:GetAddon("Myta_Options")
local Myta_Options_UI = Myta_Options.UI

function Myta_Options_UI:CreateTimerOptions()
	order = 0
	local options =
	{
		type = "group",
		name = "Timer",
		args =
		{
			Timer_EnteringCombat =
			{
				name = ENTERING_COMBAT,
				type = "range",
				min = 0,
				max = 10,
				step = 0.01,
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Timer_EnteringCombat = val
					addon:PLAYER_REGEN_DISABLED()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Timer_EnteringCombat
				end,
			},
			Timer_LeavingCombat =
			{
				name = LEAVING_COMBAT,
				type = "range",
				min = 0,
				max = 10,
				step = 0.01,
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Timer_LeavingCombat = val
					addon:PLAYER_REGEN_DISABLED()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Timer_LeavingCombat
				end,
			}
		}
	}
	return options
end