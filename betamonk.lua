--[[
$$\                                 $$$$$$\  $$\                               $$$$$$$$\ $$\                       $$$$$$$\  $$\ $$\                 $$\       $$\      $$\                     $$\       
$$ |                               $$  __$$\ \__|                              \__$$  __|$$ |                      $$  __$$\ $$ |\__|                $$ |      $$$\    $$$ |                    $$ |      
$$ |      $$$$$$\   $$$$$$\        $$ /  \__|$$\ $$$$$$$\                         $$ |   $$$$$$$\   $$$$$$\        $$ |  $$ |$$ |$$\ $$$$$$$\   $$$$$$$ |      $$$$\  $$$$ | $$$$$$\  $$$$$$$\  $$ |  $$\ 
$$ |     $$  __$$\ $$  __$$\       \$$$$$$\  $$ |$$  __$$\       $$$$$$\          $$ |   $$  __$$\ $$  __$$\       $$$$$$$\ |$$ |$$ |$$  __$$\ $$  __$$ |      $$\$$\$$ $$ |$$  __$$\ $$  __$$\ $$ | $$  |
$$ |     $$$$$$$$ |$$$$$$$$ |       \____$$\ $$ |$$ |  $$ |      \______|         $$ |   $$ |  $$ |$$$$$$$$ |      $$  __$$\ $$ |$$ |$$ |  $$ |$$ /  $$ |      $$ \$$$  $$ |$$ /  $$ |$$ |  $$ |$$$$$$  / 
$$ |     $$   ____|$$   ____|      $$\   $$ |$$ |$$ |  $$ |                       $$ |   $$ |  $$ |$$   ____|      $$ |  $$ |$$ |$$ |$$ |  $$ |$$ |  $$ |      $$ |\$  /$$ |$$ |  $$ |$$ |  $$ |$$  _$$<  
$$$$$$$$\\$$$$$$$\ \$$$$$$$\       \$$$$$$  |$$ |$$ |  $$ |                       $$ |   $$ |  $$ |\$$$$$$$\       $$$$$$$  |$$ |$$ |$$ |  $$ |\$$$$$$$ |      $$ | \_/ $$ |\$$$$$$  |$$ |  $$ |$$ | \$$\ 
\________|\_______| \_______|       \______/ \__|\__|  \__|                       \__|   \__|  \__| \_______|      \_______/ \__|\__|\__|  \__| \_______|      \__|     \__| \______/ \__|  \__|\__|  \__|
                                                                                                                                                                                                          
                                                                                                                                                                                                          
    

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

if ts.target and ts.target.type == myHero.type then print(ts.target.charName) end
if ts target and ts.target.type == myHero.type then DrawLine3Dcustom(ts.target.x) end

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
    
    
    menu:addSubMenu("[harass]", "Harras Settings")
        menu.Combo:addParam("harassQ", "use Q in Harass", SCRIPT_PARAM_ONOFF, true)
        menu.Combo:addParam("harassW", "use W in Harass", SCRIPT_PARAM_ONOFF, true)
        menu.combo:addParam("harassE", "use E in Harass", SCRIPT_PARAM_ONOFF, true)
   
    Menu:addSubMenu("Misc settings", "miscs")
        Menu.miscs:addParam("wjump", "Ward Jump", SCRIPT_PARAM_ONKEYDOWN, false, 67)
        Menu.miscs:addParam("wJumpmax", "Ward Jump on max range if mouse too far", SCRIPT_PARAM_ONOFF, true)
        Menu.miscs:addParam("predInSec", "Use prediction for InSec", SCRIPT_PARAM_ONOFF, false)

    Menu:addSubMenu("Draw settings", "draws")
        Menu.draws:addParam("drawInsec", "Draw InSec Line", SCRIPT_PARAM_ONOFF, true)
        Menu.draws:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, false)
        Menu:addSubMenu("Misc settings", "miscs")
        Menu.miscs:addParam("wardJumpmax", "Ward Jump on max range if mouse too far", SCRIPT_PARAM_ONOFF, true)
        Menu.miscs:addParam("predInSec", "Use prediction for InSec", SCRIPT_PARAM_ONOFF, false)
        Menu.miscs:addParam("following", "Follow while combo", SCRIPT_PARAM_ONOFF, true)
        Menu:addSubMenu("Use ult", "useUlt")
    
    ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1050, DAMAGE_PHYSICAL,true)
    ts.name = "Lee Sin"
    Menu:addTS(ts)
  
    
end






