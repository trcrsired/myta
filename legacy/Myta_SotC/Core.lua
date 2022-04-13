local Myta = LibStub("AceAddon-3.0"):GetAddon("Myta")
local Myta_SotC = LibStub("AceAddon-3.0"):NewAddon("Myta_SotC", "AceEvent-3.0","AceTimer-3.0")
local grid

function Myta_SotC:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("Myta_SotCDB",Myta.Module.range())
	self.grid=Myta.UI:CreateGrid(self.db)
	grid = self.grid
	self.db.RegisterCallback(self, "OnProfileChanged", "OnEnable")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnEnable")
	self.db.RegisterCallback(self, "OnProfileReset", "OnEnable")
end

function Myta_SotC:OnEnable()
	grid:Update()
	self:PLAYER_SPECIALIZATION_CHANGED()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	self:RegisterEvent("PLAYER_TALENT_UPDATE","PLAYER_SPECIALIZATION_CHANGED")
end

function Myta_SotC:PLAYER_REGEN_DISABLED()
	self:CancelAllTimers()
	if UnitAffectingCombat("player") then
		self:ScheduleRepeatingTimer("TimerFeedback",self.db.profile.Timer_EnteringCombat)
	else
		self:ScheduleRepeatingTimer("TimerFeedback",self.db.profile.Timer_LeavingCombat)
	end
end

local talent_sotc

function Myta_SotC:PLAYER_SPECIALIZATION_CHANGED()
	local profile = self.db.profile
	if profile.enable and GetSpecialization() == 2 then
		talent_sotc = select(5,GetTalentInfo(3,2,1))
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED","PLAYER_REGEN_DISABLED")
		self:PLAYER_REGEN_DISABLED()
	else
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:CancelAllTimers()
		talent_sotc = nil
		grid:Hide()
	end
end

local tp,_,tp_texture = GetSpellInfo(100780)
local bok,_,bok_texture = GetSpellInfo(100784)
local IsSpellInRange = IsSpellInRange
local UnitBuff = UnitBuff
local TotM = GetSpellInfo(202090)
local mt,_,mt_texture = GetSpellInfo(197908)
local UnitPowerMax = UnitPowerMax
local UnitPower = UnitPower
local velen,_,velen_texture = GetSpellInfo(235966)
local arcane_torrent = GetSpellTexture(129597)
local select = select
local string_format = string.format
local GetTime = GetTime
local GetTalentInfo = GetTalentInfo
local can_cast_act = IsPlayerSpell(129597)
local rsk_texture = GetSpellTexture(107428)

function Myta_SotC:TimerFeedback()
	local gtm = GetTime()
	do
		local name, rank, icon, count, dispelType, duration, expires = UnitBuff("player",mt)
		if name then
			grid.cooldown:SetCooldown(expires-duration,duration)
			grid.center_text:SetText(string_format("%.1f",expires-gtm))
			grid:SetTexture(mt_texture)
			grid:Show()
			return
		end
	end
	do
		local name, rank, icon, count, dispelType, duration, expires = UnitBuff("player",velen)
		if name then
			grid.cooldown:SetCooldown(expires-duration,duration)
			grid.center_text:SetText(string_format("%.1f",expires-gtm))
			grid:SetTexture(velen_texture)
			grid:Show()
			return
		end
	end
	local mana = UnitPower("player",0)
	local mana_max = UnitPowerMax("player",0)
	if can_cast_act then
		local start, duration = GetSpellCooldown(129597)
		if duration == 0 then
			if mana < mana_max * 0.8 then
				grid.center_text:SetText(nil)
				grid:SetTexture(arcane_torrent)
				grid:Show()
				return
			end
		end
	end
	if IsSpellInRange(tp,"target") ~= 1 then
		grid:Hide()
		return
	end
	local name, rank, icon, stacks, dispelType, duration, expires = UnitBuff("player",TotM)
	grid.center_text:SetText(stacks)
	if expires then
		grid.bottom_text:SetText(string_format("%.1f",expires-gtm))
	else
		grid.bottom_text:SetText(nil)
	end
	if mana == mana_max or not talent_sotc then
		local start, duration = GetSpellCooldown(107428) 
		if duration < 2 then
			grid:SetCD(107428)
			grid:SetTexture(rsk_texture)
			grid:Show()
			return
		end
	end
	if stacks == 3 then
		grid:SetCD(100784)
		grid:SetTexture(bok_texture)
	else
		grid:SetCD(100780)
		grid:SetTexture(tp_texture)
	end
	grid:Show()
end