 
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

changelog v 1.827
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
local sversion = "1.827"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/MuMuHay/BoL-Script/master/The Void - Kassadin.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>The Void Kassadin:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
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
 
 -- lulz 
