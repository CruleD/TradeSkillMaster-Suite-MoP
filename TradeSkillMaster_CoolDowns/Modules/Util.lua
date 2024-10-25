local TSM = select(2, ...)
local Util = TSM:NewModule("Util")
local CraftIDToProfessionInfo = LibStub("CraftIDToProfessionInfo")
local AceGUI = LibStub("AceGUI-3.0")


function Util:UnQueueItems()
	for ID,Name in pairs(TSM.CraftCDs) do
		local Enabled = TSM.db.factionrealm["CoolDowns"][ID]["Enabled"]
		if Enabled == true then
			TSMAPI:ModuleAPI("Crafting", "removeQueue", ID)
		end
	end
	if ID then
		TSM:Print("Removed selected items from the queue")
	else
		TSM:Print("No item's removed")
	end
end

function Util:QueueItems()
	for ID,Name in pairs(TSM.CraftCDs) do
		local Enabled = TSM.db.factionrealm["CoolDowns"][ID]["Enabled"]
		if Enabled == true then
                        TSMAPI:ModuleAPI("Crafting", "removeQueue", ID)
                        TSMAPI:ModuleAPI("Crafting", "addQueue", ID)
		end
	end
	if ID then
		TSM:Print("Added selected items to Queue")
	else
		TSM:Print("No item's queued")
	end
end

function Util:EnableAll()
	for ID,Name in pairs(TSM.CraftCDs) do
		TSM.db.factionrealm["CoolDowns"][ID]["Enabled"] = true
	end
	TSMAPI:SelectIcon("TSM_CoolDowns","CoolDowns")
end

function Util:DisableAll()
	for ID,Name in pairs(TSM.CraftCDs) do
		TSM.db.factionrealm["CoolDowns"][ID]["Enabled"] = false
	end
	TSMAPI:SelectIcon("TSM_CoolDowns","CoolDowns")
end

function Util:CreateCheck(Name,ID)
	local Ingredient = CraftIDToProfessionInfo:spellIDToIngredients(ID)
	local DName = CraftIDToProfessionInfo:spellIDToName(ID)
	local Check
	
	TSM:CoolDownTimes(ID) -- Refresh DB for ID
	
	if (DName and Ingredient) then
		Check = {
			type = "CheckBox",
			value = TSM.db.factionrealm["CoolDowns"][ID]["Enabled"],
			label = DName.." "..Ingredient..TSM.cdTime,
			tooltip = TSM.Tip,
			fullWidth = false,
			callback = function()
				if TSM.db.factionrealm["CoolDowns"][ID]["Enabled"] == false then
					TSM.db.factionrealm["CoolDowns"][ID]["Enabled"] = true
				elseif TSM.db.factionrealm["CoolDowns"][ID]["Enabled"] == true then
					TSM.db.factionrealm["CoolDowns"][ID]["Enabled"] = false
				end
			end
		}
	else
		Ingredient = "|cff44bbccID "..ID.." |r"
		--print("|cffffcc00TSM_CoolDowns:|r Spell ID#"..ID.." Not found or returned nil, please report to the addon author that "..ID.." was not found")
		Check = {
			type = "CheckBox",
			value = TSM.db.factionrealm["CoolDowns"][ID]["Enabled"],
			label = Name.." "..Ingredient..TSM.cdTime,
			tooltip = "Please report this Spell ID to the addon author.\n"..TSM.Tip,
			fullWidth = false,
			callback = function()
				if TSM.db.factionrealm["CoolDowns"][ID]["Enabled"] == false then
					TSM.db.factionrealm["CoolDowns"][ID]["Enabled"] = true
				elseif TSM.db.factionrealm["CoolDowns"][ID]["Enabled"] == true then
					TSM.db.factionrealm["CoolDowns"][ID]["Enabled"] = false
				end
			end
		}
	end
	return Check
end