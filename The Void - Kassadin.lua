 
 if myHero.charName ~= "Kassadin" then return end

--[[
 /$$$$$$$$ /$$                       /$$    /$$          /$$       /$$                     /$$   /$$                                              /$$ /$$          
|__  $$__/| $$                      | $$   | $$         |__/      | $$                    | $$  /$$/                                             | $$|__/          
   | $$   | $$$$$$$   /$$$$$$       | $$   | $$ /$$$$$$  /$$  /$$$$$$$                    | $$ /$$/   /$$$$$$   /$$$$$$$ /$$$$$$$  /$$$$$$   /$$$$$$$ /$$ /$$$$$$$ 
   | $$   | $$__  $$ /$$__  $$      |  $$ / $$//$$__  $$| $$ /$$__  $$       /$$$$$$      | $$$$$/   |____  $$ /$$_____//$$_____/ |____  $$ /$$__  $$| $$| $$__  $$
   | $$   | $$  \ $$| $$$$$$$$       \  $$ $$/| $$  \ $$| $$| $$  | $$      |______/      | $$  $$    /$$$$$$$|  $$$$$$|  $$$$$$   /$$$$$$$| $$  | $$| $$| $$  \ $$
   | $$   | $$  | $$| $$_____/        \  $$$/ | $$  | $$| $$| $$  | $$                    | $$\  $$  /$$__  $$ \____  $$\____  $$ /$$__  $$| $$  | $$| $$| $$  | $$
   | $$   | $$  | $$|  $$$$$$$         \  $/  |  $$$$$$/| $$|  $$$$$$$                    | $$ \  $$|  $$$$$$$ /$$$$$$$//$$$$$$$/|  $$$$$$$|  $$$$$$$| $$| $$  | $$
   |__/   |__/  |__/ \_______/          \_/    \______/ |__/ \_______/                    |__/  \__/ \_______/|_______/|_______/  \_______/ \_______/|__/|__/  |__/
                                                                                                                                                                   
    
	Credits: MuMuHey - Rewriting from Nulled Kassadin
	Fantastik  helping , fixing and teaching me a lot
	HeX teaching me a lot
	
	   Key   |                  What it does
------------------------------------------------------------------------------------
	Spacebar | Combo key - Uses Q, W and R. Spell usage can be disabled.
------------------------------------------------------------------------------------
		V    | Poke key - Uses Q to poke the enemy. Can be disabled.
------------------------------------------------------------------------------------

Other features:

*		Everything can be disabled via the ingame menu.
*		Orbwalking (move to mouse, cancel animation)
*		Smart usage of combos
*		Smart checking if a skill would kill an enemy instantly and casting that one
*		Drawing ranges and combo range (when combo ready)
*		Damage indicators
*		Shows with how many hits the enemy could kill me
*		Safe range mode if health is below 15%, means no R, only if R would kill him
*		Automatic statpoints assignment
*		More to come soon!

changelog v 1.921
	Fixing code and giving some awesomeness from Fantastik 

changelog v 1.826
	adding Autpupdate

changelog v 1.825
	adding Q harass
	

changelog v 1.222
	improving some stuff

changelog v 1.221
	Changing some Code

changelog v 1.120
	Fixing Nulled Kassadin


]]--





--[[		Auto Update		]]
local sversion = "2.1"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/MuMuHay/BoL-Script/master/The Void - Kassadin.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>The Void Kassadin: Ver 2.1</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/MuMuHay/BoL-Script/master/version/The Void - Kassadin.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(sversion) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..sversion.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end
 

------------ Globals ------------
local player = myHero
local target = nil
 
local ts   = nil
local menu = nil
 
local currentHealth = nil
local currentMana   = nil
 
local playingSafe = false
 
local enemyCount = 0
local enemyTable = {}
 
local lastAttack     = 0
local lastWindUpTime = 0
local lastAttackCD   = 0
 
local spells = {[_Q] = { range = 650, level = 0, ready = false, manaUsage = 0, cooldown = 0 },
                [_W] = { range = 200, level = 0, ready = false, manaUsage = 0, cooldown = 0 },
                [_E] = { range = 650, level = 0, ready = false, manaUsage = 0, cooldown = 0 },
                [_R] = { range = 500, level = 0, ready = false, manaUsage = 0, cooldown = 0 }}
 
local hasIgnite    = false
local slotIgnite   = nil
local readyIgnite  = nil
local damageIgnite = 0
 
local stacksE = 0
local stacksR = 0
local gainedBuffE = false
local gainedBuffR = false
------------ Globals end ------------
 
------------ Constants ------------
local Q, W, E, R = _Q, _W, _E, _R
 
local rangeIgnite = 500
local rangeMax    = spells[R].range + spells[Q].range
 
local colorRangeReady        = ARGB(255, 200, 0,   200)
local colorRangeComboReady   = ARGB(255, 255, 128, 0)
local colorRangeNotReady     = ARGB(255, 50,  50,  50)
local colorIndicatorReady    = ARGB(255, 0,   255, 0)
local colorIndicatorNotReady = ARGB(255, 255, 220, 0)
local colorInfo              = ARGB(255, 255, 50,  0)
 
local statsSequence = {Q, W, Q, E, Q, R, Q, E, Q, E, R, E, E, W, W, R, W, W}
 
local buffNameE = "forcepulsecounter"
local buffNameR = "RiftWalk"
------------ Constants end ------------
 
 
-- ############################################################### Callbacks start ###############################################################
 
function OnLoad()
   
    setupVars()
    setupMenu()
   
    -- Create enemy table structure
    for i = 1, heroManager.iCount do
   
        local champ = heroManager:GetHero(i)
       
        if champ.team ~= player.team then
       
            enemyCount = enemyCount + 1
            enemyTable[enemyCount] = { player = champ, name = champ.charName, damageQ = 0, damageE = 0, damageR = 0, indicatorText = "", damageGettingText = "", ready = true}
 
        end
    end
 
end
 
 
function OnTick()
 
    updateGlobals()
    calculateDamageIndicators()
   
    -- Use auto assign stats
    if menu.autoStats and player.level ~= getAssignedStats() then
   
        local currentAssignedStats = getAssignedStats()
 
        -- Precheck if we got stats to assign
        if currentAssignedStats < player.level then
 
            local countTable = {}
       
            for i, spell in ipairs(statsSequence) do  
           
                -- Only check till our level
                if i > player.level then break end
           
                countTable[spell] = { value = countTable[spell] and countTable[spell].value + 1 or 1}
               
                if countTable[spell].value > player:GetSpellData(spell).level then
                    -- Level spell since it needs to be highter than our level is atm
                    LevelSpell(spell)
                end
            end
 
        end
    end
 
    -- Check if combo is active
    if menu.combo then
   
        -- Cast combo
        combo()
   
        -- Use orbwalk
        if menu.orbwalk then orbWalk() end
    end
	
    if menu.blub then
   
        -- Cast combo
        blub()
   
        -- Use orbwalk
        if menu.orbwalk then orbWalk() end
    end
   
   
end
 
 
function OnDraw()    
 
    -- Prevent spamming of error
    if not menu.drawings then return end
   
    -- Draw general info
    if menu.drawings.drawInfo then
        if menu.safeMode and playingSafe and not player.dead then
            local barPos = WorldToScreen(D3DXVECTOR3(player.x, player.y, player.z))
            local posX = barPos.x - 35
            local posY = barPos.y - 30
           
            DrawText("Staying ranged!", 15, posX, posY + 15, colorInfo)
        end
    end
 
    -- Draw circle ranges
    if menu.drawings.drawQ then
        DrawCircle(player.x, player.y, player.z, spells[Q].range, (spells[Q].ready and colorRangeReady or colorRangeNotReady))
        end
    if menu.drawings.drawW then
        DrawCircle(player.x, player.y, player.z, spells[W].range, (spells[W].ready and colorRangeReady or colorRangeNotReady))
        end
    if menu.drawings.drawE then
        DrawCircle(player.x, player.y, player.z, spells[E].range, (spells[E].ready and colorRangeReady or colorRangeNotReady))
        end
    if menu.drawings.drawR then
        DrawCircle(player.x, player.y, player.z, spells[R].range, (spells[R].ready and colorRangeReady or colorRangeNotReady))
        end
    -- Draw combo ranges
    if menu.drawings.drawCombo then
        if spells[R].ready and spells[Q].ready and currentMana >= spells[R].manaUsage + spells[Q].manaUsage then
            DrawCircle(player.x, player.y, player.z, spells[R].range + spells[Q].range, colorRangeComboReady)
        elseif spells[R].ready and spells[E].ready and currentMana >= spells[R].manaUsage + spells[E].manaUsage then
            DrawCircle(player.x, player.y, player.z, spells[R].range + spells[E].range, colorRangeComboReady)
        end
        end
 
    -- Show damage indicators
    if menu.drawings.showDamage then
        for i = 1, enemyCount do
       
            local enemy = enemyTable[i].player
 
            if ValidTarget(enemy) then
           
                local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
                local posX = barPos.x - 35
                local posY = barPos.y - 50
 
                -- Doing damage
                DrawText(enemyTable[i].indicatorText, 15, posX, posY, (enemyTable[i].ready and colorIndicatorReady or colorIndicatorNotReady))
               
                -- Taking damage
                DrawText(enemyTable[i].damageGettingText, 15, posX, posY + 15, ARGB(255, 255, 0, 0))
               
            end
        end
    end
 
end
 
 
function OnGainBuff(unit, buff)
 
    -- Prevent errors
    if not unit or not unit.valid or not unit.isMe then return end
 
    -- ForcePulse (E)
    if unit.isMe and buff.name == buffNameE then
        stacksE = 1
        gainedBuffE = true
    -- RiftWalk (R)
    elseif unit.isMe and buff.name == buffNameR then
        stacksR = 1
        gainedBuffR = true
    end
   
end
 
 
function OnUpdateBuff(unit, buff)
 
    -- Prevent errors
    if not unit or not unit.valid or not unit.isMe then return end
 
    -- ForcePulse (E)
    if unit.isMe and buff.name == buffNameE and gainedBuffE then
        stacksE = stacksE + 1
    -- RiftWalk (R)
    elseif unit.isMe and buff.name == buffNameR and gainedBuffR then
        if stacksR <= 10 then stacksR = stacksR + 1 end
    end
 
end
 
 
function OnLoseBuff(unit, buff)
 
    -- Prevent errors
    if not unit or not unit.valid or not unit.isMe then return end
 
    -- ForcePulse (E)
    if unit.isMe and buff.name == buffNameE and gainedBuffE then
        stacksE = 6
        gainedBuffE = false
    -- RiftWalk (R)
    elseif unit.isMe and buff.name == buffNameR and gainedBuffR then
        stacksR = 0
        gainedBuffR = false
    end
 
end
 
 
function OnProcessSpell(unit, spell)
 
    -- Prevent errors
    if not unit or not unit.valid or not unit.isMe then return end
 
    if spell.name:lower():find("attack") then
        lastAttack = GetTickCount() - GetLatency() / 2
        lastWindUpTime = spell.windUpTime * 1000
        lastAttackCD = spell.animationTime * 1000
    end
 
end
 
-- ############################################################## Callbacks end ##############################################################
 
-- ############################################################### Combo start ###############################################################
 
function combo()
 
    -- Return if no target
    if not ValidTarget(target) then return end
 
    -- Get distance between our champ and the target
    local distance = player:GetDistance(target)
   
    -- Return if no combo could be in range
    if (distance > rangeMax) then return end
   
    -- No safe mode, using R as attack and for gap closing
    if not menu.safeMode or not playingSafe then
        if spells[R].ready then
            -- R
            if menu.useUlt and spells[R].range <= distance and currentMana >= spells[R].manaUsage then
                CastSpell(R, target)
            end
               
            -- Close gap enabled?
            if menu.closeGap then
                -- R + Q
                if spells[Q].ready and spells[Q].range >= distance - spells[R].range and currentMana >= spells[R].manaUsage + spells[Q].manaUsage then
 
                    CastSpell(R, target)
 
                -- R + E (E ready)
                elseif spells[E].ready and spells[E].range >= distance - spells[R].range and currentMana >= spells[R].manaUsage + spells[E].manaUsage then
 
                    CastSpell(R, target)
 
                -- R + E (E not ready yet)
                elseif spells[W].ready and spells[E].cooldown == 0 and stacksE >= 4 and spells[E].range >= distance - spells[R].range and currentMana >= spells[W].manaUsage + spells[R].manaUsage + spells[E].manaUsage then
 
                    CastSpell(R, target)
 
                end
            end
        end
    end
 
    -- Check for instant kill
    for spell, damage in pairs({[Q] = getDmg("Q", target, player),
                                [E] = getDmg("E", target, player),
                                [R] = getDmg("R", target, player)}) do
        if spells[spell].ready and damage >= target.health and spells[spell].range <= distance then
            CastSpell(spell, target)
            break
        end
    end
 
    -- Q
    if distance <= spells[Q].range and spells[Q].ready then
        CastSpell(Q, target)
    end
   
    -- W
    if spells[W].ready and (distance <= spells[W].range or (stacksE == 5 and spells[E].cooldown == 0 and currentMana >= spells[W].manaUsage + spells[E].manaUsage)) then
        CastSpell(W)
    end
 
    -- E
    if distance <= spells[E].range and spells[E].ready then
        CastSpell(E, target)
    end
 
end
 
 
	
	function blub()
		if not ValidTarget(target) then return end
		local distance = player:GetDistance(target)
		if (distance > rangeMax) then return end
		if spells[Q].ready then
		 CastSpell(Q, target)
		end
	end
	
-- ############################################################### Combo end ###############################################################
 
-- ######################################################## Recurring checks start #########################################################
 
function updateGlobals()
 
    -- Update target selector
    ts:update()
 
    -- Set the current target
    target = ts.target
   
    -- Update spells
    for i = 0, 3 do
        spells[i].ready     = player:CanUseSpell(i) == READY
        spells[i].manaUsage = player:GetSpellData(i).mana
        spells[i].cooldown  = player:GetSpellData(i).totalCooldown
        spells[i].level     = player:GetSpellData(i).level
    end
   
    -- Ignite
    if hasIgnite then
        readyIgnite = player:CanUseSpell(slotIgnite) == READY        
        damageIgnite = ValidTarget(target) and getDmg("IGNITE", target, player) or 0
    end
   
    -- Current health and mana
    currentHealth = player.health
    currentMana   = player.mana
   
    -- Staying ranged
    playingSafe = player.health / player.maxHealth < .15
 
end
 
 
function calculateDamageIndicators()
 
    -- Don't calculate this if not wanted
    if not menu.drawings.showDamage then return end
 
    for i = 1, enemyCount do
 
        local enemy = enemyTable[i].player
 
                if ValidTarget(enemy) and enemy.visible then
 
            -- Auto attack damage
            local damageAA = getDmg("AD", enemy, player)
           
            -- Skills damage
            local damageQ  = getDmg("Q", enemy, player)
            local damageE  = getDmg("E", enemy, player)
            local damageR  = getDmg("R", enemy, player)
       
            -- Update enemy table
            enemyTable[i].damageQ = damageQ
            enemyTable[i].damageE = damageE
            enemyTable[i].damageR = damageR
           
            -- Make combos, highest range to lowest
            if enemy.health < damageR then
 
                enemyTable[i].indicatorText = "R Kill"
                enemyTable[i].ready = spells[R].ready and spells[R].manaUsage <= currentMana
 
            elseif enemy.health < damageQ then
 
                enemyTable[i].indicatorText = "Q Kill"
                enemyTable[i].ready = spells[Q].ready and spells[Q].manaUsage <= currentMana
 
            elseif enemy.health < damageE then
 
                enemyTable[i].indicatorText = "E Kill"
                enemyTable[i].ready = spells[E].ready and spells[E].manaUsage <= currentMana
 
            elseif enemy.health < damageR + damageQ then
 
                enemyTable[i].indicatorText = "R + Q Kill"
                enemyTable[i].ready = spells[R].ready and spells[Q].ready and spells[R].manaUsage + spells[Q].manaUsage <= currentMana
 
            elseif enemy.health < damageR + damageE then
 
                enemyTable[i].indicatorText = "R + E Kill"
                enemyTable[i].ready = spells[R].ready and spells[E].ready and spells[R].manaUsage + spells[E].manaUsage <= currentMana
 
            elseif enemy.health < damageR + damageQ + damageE then
 
                enemyTable[i].indicatorText = "R + Q + E Kill"
                enemyTable[i].ready = spells[R].ready and spells[Q].ready and spells[E].ready and spells[R].manaUsage + spells[Q].manaUsage + spells[E].manaUsage <= currentMana
 
            elseif enemy.health < damageQ + damageE + damageR then
 
                enemyTable[i].indicatorText = "All-In Kill"
                enemyTable[i].ready = spells[Q].ready and spells[E].ready and spells[R].ready and spells[Q].manaUsage + spells[E].manaUsage + spells[R].manaUsage <= currentMana
 
            else
 
                local damageTotal = damageQ + damageE + damageR
                local healthLeft = math.round(enemy.health - damageTotal)
                local percentLeft = math.round(healthLeft / enemy.maxHealth * 100)
 
                enemyTable[i].indicatorText = percentLeft .. "% Harass"
                enemyTable[i].ready = spells[Q].ready or spells[E].ready or spells[R].ready
 
            end
 
            -- Calculate damage we could receive
            local enemyDamageAA = getDmg("AD", player, enemy)
 
            -- Number of needed auto attacks for us to die
            local enemyNeededAA = math.ceil(player.health / enemyDamageAA)            
            enemyTable[i].damageGettingText = enemy.charName .. " kills me with " .. enemyNeededAA .. " hits"
 
        end
    end
 
end
 
-- ############################################################# Recurring checks end #############################################################
 
-- ############################################################### Initialize start ###############################################################
 
function setupVars()
 
    -- Initialize TargetSelector
    ts = TargetSelector(TARGET_NEAR_MOUSE, 600, true)
    ts.name = player.charName
   
    -- Check if player has ignite
    slotIgnite = ((player:GetSpellData(SUMMONER_1).name:find("SummonerDot") and SUMMONER_1) or (player:GetSpellData(SUMMONER_2).name:find("SummonerDot") and SUMMONER_2) or nil)
        hasIgnite = slotIgnite ~= nil
   
end
 
 
function setupMenu()
   
    -- Create the menu
    menu = scriptConfig("The Void Kassadin", "kassadin")
   
    -- Add the target selector
    menu:addTS(ts)
   
    -- General settings
    menu:addParam("sep",      "-------- General Settings --------",   SCRIPT_PARAM_INFO,      "")    
    menu:addParam("combo",    "Combo",                                SCRIPT_PARAM_ONKEYDOWN, false, 32)
    menu:addParam("orbwalk",  "Orbwalking",                           SCRIPT_PARAM_ONOFF,     true)
    menu:addParam("useUlt",   "Use ult (R) in combo",                 SCRIPT_PARAM_ONOFF,     true)
    menu:addParam("closeGap", "Use ult (R) as gap closer in combo",   SCRIPT_PARAM_ONOFF,     true)
    menu:addParam("safeMode", "Stay ranged when health < 15%",        SCRIPT_PARAM_ONOFF,     false)
   
    -- Optional settings
    menu:addParam("sep",       "-------- Optional Settings --------", SCRIPT_PARAM_INFO, "")  
    menu:addParam("autoStats", "Automatic assign stats",              SCRIPT_PARAM_ONOFF, false)
   
    -- Submenu -> Draw settings
    menu:addSubMenu("Draw Settings", "drawings")
   
    -- General drawing
    menu.drawings:addParam("sep",        "-------- General --------", SCRIPT_PARAM_INFO,  "")  
    menu.drawings:addParam("drawInfo",   "Draw general info",         SCRIPT_PARAM_ONOFF, true)
   
    -- Ranges
    menu.drawings:addParam("sep",        "-------- Ranges --------",  SCRIPT_PARAM_INFO,  "")  
    menu.drawings:addParam("drawQ",      "Draw Q Range",              SCRIPT_PARAM_ONOFF, true)
    menu.drawings:addParam("drawW",      "Draw W Range",              SCRIPT_PARAM_ONOFF, false)
    menu.drawings:addParam("drawE",      "Draw E Range",              SCRIPT_PARAM_ONOFF, true)
    menu.drawings:addParam("drawR",      "Draw R Range",              SCRIPT_PARAM_ONOFF, true)
    menu.drawings:addParam("drawCombo",  "Draw Combo Range",          SCRIPT_PARAM_ONOFF, true)
   
    -- Utlity
    menu.drawings:addParam("sep",        "-------- Utility --------", SCRIPT_PARAM_INFO,  "")  
    menu.drawings:addParam("showDamage", "Show damage indicator",     SCRIPT_PARAM_ONOFF, true)
   
   -- Harass
    menu:addParam("sep",       "-------- Harass --------", SCRIPT_PARAM_INFO, "")
	menu:addParam("blub", "Harass with Q", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
   
    -- Options to show permanently
    menu:permaShow("useUlt")
    menu:permaShow("closeGap")
    menu:permaShow("safeMode")
   
   print("<font color = \"#33CCCC\">The Void - Kassadin by</font> <font color = \"#fff8e7\">MuMuHey GL HF. If you like the Script like it on Scriptstatus and on the Topic <3</font>")

   
end
 
-- ############################################################### Initialize end ###############################################################
 
-- ############################################################### General start ###############################################################
 
function getAssignedStats()
    return spells[Q].level + spells[W].level + spells[E].level + spells[R].level
end
 
 
function orbWalk()
 
    if target ~= nil and player:GetDistance(target) <= getTrueRange() then
        if playerCanAttack() then
            player:Attack(target)
        elseif playerCanMove() then
            moveToCursor()
        end
    else
        moveToCursor()
    end
end
 
 
function getTrueRange()
    return player.range + player:GetDistance(player.minBBox)
end
 
 
function playerCanMove()
    return (GetTickCount() + GetLatency() / 2 > lastAttack + lastWindUpTime + 20)
end
 
 
function playerCanAttack()
    return (GetTickCount() + GetLatency() / 2 > lastAttack + lastAttackCD)
end
 
 
function moveToCursor()
 
        if player:GetDistance(mousePos) > 150 or lastAnimation == "Idle1" then
   
                local moveToPos = player + (Vector(mousePos) - player):normalized()*300
                player:MoveTo(moveToPos.x, moveToPos.z)
       
        end    
   
end
