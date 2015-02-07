if myHero.charName ~="JarvanIV" then return end

-- Just a Simple J4 Script i will update this after Bol got Item usage back and i got the right pakets.
-- Thanks to TJarvan i learned a lot from his Scripts.
-- Thanks to Fantastik for helping me out learning Lua and ofc Hex who spend a lot of time explaining me all of them
-- 05.02.2015 addet drawings optimized EQ Combo


require 'VPrediction'
require 'SxOrbWalk'

local VP = nil
local ts
local Qready, Wready, Eready, Rready = false, false, false ,false 

-- Loading all Functions --

function OnLoad()

EnemyMinions = minionManager(MINION_ENEMY, 700, myHero, MINION_SORT_MAXHEALTH_DEC)
jungleMinions = minionManager(MINION_JUNGLE, 700, myHero, MINION_SORT_MAXHEALTH_DEC)
Variables()
ts = TargetSelector(TARGET_LESS_CAST, 900, DAMAGE_PHYSICAL)
VP = VPrediction()


-- Loading Menu ---

Menu = scriptConfig ("JarvanIV The Emporer", "JarvanIV")

Menu:addSubMenu ("[JarvanIV - Orbwalker]", "SxOrb")
SxOrb:LoadToMenu(Menu.SxOrb)

Menu:addSubMenu ("[Combo]", "Combo")
Menu.Combo:addParam("combo", "SWBT", SCRIPT_PARAM_ONKEYDOWN, false, 32)
Menu.Combo:addParam("comboEQ", "Use Q+E in SWBT", SCRIPT_PARAM_ONOFF, true)
Menu.Combo:addParam("comboSaveEQ", "Saves EQ for Combo", SCRIPT_PARAM_ONOFF, false)
Menu.Combo:addParam("comboW", "Use W", SCRIPT_PARAM_ONOFF, true)
Menu.Combo:addParam("comboR", "Use R", SCRIPT_PARAM_ONOFF, true)
Menu.Combo:addParam("RHealth", "Use R at % Health of Enemy", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

Menu:addSubMenu("[JarvanIV - Extras]", "Ext")
Menu.Ext:addParam("EQcommand", "EQ Escape Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))

Menu:addSubMenu("[JarvanIV - Drawings]", "drawings")
Menu.drawings:addParam("drawCircleAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
Menu.drawings:addParam("drawCircleEQ", "Draw EQ Range", SCRIPT_PARAM_ONOFF, true)
Menu.drawings:addParam("drawCircleR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)

Menu:addSubMenu("[JarvanIV - Ult Blacklist]", "ultb")
	for i, enemy in pairs(GetEnemyHeroes()) do
		Menu.ultb:addParam(enemy.charName, "Use ult on: "..enemy.charName, SCRIPT_PARAM_ONOFF, true)
	end


Menu:addSubMenu("[JarvanIV - Target Selector]", "targetSelector")
Menu.targetSelector:addTS(ts)
ts.name = "Focus"




Menu.Combo:permaShow("combo")
print("<font color = \"#33CCCC\">JarvanIV - The Emporer by</font> <font color = \"#fff8e7\">MuMuHey GL HF.</font>")

end

-- Diffrent stuff which we asked to load onload defined --

function Variables()
	
	AARange = 175
	
	Qrange = 700
	Qwidth = 70 
	Qspeed = math.huge
	Qdelay = 0.5
	
	Wrange = 300
	Wwidth = 300 
	Wspeed = nil
	Wdelay = 0.5
	
	Erange = 830
	Ewidth = 75 
	Espeed = math.huge 
	Edelay = 0.5
	
	Rrange = 650
	Rwidth = 325 
	Rspeed = nil
	Rdelay = 0.5
end

function spellchecker()
	
	Qready = (myHero:CanUseSpell(_Q) == READY)
	Wready = (myHero:CanUseSpell(_W) == READY)
	Eready = (myHero:CanUseSpell(_E) == READY)
	Rready = (myHero:CanUseSpell(_R) == READY)
end



function ManaCheck(unit, ManaValue)
	if unit.mana < (unit.maxMana * (ManaValue/100))
	then return true
	else
		return false
	end
end

function HealthCheck(unit, HealthValue)
	if unit.health < (unit.maxHealth * (HealthValue/100))
	then return true
	else
		return false
	end
end

function CountEnemies(range, unit)
	local Enemies = 0
	for _, enemy in ipairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) and GetDistance(enemy, unit) < (range or math.huge) then
			Enemies = Enemies + 1
		end
	end
	return Enemies
end

function OnTick()

	if myHero.dead then return end
	EnemyMinions:update()
	jungleMinions:update()
	spellchecker()
	ts:update()

if Menu.Ext.EQcommand then
		mousePosEQ()
	end
	
if Menu.Combo.combo then
		JarvanCombo()
	end
	
if UltActive then
		if CountEnemyHeroInRange(Rwidth) == 0 then
			CastSpell(_R)
		end
	end
	
end


function JarvanCombo()
	if Menu.Combo.comboEQ then
		ComboEQ()
		
	end
	
	if Menu.Combo.comboW then
		ComboW()
	end
	
	if Menu.Combo.comboR then
		ComboR()
	end
end


function ComboR()
	local target = ts.target
	if Menu.Combo.combo then
		for i, target in pairs(GetEnemyHeroes()) do
			if target ~= nil and ValidTarget(target, Rrange) and not ultActive then
				if HealthCheck(target, Menu.Combo.RHealth) == true and blCheck(target) then
					CastSpell(_R, target)
				end
			end
		end
	end
end

function ComboW()
	if CountEnemyHeroInRange(280) >= 1 then
		CastSpell(_W)
	end
end

function ComboEQ()
	if Menu.Combo.combo then
		if Menu.Combo.comboSaveEQ then
			for i, target in pairs(GetEnemyHeroes()) do
				local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, 0.5, 70, 800, 1000)
				if target ~= nil and Qready and Eready and ValidTarget(target) and HitChance >= 2 and GetDistance(CastPosition) < 800 then
						CastSpell(_E, CastPosition.x, CastPosition.z)
						CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		else
			for i, target in pairs(GetEnemyHeroes()) do
				local CastPosition, HitChance, CastPosition = VP:GetCircularCastPosition(target, 0.5, 70, 800, 1000)
				if target ~= nil and ValidTarget(target) and HitChance >= 2 and GetDistance(CastPosition) < 800 then
					CastSpell(_E, CastPosition.x, CastPosition.z)
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
	end
end


function mousePosEQ()
	if Eready and Qready then
		CastSpell(_E, mousePos.x, mousePos.z)
		CastSpell(_Q, mousePos.x, mousePos.z)
	end
	myHero:MoveTo(mousePos.x, mousePos.z)
end


function OnDraw()
	if myHero.dead then return end
	
	if Menu.drawings.drawCircleEQ then
		DrawCircle(myHero.x, myHero.y, myHero.z, 800, 0x111111)
	end
	
	if Menu.drawings.drawCircleAA then
		DrawCircle(myHero.x, myHero.y, myHero.z, 250, ARGB(255, 0, 0, 80))
	end
	
	if Menu.drawings.drawCircleR then
		DrawCircle(myHero.x, myHero.y, myHero.z, 650, 0x111111)
	end
end


function blCheck(target)
	if target ~= nil and Menu.ultb[target.charName] then
		return true
	else
		return false
	end
end

function OnCreateObj(obj)
	if obj.name:find("JarvanCataclysm_tar.troy") then
		ultActive = true
	end
end

function OnDeleteObj(obj)
	if obj.name:find("JarvanCataclysm_tar.troy") then
		ultActive = false
	end
end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("OBECDDEEBGB")
