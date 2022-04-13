local Myta = LibStub("AceAddon-3.0"):GetAddon("Myta")
local Myta_EF = LibStub("AceAddon-3.0"):NewAddon("Myta_EF", "AceEvent-3.0","AceTimer-3.0")
local grid
local bar

function Myta_EF:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("Myta_EFDB",Myta.Module.range())
	self.grid=Myta.UI:CreateGrid(self.db)
	grid = self.grid
	self.bar=Myta.UI:CreateBar(self.db)
	bar = self.bar
	bar:Set(0,1)
	grid:SetTexture(GetSpellTexture(191837))
	self.db.RegisterCallback(self, "OnProfileChanged", "OnEnable")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnEnable")
	self.db.RegisterCallback(self, "OnProfileReset", "OnEnable")
end

function Myta_EF:OnEnable()
	grid:Update()
	bar:Update()
	self:PLAYER_SPECIALIZATION_CHANGED()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	self:RegisterEvent("PLAYER_TALENT_UPDATE","PLAYER_SPECIALIZATION_CHANGED")
end

function Myta_EF:PLAYER_REGEN_DISABLED()
	self:CancelAllTimers()
	if UnitAffectingCombat("player") then
		self:ScheduleRepeatingTimer("TimerFeedback",self.db.profile.Timer_EnteringCombat)
	else
		self:ScheduleRepeatingTimer("TimerFeedback",self.db.profile.Timer_LeavingCombat)
	end
end

function Myta_EF:PLAYER_SPECIALIZATION_CHANGED()
	local profile = self.db.profile
	if profile.enable and GetSpecialization() == 2 then
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("PLAYER_REGEN_ENABLED","PLAYER_REGEN_DISABLED")
		self:PLAYER_REGEN_DISABLED()
	else
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		self:CancelAllTimers()
		bar:Hide()
		grid:Hide()
	end
end

local UnitInRaid = UnitInRaid
local UnitInParty = UnitInParty
local string_format = string.format
local GetNumGroupMembers = GetNumGroupMembers
local IsItemInRange = IsItemInRange
local sp_total= Myta.Math.sp_total
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitGetTotalHealAbsorbs = UnitGetTotalHealAbsorbs
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitInRange = UnitInRange
local GetTraitsCurrentRankSafe = LibArtifactTraits.GetTraitsCurrentRankSafe
local wipe = wipe
local tb = {}


local function ef_function(n)
	if n < 6 then
		n = 6
	end
	local p = 6/n
	local q = 1-p
	local a,b = 1.35,0.48
	return p*q*q*(a+b)+p*p*q*(2*a+b)+p*p*p*(3*a+b)
end
local UnitDebuff = UnitDebuff
local misery = GetSpellInfo(243961)
function Myta_EF:TimerFeedback()
	grid:SetCD(191837)
	local fmt
	local members
	if UnitInRaid("player") then
		fmt = "raid"
		members = GetNumGroupMembers()
	elseif UnitInParty("player") then
		fmt = "party"
		members = GetNumGroupMembers()
	else
		members = 1
	end
	local counts = 0
	wipe(tb)
	for i = 1,members do
		local u
		if i == members then
			if fmt == "raid" then
				u = fmt..i
			else
				u = "player"
			end
		else
			u = fmt..i
		end
		if not UnitIsDeadOrGhost(u) and IsItemInRange(21519, u) and (u=="player" or UnitInRange(u)) then
			counts = counts + 1
			local h,m = UnitHealth(u),(UnitHealthMax(u)+UnitGetTotalHealAbsorbs(u))
			if h < m then
				if UnitDebuff(u,misery) then
					tb[#tb+1] = 0
				else
					tb[#tb+1] = m-h
				end
			end
		end
	end
	if counts == 0 then
		grid:Hide()
		bar:Hide()
		return
	end
	local injured_counts = #tb
	local spt = sp_total() * ef_function(injured_counts) * (1+GetTraitsCurrentRankSafe(946)*0.05)
	local health_deficits = 0
	for i = 1,injured_counts do
		local ele = tb[i]
		if ele < spt then
			health_deficits = health_deficits + ele
		else
			health_deficits = health_deficits + spt
		end
	end
	if counts < 9 then
		grid:SetHigh()
	elseif counts < 12 then
		grid:SetMid()
	else
		grid:SetLow()
	end
	grid.center_text:SetText(counts)
	if injured_counts < 6 then
		bar:Set(health_deficits/7.2,6*spt/7.2)
	else
		bar:Set(health_deficits/7.2,injured_counts*spt/7.2)		
	end
	grid:Show()
	bar:Show()
end