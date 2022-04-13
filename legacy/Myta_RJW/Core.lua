local Myta = LibStub("AceAddon-3.0"):GetAddon("Myta")
local Myta_RJW = LibStub("AceAddon-3.0"):NewAddon("Myta_RJW", "AceEvent-3.0","AceTimer-3.0")
local grid
local bar

function Myta_RJW:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("Myta_RJWDB",Myta.Module.range())
	self.grid=Myta.UI:CreateGrid(self.db)
	grid = self.grid
	self.bar=Myta.UI:CreateBar(self.db)
	bar = self.bar
	bar:Set(0,1)
	grid:SetTexture(GetSpellTexture(196725))
	self.db.RegisterCallback(self, "OnProfileChanged", "OnEnable")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnEnable")
	self.db.RegisterCallback(self, "OnProfileReset", "OnEnable")
end

function Myta_RJW:OnEnable()
	grid:Update()
	bar:Update()
	self:PLAYER_SPECIALIZATION_CHANGED()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	self:RegisterEvent("PLAYER_TALENT_UPDATE","PLAYER_SPECIALIZATION_CHANGED")
end

function Myta_RJW:PLAYER_REGEN_DISABLED()
	self:CancelAllTimers()
	if UnitAffectingCombat("player") then
		self:ScheduleRepeatingTimer("TimerFeedback",self.db.profile.Timer_EnteringCombat)
	else
		self:ScheduleRepeatingTimer("TimerFeedback",self.db.profile.Timer_LeavingCombat)
	end
end

function Myta_RJW:PLAYER_SPECIALIZATION_CHANGED()
	local profile = self.db.profile
	if profile.enable and GetSpecialization() == 2 and select(5,GetTalentInfo(6,1,1)) == true then
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
local CheckInteractDistance = CheckInteractDistance
local sp_total= Myta.Math.sp_total
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitInRange = UnitInRange
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local UnitGetTotalHealAbsorbs = UnitGetTotalHealAbsorbs
local UnitDebuff = UnitDebuff
local misery = GetSpellInfo(243961)

function Myta_RJW:TimerFeedback()
	grid:SetCD(196725)
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
	local injured_counts = 0
	local spell = sp_total() * 4.29
	local health_deficits = 0
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
		if not UnitIsDeadOrGhost(u) and CheckInteractDistance(u,3) and ( u == "player" or UnitInRange(u) ) then
			counts = counts + 1
			local h,m = UnitHealth(u),(UnitHealthMax(u)+UnitGetTotalHealAbsorbs(u))
			if h < m then
				injured_counts = injured_counts + 1
				if not UnitDebuff(u,misery) then
					local hd = m - h
					if hd<spell then
						health_deficits = health_deficits + hd
					else
						health_deficits = health_deficits + spell	
					end
				end
			end
		end
	end
	if counts < 6 then
		grid:SetHigh()
	elseif counts < 9 then
		grid:SetMid()
	else
		grid:SetLow()
	end
	grid.center_text:SetText(counts)
	if 6 < injured_counts then
		health_deficits = health_deficits / injured_counts * 6
	end
	bar:Set(health_deficits/3.5,spell*6/3.5)
	grid:Show()
	bar:Show()
end