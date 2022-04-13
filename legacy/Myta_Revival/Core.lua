local Myta = LibStub("AceAddon-3.0"):GetAddon("Myta")
local Myta_Revival = LibStub("AceAddon-3.0"):NewAddon("Myta_Revival", "AceEvent-3.0","AceTimer-3.0")
local grid
local bar

function Myta_Revival:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("Myta_RevivalDB",Myta.Module.raidcd())
	self.grid=Myta.UI:CreateGrid(self.db)
	grid = self.grid
	self.bar=Myta.UI:CreateBar(self.db)
	bar = self.bar
	bar:Set(0,1)
	grid:SetTexture(GetSpellTexture(115310))
	self.db.RegisterCallback(self, "OnProfileChanged", "OnEnable")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnEnable")
	self.db.RegisterCallback(self, "OnProfileReset", "OnEnable")
end

function Myta_Revival:OnEnable()
	grid:Update()
	bar:Update()
	self:PLAYER_SPECIALIZATION_CHANGED()
	self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	self:RegisterEvent("PLAYER_TALENT_UPDATE","PLAYER_SPECIALIZATION_CHANGED")
end

function Myta_Revival:PLAYER_REGEN_DISABLED()
	self:CancelAllTimers()
	if UnitAffectingCombat("player") then
		self:ScheduleRepeatingTimer("TimerFeedback",self.db.profile.Timer_EnteringCombat)
	else
		self:ScheduleRepeatingTimer("TimerFeedback",self.db.profile.Timer_LeavingCombat)
	end
end

function Myta_Revival:PLAYER_SPECIALIZATION_CHANGED()
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

local rem_info = GetSpellInfo(115151)

local UnitInRaid = UnitInRaid
local UnitInParty = UnitInParty
local string_format = string.format
local GetNumGroupMembers = GetNumGroupMembers
local UnitInRange = UnitInRange
local sp_total= Myta.Math.sp_total
local GetSpellCooldown = GetSpellCooldown
local GetTime = GetTime
local UnitIsVisible = UnitIsVisible
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local predict = Myta.Math.predict
local predict_total = Myta.Math.predict_total
local UnitIsPVP = UnitIsPVP
local GetCritChance = GetCritChance
local GetTraitsCurrentRankSafe = LibArtifactTraits.GetTraitsCurrentRankSafe
local UnitDebuff = UnitDebuff
local misery = GetSpellInfo(243961)

function Myta_Revival:TimerFeedback()
	local start, duration, enable = GetSpellCooldown(115310)
	if self.db.profile.RaidCDPrepareTime + GetTime() < start + duration then
		grid:Hide()
		bar:Hide()
		return
	end
	grid.cooldown:SetCooldown(start, duration, enable)
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
	local vcounts = 0
	local spell = sp_total() * 7.2
	if GetTraitsCurrentRankSafe(933) == 1 then
		spell = spell * 1.12
	end
	local health_deficits = 0
	local crit = GetCritChance()/100
	local pvp = UnitIsPVP("player")
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
		if not UnitIsDeadOrGhost(u) then
			if UnitIsVisible(u) then
				vcounts = vcounts + 1
			end
			if u == "player" or UnitInRange(u) then
				counts = counts + 1
				if not UnitDebuff(u,misery) then
					local maxhealth = UnitHealthMax(u) + UnitGetTotalHealAbsorbs(u) - UnitHealth(u)
					health_deficits = health_deficits + predict()
				end
			end
		end
	end
	if vcounts == 0 then
		grid:Hide()
		bar:Hide()
	end
	if counts == vcounts then
		grid:SetLow()
	elseif vcounts * 3/4 < counts then
		grid:SetMid()
	else
		grid:SetHigh()
	end
	grid.center_text:SetText(counts)
	bar:Set(health_deficits,predict_total(spell,vcounts,crit,pvp))
	grid:Show()
	bar:Show()
end