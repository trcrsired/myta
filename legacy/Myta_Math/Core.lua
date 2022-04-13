local Math = {}
local GetSpellBonusHealing = GetSpellBonusHealing
local GetCombatRatingBonus = GetCombatRatingBonus
local GetPerkFactor = LibArtifactTraits.GetPerkFactor
local UnitIsPVP = UnitIsPVP
local GetCritChance = GetCritChance
local GetTraitsCurrentRankSafe = LibArtifactTraits.GetTraitsCurrentRankSafe
local UnitIsVisible = UnitIsVisible
local UnitBuff = UnitBuff

local function sp()
	local v = GetSpellBonusHealing() * (1+ GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)/100) * 1.155 * (1+0.03*GetTraitsCurrentRankSafe(1295)) * 1.04
	if UnitBuff("player",GetSpellInfo(235966),nil,"player") then
		return v*1.15
	else
		return v
	end
end
Math.sp = sp

function Math.sp_total()
	if UnitIsPVP("player") then
		return sp() * (1 + GetCritChance()/200)
	else
		return sp() * (1 + GetCritChance()/100)
	end
end

local UnitHealth, UnitHealthMax, UnitGetTotalHealAbsorbs = UnitHealth, UnitHealthMax, UnitGetTotalHealAbsorbs

function Math.predict(u,base,crit,pvp)
	local maxhealth = UnitHealthMax(u) + UnitGetTotalHealAbsorbs(u) - UnitHealth(u)
	if pvp then
		if maxhealth < base then
			return maxhealth
		elseif maxhealth < base * 1.5 then
			return base * (1-crit) + crit * maxhealth
		else
			return base * (1+crit * 0.5)
		end
	else
		if maxhealth < base then
			return maxhealth
		elseif maxhealth < base * 2 then
			return base * (1-crit) + crit * maxhealth
		else
			return base * (1+crit)
		end
	end
end

local function predict_crit_pvp(crit,pvp)
	if pvp == true then
		return (1+crit * 0.5)
	else
		return (1+crit)
	end
end
Math.predict_crit_pvp = predict_crit_pvp
local function predict_total(base,counts,crit,pvp)
	return base * counts * predict_crit_pvp(crit,pvp)
end
Math.predict_total = predict_total

LibStub("AceAddon-3.0"):GetAddon("Myta").Math = Math