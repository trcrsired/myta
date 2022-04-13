if select(3,UnitClass("player")) ~= 10 then
	return
end
local Myta = LibStub("AceAddon-3.0"):NewAddon("Myta","AceEvent-3.0","AceConsole-3.0")

function Myta:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MytaDB",{},true)
	self:RegisterChatCommand("Myta", "ChatCommand")
	local event_zero
	for i = 1, GetNumAddOns() do
		if GetAddOnMetadata(i,"X-MYTA") then
			LoadAddOn(i)
		end
		local event = GetAddOnMetadata(i, "X-MYTA-EVENT")
		if event then
			self:RegisterEvent(event,"loadevent",i)
		end
		local messages = GetAddOnMetadata(i,"X-MYTA-MESSAGE")
		if messages then
			for message in gmatch(messages, "([^,]+)") do
				self:RegisterMessage(message,"loadevent",i)
			end
		end
	end
end

function Myta:ChatCommand(input)
	self:SendMessage("Myta_ChatCommand",input)
end

function Myta:loadevent(p,event,...)
	Myta:UnregisterEvent(event)
	Myta:UnregisterMessage(event)
	if IsAddOnLoaded(p) then
		self:SendMessage(event,...)
		return true
	end
	LoadAddOn(p)
	if IsAddOnLoaded(p) then
		local addon = GetAddOnInfo(p)
		local a = LibStub("AceAddon-3.0"):GetAddon(addon)
		a[event](a,event,...)
		return true
	end
end

local coroutines = {}
Myta.coroutines = coroutines

function Myta.AddCoroutine(co)
	coroutines[#coroutines+1]=co
end

function Myta.GetProfile(name)
	local profile = Myta.db.profile
	local t = profile[name]
	if t == nil then
		t = {}
		profile[name] = t
	end
	return t
end

local function cofunc()
	local current = coroutine.running()
	local coresume = coroutine.resume
	local function resume(...)
		coresume(current,...)
	end
	local ticker
	Myta:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED",resume,0)
	Myta:RegisterEvent("PLAYER_TALENT_UPDATE",resume,0)
	Myta:RegisterEvent("ACTIONBAR_UPDATE_STATE",resume,2)
	Myta:RegisterEvent("ACTIONBAR_UPDATE_USABLE",resume,2)
	Myta:RegisterEvent("SPELL_UPDATE_CHARGES",resume,2)
	Myta:RegisterEvent("PLAYER_TARGET_CHANGED",resume,2)
	Myta:RegisterMessage("Myta_OnProfileChanged",resume,0)
	for i=1,#coroutines do
		coresume(coroutines[i],0)
	end
	local yd,arg1,arg2 = 0
	local refresh = 0
	local is_mistweaver
	while true do
		repeat
		if yd == 3 then
			refresh = refresh + 1
			if refresh < 20 then
				break
			end
--			yd = 1
		end
		if yd == 0 then
			if GetSpecialization() == 2 then
				is_mistweaver = true
				if ticker == nil then
					ticker = C_Timer.NewTicker(0.05,function()
						coroutine.resume(current,1)
					end)
				end
				Myta:RegisterEvent("UNIT_HEALTH",resume,3)
			else
				is_mistweaver = nil
				if ticker then
					ticker:Cancel()
					ticker = nil
				end
				Myta:UnregisterEvent("UNIT_HEALTH")
				yd = -1
			end
			if InCombatLockdown() then
				break
			end
		end
		if not is_mistweaver and yd ~= -1 then
			break
		end
		local max_v,max_t,max_i = 0
		for i=1,#coroutines do
			local status,v,t=coresume(coroutines[i],yd,arg1,arg2)
			if status then
				if v and max_v < v then
					max_i = i
					max_v = v
					max_t = t
				end
			else
				Myta:Print(i,status,v,t)
				table.remove(coroutines,i)
				break
			end
		end
		if max_i then
--			Myta:Print(max_i,max_v,max_t)
		end
		until true
		yd,arg1,arg2 = coroutine.yield()
	end
end

function Myta:OnEnable()
	coroutine.wrap(cofunc)()
end