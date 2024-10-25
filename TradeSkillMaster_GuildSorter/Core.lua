local TSM = select(2, ...)
TSM = LibStub("AceAddon-3.0"):NewAddon(TSM, "TSM_GuildSorter", "AceEvent-3.0", "AceConsole-3.0")
TSM.version = GetAddOnMetadata("TradeSkillMaster_GuildSorter", "Version")

local savedDBDefaults = {
	global = {
		optionsTreeStatus = {},
		["Guilds"] = {
			["*"] = {
				["GuildName"] = "",
				["Tabs"] = {},
			},
		},
	},
}

function TSM:OnInitialize()
	
	TSM.db = LibStub:GetLibrary("AceDB-3.0"):New("TradeSkillMaster_GuildSorterDB", savedDBDefaults, true)
	
	TSM.PlayerGuild = select(1,GetGuildInfo("player"))
	TSM:RegisterEvent("GUILDBANKFRAME_CLOSED")
	TSM:RegisterEvent("GUILDBANKFRAME_OPENED")
	
	-- make easier references to all the modules
	for moduleName, module in pairs(TSM.modules) do
		TSM[moduleName] = module
	end
	
	TSM:RegisterModule()

	if select(4, GetAddOnInfo("TradeSkillMaster_ItemTracker")) == 1 then
		for _, name in ipairs(TSMAPI:ModuleAPI("ItemTracker", "guildlist") or {}) do
			if not TSM.db.global["Guilds"][name]["GuildName"] then 
				TSM.db.global["Guilds"][name]["GuildName"] = name 
			end
		end
	end
end

-- registers this module with TSM by first setting all fields and then calling TSMAPI:NewModule().
function TSM:RegisterModule()
	TSM.slashCommands = {
		{ key = "SortToGuildBank", label = "Will sort items from bags into bank pertaining to item operation settings.", callback = "Sort:StartGbankPut" },
		{ key = "SortGuildBank", label = "Will sort your Guild bank based on item operation settings.", callback = "Sort:StartGbankSort" },
		{ key = "SortGuildBankTab", label = "Sort's the current tab into order", callback = "Sort:StartGuildBankTabSort" },
	}
	
	
	TSM.operations = 
	{
		maxOperations=11,
		callbackOptions="Options:Load",
		callbackInfo="GetOperationInfo"
	}
	
	TSM.moduleAPIs = {
		{key="GuildSorter", callback="Options:Load"},
	}
	
	TSMAPI:NewModule(TSM)
end

TSM.operationDefaults = {
	GBank = "<None>",
	GBankTab = 1,
	GBankBackupTab = 1,
	ignorePlayer = {},
	ignoreFactionrealm = {},
	relationships = {},
}

function TSM:GetOperationInfo(operationName)
	local operation = TSM.operations[operationName]
	if not operation then return end
	if operation.target == "" then return end
	
	return format("Group Sorting in guild %s for tab %d", operation.GBank, operation.GBankTab)
end


function TSM:GUILDBANKFRAME_CLOSED()
	TSMAPI:CancelFrame("RunSort")
	if TSM.SortGBankButton ~= nil then
		TSM.SortGBankButton:Enable()
		TSM.SortToGBankButton:Enable()
		TSM.SortTabsButton:Enable()
	end
	if TSM.SortGBankButtonBagnon ~= nil then
		TSM.SortGBankButtonBagnon:Enable()
		TSM.SortToGBankButtonBagnon:Enable()
	end
	TSM.AtBankStatus = false
end
