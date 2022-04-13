local LibStub = LibStub
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
	order = order + 1
	return temp
end

function Myta_Options_UI:CreateBarOptions()
	order = 0
	local options =
	{
		type = "group",
		name = "Bar",
		args =
		{
			Bar_Enable =
			{
				name = ENABLE,
				type = "toggle",
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Bar_Enable = val
					addon:PLAYER_SPECIALIZATION_CHANGED()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_Enable
				end,
			},
			Bar_Lock =
			{
				name = LOCK,
				type = "toggle",
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Bar_Lock = val
					addon.bar:Lock()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_Lock
				end,
			},
			Bar_Left =
			{
				name = WARDROBE_PREV_VISUAL_KEY,
				type = "range",
				min = 0,
				max = cvar_width,
				step = 1,
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Bar_Left = val
					addon.bar:Position()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_Left
				end,
			},
			Bar_Top =
			{
				name = TRACK_QUEST_TOP_SORTING,
				type = "range",
				min = 0,
				max = cvar_height,
				step = 1,
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Bar_Top = val
					addon.bar:Position()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_Top
				end,
			},
			Bar_PercentageFont =
			{
				type = 'select',
				dialogControl = 'LSM30_Font',
				name = "%",
				values = LSM:HashTable("font"),
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Bar_PercentageFont = val
					addon.bar:PercentFont()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_PercentageFont
				end,
			},
			Bar_PercentageFontSize =
			{
				name = FONT_SIZE,
				type = "range",
				min = 0,
				max = 500,
				step = 1,
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Bar_PercentageFontSize = val
					addon.bar:PercentFont()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_PercentageFontSize
				end,
			},
			Bar_AmountFont =
			{
				type = 'select',
				dialogControl = 'LSM30_Font',
				name = TOTAL,
				values = LSM:HashTable("font"),
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Bar_AmountFont = val
					addon.bar:AmountFont()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_AmountFont
				end,
			},
			Bar_AmountFontSize =
			{
				name = FONT_SIZE,
				type = "range",
				order = get_order(),
				min = 0,
				max = 500,
				step = 1,
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Bar_AmountFontSize = val
					addon.bar:AmountFont()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_AmountFontSize
				end,
			},
			Bar_Width =
			{
				name = COMPACT_UNIT_FRAME_PROFILE_FRAMEWIDTH,
				type = "range",
				order = get_order(),
				min = 0,
				max = cvar_width,
				step = 1,
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Bar_Width = val
					addon.bar:Size()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_Width
				end,
			},
			Bar_Height =
			{
				name = COMPACT_UNIT_FRAME_PROFILE_FRAMEHEIGHT,
				type = "range",
				order = get_order(),
				min = 0,
				max = cvar_height,
				step = 1,
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Bar_Height = val
					addon.bar:Size()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_Height
				end,
			},
			Bar_Low =
			{
				name = LOW,
				type = "range",
				order = get_order(),
				min = 0,
				max = 1,
				isPercent = true,
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					local profile = addon.db.profile
					if val <= profile.Bar_High then
						profile.Bar_Low = val

					end
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_Low
				end,
			},
			Bar_High =
			{
				name = HIGH,
				type = "range",
				order = get_order(),
				min = 0,
				max = 1,
				
				isPercent = true,
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					local profile = addon.db.profile
					if profile.Bar_Low <= val then
						profile.Bar_High = val
					end
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_High
				end,
			},
			color =
			{
				name = COLOR,
				type = "group",
				args =
				{
					Bar_LowColor =
					{
						type = "color",
						order = get_order(),
						name = LOW,
						hasAlpha = true,
						set = function (info, r,g,b,a)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							profile.Bar_LowColorR = r
							profile.Bar_LowColorG = g
							profile.Bar_LowColorB = b
							profile.Bar_LowColorA = a
						end,
						get = function (info)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							return profile.Bar_LowColorR,profile.Bar_LowColorG,profile.Bar_LowColorB,profile.Bar_LowColorA
						end,
					},
					Bar_MidColor =
					{
						type = "color",
						order = get_order(),
						name = PLAYER_DIFFICULTY1,
						hasAlpha = true,
						set = function (info, r,g,b,a)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							profile.Bar_MidColorR = r
							profile.Bar_MidColorG = g
							profile.Bar_MidColorB = b
							profile.Bar_MidColorA = a
						end,
						get = function (info)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							return profile.Bar_MidColorR,profile.Bar_MidColorG,profile.Bar_MidColorB,profile.Bar_MidColorA
						end,
					},
					Bar_HighColor =
					{
						type = "color",
						order = get_order(),
						name = HIGH,
						hasAlpha = true,
						set = function (info, r,g,b,a)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							profile.Bar_HighColorR = r
							profile.Bar_HighColorG = g
							profile.Bar_HighColorB = b
							profile.Bar_HighColorA = a
						end,
						get = function (info)
							local addon = AceAddon:GetAddon(info[1])
							local profile = addon.db.profile
							return profile.Bar_HighColorR,profile.Bar_HighColorG,profile.Bar_HighColorB,profile.Bar_HighColorA
						end,
					},
				}
			},
			Bar_StatusBar = 
			{
				type = 'select',
				dialogControl = 'LSM30_Statusbar',
				name = STATUS_BAR_TEXT,
				values = LSM:HashTable("statusbar"),
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Bar_StatusBar = val
					addon.bar:StatusBar()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_StatusBar
				end,
			},
			Bar_Background = 
			{
				type = 'select',
				dialogControl = 'LSM30_Background',
				name = BACKGROUND,
				values = LSM:HashTable("background"),
				order = get_order(),
				set = function(info,val)
					local addon = AceAddon:GetAddon(info[1])
					addon.db.profile.Bar_Background = val
					addon.bar:Background()
				end,
				get = function(info)
					local addon = AceAddon:GetAddon(info[1])
					return addon.db.profile.Bar_Background
				end,
				width = "full",
			}
		}
	}
	return options
end