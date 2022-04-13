if select(2,UnitClass("player")) ~= "MONK" then
	return
end

local Myta = LibStub("AceAddon-3.0"):GetAddon("Myta")
local Myta_UI = Myta.UI

function Myta_UI.GetTimerProperty()
	return
	{
		Timer_EnteringCombat = 0,
		Timer_LeavingCombat = 0.1,		
	}
end