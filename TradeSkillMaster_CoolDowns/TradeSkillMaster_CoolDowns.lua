local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TSM_CoolDowns", "AceEvent-3.0", "AceConsole-3.0","AceHook-3.0")
local CraftIDToProfessionInfo = LibStub("CraftIDToProfessionInfo")
TSM.version = GetAddOnMetadata("TradeSkillMaster_CoolDowns", "Version")
local AceGUI = LibStub("AceGUI-3.0") -- load the AceGUI libraries

-- Vars
TSM.CraftCDs = nil


local savedDBDefaults = { --- Default the saved variables
	factionrealm = {
		["AutoQueue"] = false,
		["CoolDowns"] = {
			["*"] = {
				["Name"] = nil,
				["spellID"] = 1,
				["players"] = {
					["*"] = {
						["CoolDownTime"] = 0,
						["coolDownStart"] = 0, --DB Cleanup
						["coolDownDuration"] = 0, --DB Cleanup
						["knownCraft"] = false,
					},
				},
				["Enabled"] = true,
				["LastChecked"] = 0, --Timing NYI
			},
		},
	},
}



function TSM:OnInitialize()
	
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_CoolDownsDB", savedDBDefaults, true)
	
	-- make easier references to all the modules
	for moduleName, module in pairs(TSM.modules) do
		TSM[moduleName] = module
	end
	
	TSM:RegisterModule()
end

function TSM:OnEnable() -- things that need ot be enabled when addon is loaded.
	if TSM.db.factionrealm["AutoQueue"] == false then
		TSM.AutoQueue = "|cffff0000Disabled|r"
	else
		TSM.AutoQueue = "|cff00ff00Enabled|r"
	end
	
	TSM:Hook("Quit", true)
	TSM:Hook("Logout", true)
	
	TSM:CreateItemCoolDownSV() -- Creates the SV for items
	TSM:CoolDownTimesInit()
end

function TSM:RegisterModule()
	TSM.slashCommands = {
		{ key = "UnQueueCoolDowns", label = "Removes previously selected items from the queue", callback = "Util:UnQueueItems" },
		{ key = "QueueCoolDowns", label = "Adds previously selected items to the crafting queue", callback = "Util:QueueItems" },
	}
	
	TSM.icons = {
		{ side = "module", desc = "CoolDowns", slashCommand = "cooldowns", callback = "Options:Load", icon = "Interface\\Icons\\Spell_holy_borrowedtime" },
	} -- need new icon.
	
	TSMAPI:NewModule(TSM)
end

function TSM:CreateItemCoolDownSV() -- Creates the SV for items
	TSM.CraftCDs = TSMAPI:ModuleAPI("Crafting", "getCDCrafts") -- Load the TSM cd crafts
	if TSM.CraftCDs == nil then TSM:Print("ERROR: Table, returned nil. Please report this error to the addon owner on curse.") return end -- return if not recieveing
	
	for ID,Name in pairs(TSM.CraftCDs) do
		--print(ID,Name)
		TSM.db.factionrealm["CoolDowns"][ID]["Name"] = Name -- initiate item
		TSM.db.factionrealm["CoolDowns"][ID]["spellID"] = ID	-- initiate item
	end
end

function TSM:CoolDownTimesInit()
	TSM.player = UnitName("player")
    
	-- Initial Loop to update DB
	TSM:LocalTime()

	for ID in pairs(TSM.CraftCDs) do -- Loop through CD's and update DB
		TSM:CoolDownTimes(ID)
	end
end

 ---- Timing functions implemented here due to being needed on login and Time.lua not loaded at the time.
function TSM:CoolDownTimes(ID)
	local ID = ID
	-- Update Tables for Players Professions
	local coolDownStart, coolDownDuration, enabled = GetSpellCooldown(ID)
	--if not CraftIDToProfessionInfo:spellIDToProfession(ID) then
	--	print("|cffffcc00TSM_CoolDowns:|r Spell ID#"..ID.." Not found or returned nil, please report to the addon author that "..ID.." was not found")
	--end
	TSM.cdTime =(": |cff44bbccUnknown|r")
	TSM.db.factionrealm["CoolDowns"][ID]["players"][TSM.player]["knownCraft"] = IsPlayerSpell(ID)
	if IsPlayerSpell(ID) == true then
		if ( coolDownStart > 0 and coolDownDuration > 0) then
			CoolDownTime = TSM.dTime-GetTime()+coolDownStart+coolDownDuration
			TSM.db.factionrealm["CoolDowns"][ID]["players"][TSM.player]["CoolDownTime"] = CoolDownTime
			TSM.db.factionrealm["CoolDowns"][ID]["players"][TSM.player]["coolDownStart"] = 0 --DB Cleanup
			TSM.db.factionrealm["CoolDowns"][ID]["players"][TSM.player]["coolDownDuration"] = 0 --DB Cleanup
		else
			TSM.db.factionrealm["CoolDowns"][ID]["players"][TSM.player]["CoolDownTime"] = 0
			TSM.db.factionrealm["CoolDowns"][ID]["players"][TSM.player]["coolDownStart"] = 0 --DB Cleanup
			TSM.db.factionrealm["CoolDowns"][ID]["players"][TSM.player]["coolDownDuration"] = 0 --DB Cleanup
		end
	end

	local Red = 0
	local Green = 0
	TSM.Tip = ""

	for name in pairs(TSM.db.factionrealm["CoolDowns"][ID]["players"]) do
		if name then
		local craftCheck = TSM.db.factionrealm["CoolDowns"][ID]["players"][name]["knownCraft"]
			if craftCheck == true then
				local CoolDownTime = TSM.db.factionrealm["CoolDowns"][ID]["players"][name]["CoolDownTime"]
				local coolDownStart = TSM.db.factionrealm["CoolDowns"][ID]["players"][name]["coolDownStart"] --DB Cleanup
				if CoolDownTime > 0 then
					if  (CoolDownTime - TSM.dTime) > 0 then -- Check CoolDown for Reset
						TSM.cdTime =(SecondsToTime(CoolDownTime - TSM.dTime).."|r")
						Red = 1
						TSM.Tip = (TSM.Tip.."\n|cffffcc00"..name..": |cffff0000"..TSM.cdTime)
					else
						TSM.cdTime =("Ready|r")
						TSM.db.factionrealm["CoolDowns"][ID]["players"][name]["CoolDownTime"] = 0
						TSM:AutoQueueCheck(ID) -- check queue
						Green = 1
						TSM.Tip = (TSM.Tip.."\n|cffffcc00"..name..": |cff00ff00"..TSM.cdTime)
					end
				else
					if coolDownStart < 1 then --DB Cleanup
						TSM.cdTime =("Ready|r")
						TSM:AutoQueueCheck(ID)
						Green = 1
						TSM.Tip = (TSM.Tip.."\n|cffffcc00"..name..": |cff00ff00"..TSM.cdTime)
					end --DB Cleanup
				end
				if ( Red == 1 and Green == 0 ) then
					TSM.cdTime =(": |cffff0000"..TSM.cdTime)
				elseif ( Red == 0 and Green == 1 ) then
					TSM.cdTime =(": |cff00ff00"..TSM.cdTime)
				elseif ( Red == 1 and Green == 1 ) then
					TSM.cdTime =(": |cff44bbccCD Available|r")
				end
			else
				TSM.db.factionrealm["CoolDowns"][ID]["players"][name]["CoolDownTime"] = 0
				TSM.db.factionrealm["CoolDowns"][ID]["players"][name]["coolDownStart"] = 0 --DB Cleanup
				TSM.db.factionrealm["CoolDowns"][ID]["players"][name]["coolDownDuration"] = 0 --DB Cleanup
			end
		end
	end
end



function TSM:Logout()
  --  print("Refreshing the DB")
  	TSM:LocalTime()

	for ID in pairs(TSM.CraftCDs) do -- Loop through CD's and Refresh DB Logout
		TSM:CoolDownTimes(ID)
	end
	--  print("DB Refreshed")
end

function TSM:Quit()
	-- print("Refreshing the DB")
	TSM:LocalTime()

	for ID in pairs(TSM.CraftCDs) do -- Loop through CD's and Refresh DB Quit
		TSM:CoolDownTimes(ID)
	end
	--  print("DB Refreshed")
end

function TSM:AutoQueueCheck(ID)
	if TSM.db.factionrealm["AutoQueue"] == true then
		local Enabled = TSM.db.factionrealm["CoolDowns"][ID]["Enabled"]
		if Enabled == true then
			TSMAPI:ModuleAPI("Crafting", "removeQueue", ID) --Attempt to set Queue to 0
			TSMAPI:ModuleAPI("Crafting", "addQueue", ID)
		end
	end
end

function TSM:AutoQueueStatus()
	if TSM.db.factionrealm["AutoQueue"] == true then
		TSM.db.factionrealm["AutoQueue"] = false
		TSM.AutoQueue = "|cffff0000Disabled|r"
	else
		TSM.db.factionrealm["AutoQueue"] = true
		TSM.AutoQueue = "|cff00ff00Enabled|r"
	end
	TSMAPI:SelectIcon("TSM_CoolDowns","CoolDowns")
end

function TSM:LocalTime()
	local s=date("%d %m %Y %X GMT")
	local p="(%d+) (%d+) (%d+) (%d+):(%d+):(%d+) (%a+)"
--	print(s)
	local day,month,year,hour,min,sec,tz=s:match(p)
	TSM.dTime=time({tz=tz,day=day,month=month,year=year,hour=hour,min=min,sec=sec})
--	print(TSM.dTime)
end