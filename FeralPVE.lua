local targetHealth = UnitHealth("target")
local targetHealthMax = UnitHealthMax("target")

local targetIsInRange = IsSpellInRange("Shred", "target")

local energy = UnitPower("player")
local cp = GetComboPoints("player","target")

local eReq_Shred = 39
local eReq_Rake = 34
local eReq_Rip = 29
local eReq_BrutalSlash = 19
local eReq_FerociousBite = 24

local cd_TigersFury = GetSpellCooldown("Tiger's Fury")
local cd_Berserk = GetSpellCooldown("Berserk")
local cd_AshamanesFrenzy = GetSpellCooldown("Ashamane's Frenzy")

local charges_BrutalSlash = GetSpellCharges("Brutal Slash")

local inCombat = UnitAffectingCombat("Player")
local inProwl = UnitAura("Player","Prowl")
local inCatForm = UnitAura("Player","Cat Form")

local _,_,_,_,_,_,debuff_rake_expiration = UnitDebuff("target","Rake",nil,"Player")
local _,_,_,_,_,_,debuff_rip_expiration = UnitDebuff("target","Rip",nil,"Player")

local starter = false
if cd_TigersFury == 0 and cd_Berserk == 0 and cd_AshamanesFrenzy == 0 and inProwl then starter = true end

if debuff_rake_expiration ~= nil then debuff_rake_expiration = debuff_rake_expiration - GetTime() else debuff_rake_expiration = 0 end
if debuff_rip_expiration ~= nil then debuff_rip_expiration = debuff_rip_expiration - GetTime() else debuff_rip_expiration = 0 end

if inProwl == "Prowl" then local inProwl = true end
if not inCombat and not inProwl and inCatForm then CastSpellByName("Prowl") end

if UnitCanAttack("player","target") and targetHealth > 0 and targetIsInRange == 1 then
	if not starter then
		if energy < eReq_Shred and charges_BrutalSlash < 2 and cd_TigersFury == 0 then CastSpellByName("Tiger's Fury") end
		if cp < 5 and cd_Berserk == 0 then CastSpellByName("Berserk") end 
	end
	if starter then
		CastSpellByName("Berserk")
		CastSpellByName("Tiger's Fury")
		CastSpellByName("Rake")
	elseif debuff_rake_expiration == 0 and debuff_rip_expiration == 0 then
		if cd_TigersFury == 0 then CastSpellByName("Tiger's Fury") end
		if energy > eReq_Rake then CastSpellByName("Rake") end
	elseif cp == 5 and debuff_rip_expiration < 5 then
		if debuff_rip_expiration ~= 0 and energy > eReq_FerociousBite and UnitHealth("target") < UnitHealthMax("target") * 26/100 then 
			if cd_TigersFury == 0 then CastSpellByName("Tiger's Fury") end
			CastSpellByName("Ferocious Bite")
		elseif energy > eReq_Rip then 
			if cd_TigersFury == 0 then CastSpellByName("Tiger's Fury") end
			CastSpellByName("Rip")
		end
	elseif cp == 5 then
		if cd_TigersFury < -27.5 then 
			if charges_BrutalSlash > 0 then
				if energy > eReq_BrutalSlash then CastSpellByName("Brutal Slash") end
			else
				if energy > eReq_Shred then CastSpellByName("Shred") end
			end
		elseif debuff_rip_expiration ~= 0 and debuff_rip_expiration < 7 and UnitHealth("target") > UnitHealthMax("target") * 25/100 then
			if cd_TigersFury == 0 then CastSpellByName("Tiger's Fury") end
			if energy > eReq_Rip then CastSpellByName("Rip") end
		else
			if cd_TigersFury == 0 then CastSpellByName("Tiger's Fury") end
			if energy > eReq_FerociousBite then CastSpellByName("Ferocious Bite") end 
		end
	elseif debuff_rake_expiration < 3 then
		if energy > eReq_Rake then CastSpellByName("Rake") end
	elseif cp < 3 and cd_AshamanesFrenzy == 0 and (cd_TigersFury == 0 or (cd_TigersFury - GetTime() > -12)) then
		if cd_Berserk == 0 then CastSpellByName("Berserk") end
		if cd_TigersFury == 0 then CastSpellByName("Tiger's Fury") end
		CastSpellByName("Ashamane's Frenzy")
	elseif charges_BrutalSlash > 0 then
		if energy > eReq_BrutalSlash then CastSpellByName("Brutal Slash") end
	else
		if energy > eReq_Shred then CastSpellByName("Shred") end
	end
end