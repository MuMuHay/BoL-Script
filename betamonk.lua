--[[
 /$$                                  /$$$$$$  /$$                                                                                     
| $$                                 /$$__  $$|__/                                                                                     
| $$        /$$$$$$   /$$$$$$       | $$  \__/ /$$ /$$$$$$$                                                                            
| $$       /$$__  $$ /$$__  $$      |  $$$$$$ | $$| $$__  $$                                                                           
| $$      | $$$$$$$$| $$$$$$$$       \____  $$| $$| $$  \ $$                                                                           
| $$      | $$_____/| $$_____/       /$$  \ $$| $$| $$  | $$                                                                           
| $$$$$$$$|  $$$$$$$|  $$$$$$$      |  $$$$$$/| $$| $$  | $$                                                                           
|________/ \_______/ \_______/       \______/ |__/|__/  |__/                                                                           
                                                                                                                                       
                                                                                                                                       
                                                                                                                                       
             /$$$$$$$$ /$$                       /$$$$$$$  /$$ /$$                 /$$       /$$      /$$                     /$$      
            |__  $$__/| $$                      | $$__  $$| $$|__/                | $$      | $$$    /$$$                    | $$      
               | $$   | $$$$$$$   /$$$$$$       | $$  \ $$| $$ /$$ /$$$$$$$   /$$$$$$$      | $$$$  /$$$$  /$$$$$$  /$$$$$$$ | $$   /$$
               | $$   | $$__  $$ /$$__  $$      | $$$$$$$ | $$| $$| $$__  $$ /$$__  $$      | $$ $$/$$ $$ /$$__  $$| $$__  $$| $$  /$$/
               | $$   | $$  \ $$| $$$$$$$$      | $$__  $$| $$| $$| $$  \ $$| $$  | $$      | $$  $$$| $$| $$  \ $$| $$  \ $$| $$$$$$/ 
               | $$   | $$  | $$| $$_____/      | $$  \ $$| $$| $$| $$  | $$| $$  | $$      | $$\  $ | $$| $$  | $$| $$  | $$| $$_  $$ 
               | $$   | $$  | $$|  $$$$$$$      | $$$$$$$/| $$| $$| $$  | $$|  $$$$$$$      | $$ \/  | $$|  $$$$$$/| $$  | $$| $$ \  $$
               |__/   |__/  |__/ \_______/      |_______/ |__/|__/|__/  |__/ \_______/      |__/     |__/ \______/ |__/  |__/|__/  \__/
                                                                                                                                       
                                                                                                                                       
                                                                                                                                    


*changelog 09.02.2015 
     Started with the Menu

*changelog 10.02.2015
    finshed so far menu and started with Variables


--]]

if myHero.charName ~= "LeeSin" then return end

require 'VPrediction'

local VP, ts = nil, nil
local player = myHero
local menu = nil





-- called once when the script is loaded
function OnLoad()

    setupMenu()
    setupVars()


end



-- handles script logic, a pure high speed loop
function OnTick()


    if myHero.dead then return end

    if menu.combo then
        combo()
    end

    if menu.inseca then
       insec()
    end

    if menu.insecb then
       insec()
    end

    if menu insecc then
       insec()
    end

    if menu.harass then
        harass()
    end

    if menu.combo or menu.inseca or menu.insecb or menu.insecc then

    if menu.orbwalk then orbWalk() end
    
    end

    if menu.wjump then
        wardJump()
        return
    end

end






--if ts.target and ts.target.type == myHero.type then print(ts.target.charName) end
--if ts target and ts.target.type == myHero.type then DrawLine3Dcustom(ts.target.x) end

end

--handles overlay drawing (processing is not recommended here,use onTick() for that)
function OnDraw()

end


function setupMenu()

    -- Create the menu
    menu = scriptConfig("Lee Sin - The Blind Monk", "LeeSin")
  
    -- Add the target selector
     
     menu:addTS(ts)
     
    -- General Settings
    
    menu:addParam("sep", "-----Lee Sin-The Blind Monk by MuMuHey-----")
    
    menu:addSubMenu ("[combo]", "Combo Settings")
        menu.Combo:addParam("combo", "SBWT", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        menu.Combo:addParam("comboQ", "use Q in Combo", SCRIPT_PARAM_ONOFF, true)
        menu.Combo:addParam("comboW", "use W in Combo", SCRIPT_PARAM_ONOFF, true)
        menu.combo:addParam("comboE", "use E in combo", SCRIPT_PARAM_ONOFF, true)
        menu.combo:addParam("comboR", "use R in combo", SCRIPT_PARAM_ONOFF, true)
        menu.combo:addParam("killsteal", "KillSteal", SCRIPT_PARAM_ONOFF, false)
        menu.combo:addParam("useIgnite", "use Ignite", SCRIPT_PARAM_ONFOFF, false)
    
    menu:addSubMenu ("[insec]", "Insec Settings")
        menu.insec:addParam ("inseca", "insec on key with ward", SCRIPT_PARAMONKEYDOWN, string.byte("T"))
        menu.insec:addParam ("insecb", "insec with flash", SCRIPT_PARAMONKEYDOWN, string.byte("G"))
        menu.insec:addParam ("insecc", "SafeInsec W Flashback Near Ally", SCRIPT_PARAMONKEYDOWN string.byte("P"))
        menu.insec:addParam ("insecto"), "Insec Method", SCRIPT_PARAM_LIST, 1,{"FriendlyObject","Mousepos"})
        menu.insec:addParam("predInSec", "Use prediction for InSec", SCRIPT_PARAM_ONOFF, false)
    
    menu:addSubMenu("[harass]", "Harras Settings")
        menu.Combo:addParam("harassQ", "use Q in Harass", SCRIPT_PARAM_ONOFF, true)
        menu.Combo:addParam("harassW", "use W in Harass", SCRIPT_PARAM_ONOFF, true)
        menu.combo:addParam("harassE", "use E in Harass", SCRIPT_PARAM_ONOFF, true)
   
    menu:addSubMenu("Misc settings", "miscs")
        menu.miscs:addParam("wjump", "Ward Jump", SCRIPT_PARAM_ONKEYDOWN, false, 67)
        menu.miscs:addParam("wJumpmax", "Ward Jump on max range if mouse too far", SCRIPT_PARAM_ONOFF, true)
        menu.miscs:addParam("Orbwalk Method", "use Move to mouse or SOW", SCRIPT_PARAM_LIST, 1,{"OwnOrbW","SOW"})
        

    menu:addSubMenu("Draw settings", "draws")
        menu.draws:addParam("drawInsec", "Draw InSec Line", SCRIPT_PARAM_ONOFF, true)
        menu.draws:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, false)
        menu:addSubMenu("Misc settings", "miscs")
        menu.miscs:addParam("wardJumpmax", "Ward Jump on max range if mouse too far", SCRIPT_PARAM_ONOFF, true)
        menu.miscs:addParam("predInSec", "Use prediction for InSec", SCRIPT_PARAM_ONOFF, false)
        menu.miscs:addParam("following", "Follow while combo", SCRIPT_PARAM_ONOFF, true)
        menu:addSubMenu("Use ult", "useUlt")
    
    ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1050, DAMAGE_PHYSICAL,true)
    ts.name = "Lee Sin"
    Menu:addTS(ts)
  
    
end


function setupVars()

    
    -- Skill Table --
    
        SkillQ =    {name = , range = xx, delay = xx,   Speed = xx,  ready = false    }
        SkillW =    {name = , range = xx, delay = xx,   Speed = xx,  ready = false    }
        SkillE =    {name = , range = xx, delay = xx,   Speed = xx,  ready = false    }
        SkillR =    {name = , range = xx, delay = xx,   Speed = xx,  ready = false    }

      
end


function combo()

    if not ValidTarget(target) then return end

    local distance = player:GetDistance(target)

    if (distance > rangeMax) then return end

    if menu.Combo.combo then
        for i, heroManager.iCount do
            local target = heroManager:GetHero(i)
            if ValidTarget(target,1050) then
                if myHero:CanUseSpell(SkillQ) and menu.combo.comboQ not false == READY then
                    if myHero:GetSpellData(SkillQ).name == "BlindMonkQOne" then
                        local CastPosition, HitChance, CastPosition = VP:GetLineCastPosition(target, delay, range, speed, myHero, true)
                        if HitChance >= 2 then
                            CastSpell(SkillQ, CastPosition.x, CastPosition.z)
                            return 
                        end

    if EREADY and menu.combo.comboE not false then
        if myHero:GetSpellData(SkillE).name == "BlindMonkEOne" and enemiesAround(300) >= 1 then
            CastSpell(_E)
            return

            elseif enemiesAround(450) >= 1 and myHero:GetSpellData(SkillE).namne~= "BlindMonkEone" then
                CastSpell(_E)
                return
            end
        end
    end

    if READY and Menu.combo.comboR not false and myHero:GetDistance(focusEnemy) <= 375 then
        local prociR = getDMG ("R", focusEnemy, myHero) / focusEnemy.health
        local healthLeft = focusEnemy.health - getDmg ("R", focusEnemy, myHero)

        if (prociR > i and prociR <2.5) or (getQDmg(focusEnemy, healthLeft) > healthLeft and targetHasQ(focusEnemy) and QREADY) then
            CastSpell(_R, focusEnemy)
            return
        end
    end

    if WREADY and menu.combo.comboW not false then
        if my Hero:GetSpellData (_W).name ~= "BlindMonkWone" and (myHero.health / myHero.maxHealth ) < 0.6 then
            CastSpell(_W)
            return
        end
    end
end
