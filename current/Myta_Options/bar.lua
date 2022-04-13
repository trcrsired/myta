local Myta = LibStub("AceAddon-3.0"):GetAddon("Myta")
local Myta_Options = LibStub("AceAddon-3.0"):GetAddon("Myta_Options")
local LSM = LibStub("LibSharedMedia-3.0")

local cvar_width,cvar_height = string.match(GetScreenResolutions(), "(%d+)x(%d+)")
cvar_width = tonumber(cvar_width)
cvar_height = tonumber(cvar_height)
local cvar_min = min(cvar_width,cvar_height)

local order = 0
local function get_order()
	local temp = order
	order = order + 1
	return temp
end

local set_func = Myta_Options.set_func
local get_func = Myta_Options.get_func
local set_func_color = Myta_Options.set_func_color
local get_func_color = Myta_Options.get_func_color

Myta_Options.GenerateB("bar","Bar",
{
	Enable =
	{
		name = ENABLE,
		type = "toggle",
		order = get_order(),
		set = set_func,
		get = get_func
	},
	Lock =
	{
		name = LOCK,
		type = "toggle",
		order = get_order(),
		set = set_func,
		get = get_func,
	},
	Left =
	{
		name = WARDROBE_PREV_VISUAL_KEY,
		type = "range",
		min = 0,
		max = cvar_width,
		step = 1,
		order = get_order(),
		set = set_func,
		get = get_func,
	},
	Bottom =
	{
		name = "BOTTOM",
		type = "range",
		min = 0,
		max = cvar_height,
		step = 1,
		order = get_order(),
		set = set_func,
		get = get_func,
	},
	PercentageFont =
	{
		type = 'select',
		dialogControl = 'LSM30_Font',
		name = "%",
		values = LSM:HashTable("font"),
		order = get_order(),
		set = set_func,
		get = get_func,
	},
	PercentageFontSize =
	{
		name = FONT_SIZE,
		type = "range",
		min = 0,
		max = 500,
		step = 1,
		order = get_order(),
		set = set_func,
		get = get_func,
	},
	AmountFont =
	{
		type = 'select',
		dialogControl = 'LSM30_Font',
		name = TOTAL,
		values = LSM:HashTable("font"),
		order = get_order(),
		set = set_func,
		get =get_func,
	},
	AmountFontSize =
	{
		name = FONT_SIZE,
		type = "range",
		order = get_order(),
		min = 0,
		max = 500,
		step = 1,
		set = set_func,
		get = get_func,
	},
	Width =
	{
		name = COMPACT_UNIT_FRAME_PROFILE_FRAMEWIDTH,
		type = "range",
		order = get_order(),
		min = 0,
		max = cvar_width,
		step = 1,
		set = set_func,
		get = get_func,
	},
	Height =
	{
		name = COMPACT_UNIT_FRAME_PROFILE_FRAMEHEIGHT,
		type = "range",
		order = get_order(),
		min = 0,
		max = cvar_height,
		step = 1,
		set = set_func,
		get = get_func,
	},
	Low =
	{
		name = LOW,
		type = "range",
		order = get_order(),
		min = 0,
		max = 1,
		isPercent = true,
		set = function(info,val)
			local bar=Myta.db.profile[tonumber(info[2])].bar
			if val <= bar.High then
				rawset(bar,"Low",val)
				coroutine.resume(mbars[id],0)
			end
		end,
		get = get_func,
	},
	High =
	{
		name = HIGH,
		type = "range",
		order = get_order(),
		min = 0,
		max = 1,
		isPercent = true,
		set = function(info,val)
			local bar=Myta.db.profile[tonumber(info[2])].bar
			if bar.Low <= val then
				rawset(bar,"High",val)
				coroutine.resume(mbars[id],0)
			end

		end,
		get = get_func,
	},
	StatusBar = 
	{
		type = 'select',
		dialogControl = 'LSM30_Statusbar',
		name = STATUS_TEXT,
		values = LSM:HashTable("statusbar"),
		order = get_order(),
		set = set_func,
		get = get_func,
	},
	Background = 
	{
		type = 'select',
		dialogControl = 'LSM30_Background',
		name = BACKGROUND,
		values = LSM:HashTable("background"),
		order = get_order(),
		set = set_func,
		get = get_func,
		width = "full",
	},
	LowColor =
	{
		type = "color",
		order = get_order(),
		name = LOW,
		hasAlpha = true,
		set = set_func_color,
		get = get_func_color,
	},
	MidColor =
	{
		type = "color",
		order = get_order(),
		name = PLAYER_DIFFICULTY1,
		hasAlpha = true,
		set = set_func_color,
		get = get_func_color,
	},
	HighColor =
	{
		type = "color",
		order = get_order(),
		name = HIGH,
		hasAlpha = true,
		set = set_func_color,
		get = get_func_color,
	},
})