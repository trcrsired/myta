local AceAddon = LibStub("AceAddon-3.0")
local Myta_Options = AceAddon:GetAddon("Myta_Options")
local Myta_Options_UI = Myta_Options.UI
local LSM = LibStub("LibSharedMedia-3.0")

local cvar_width,cvar_height = string.match(GetCVar("gxFullscreenResolution"), "(%d+)x(%d+)")
cvar_width = tonumber(cvar_width)
cvar_height = tonumber(cvar_height)
local cvar_min = min(cvar_width,cvar_height)

local order = 0
local function get_order()
	local temp = order
	order = order +1
	return temp
end

function Myta_Options_UI:CreateGridOptions()
	order = 0
	local options =
	{
		type = "group",
		name = "Grid",
		args =
		{
			Grid_Enable =
			{
				name = ENABLE,
				type = "toggle",
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Grid_Enable = val
					addon:PLAYER_SPECIALIZATION_CHANGED()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Grid_Enable
				end,
			},
			Grid_Lock =
			{
				name = LOCK,
				type = "toggle",
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Grid_Lock = val
					addon.grid:Lock()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Grid_Lock
				end,
			},
			Grid_Left =
			{
				name = WARDROBE_PREV_VISUAL_KEY,
				type = "range",
				min = 0,
				max = cvar_width,
				step = 1,
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Grid_Left = val
					addon.grid:Position()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Grid_Left
				end,
			},
			Grid_Top =
			{
				name = TRACK_QUEST_TOP_SORTING,
				type = "range",
				min = 0,
				max = cvar_height,
				step = 1,
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Grid_Top = val
					addon.grid:Position()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Grid_Top
				end,
			},
			Grid_Size = 
			{
				name = "Size",
				type = "range",
				min = 0,
				max = cvar_min,
				step = 1,
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Grid_Size = val
					addon.grid:Size()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Grid_Size
				end,
			},
			Grid_CenterTextFont = 
			{
				type = 'select',
				dialogControl = 'LSM30_Font',
				name = "CENTER",
				values = LSM:HashTable("font"),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Grid_CenterTextFont = val
					addon.grid:CenterText()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Grid_CenterTextFont
				end,
			},
			Grid_CenterTextSize =
			{
				name = "Center Text Size",
				type = "range",
				min = 0,
				max = 500,
				step = 1,
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Grid_CenterTextSize = val
					addon.grid:CenterText()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Grid_CenterTextSize
				end,
			},
			Grid_BottomTextFont = 
			{
				type = 'select',
				dialogControl = 'LSM30_Font',
				name = "Bottom Text Font",
				values = LSM:HashTable("font"),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Grid_BottomTextFont = val
					addon.grid:BottomText()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Grid_BottomTextFont
				end,
			},
			Grid_BottomTextSize =
			{
				name = "Bottom Text Size",
				type = "range",
				min = 0,
				max = 500,
				step = 1,
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Grid_BottomTextSize = val
					addon.grid:BottomText()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Grid_BottomTextSize
				end,
			},
			color =
			{
				name = COLOR,
				type = "group",
				args =
				{
					Grid_LowColor =
					{
						type = "color",
						order = get_order(),
						name = LOW,
						hasAlpha = true,
						set = function (info, r,g,b,a)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							profile.Grid_LowColorR = r
							profile.Grid_LowColorG = g
							profile.Grid_LowColorB = b
							profile.Grid_LowColorA = a
						end,
						get = function (info)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							return profile.Grid_LowColorR,profile.Grid_LowColorG,profile.Grid_LowColorB,profile.Grid_LowColorA
						end,
					},
					Grid_MidColor =
					{
						type = "color",
						order = get_order(),
						name = PLAYER_DIFFICULTY1,
						hasAlpha = true,
						set = function (info, r,g,b,a)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							profile.Grid_MidColorR = r
							profile.Grid_MidColorG = g
							profile.Grid_MidColorB = b
							profile.Grid_MidColorA = a
						end,
						get = function (info)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							return profile.Grid_MidColorR,profile.Grid_MidColorG,profile.Grid_MidColorB,profile.Grid_MidColorA
						end,
					},
					Grid_HighColor =
					{
						type = "color",
						order = get_order(),
						name = HIGH,
						hasAlpha = true,
						set = function (info, r,g,b,a)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							profile.Grid_HighColorR = r
							profile.Grid_HighColorG = g
							profile.Grid_HighColorB = b
							profile.Grid_HighColorA = a
						end,
						get = function (info)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							return profile.Grid_HighColorR,profile.Grid_HighColorG,profile.Grid_HighColorB,profile.Grid_HighColorA
						end,
					},
					Grid_BottomTextColor =
					{
						type = "color",
						order = get_order(),
						name = "Bottom Text",
						hasAlpha = true,
						set = function (info, r,g,b,a)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							profile.Grid_BottomTextColorR = r
							profile.Grid_BottomTextColorG = g
							profile.Grid_BottomTextColorB = b
							profile.Grid_BottomTextColorA = a
							addon.grid:BottomTextColor()
						end,
						get = function (info)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							return profile.Grid_BottomTextColorR,profile.Grid_BottomTextColorG,profile.Grid_BottomTextColorB,profile.Grid_BottomTextColorA
						end,
					},
				}
			}
		}
	}
	return options
end