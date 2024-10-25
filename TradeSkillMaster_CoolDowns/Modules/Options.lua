local TSM = select(2, ...)
local CraftIDToProfessionInfo = LibStub("CraftIDToProfessionInfo")
local Util = TSM:GetModule("Util")
local Options = TSM:NewModule("Options")
local AceGUI = LibStub("AceGUI-3.0")

TSM.PageParent = nil

function Options:Load(parent)
	TSM.PageParent = parent
	
	local TailoringChildren = {}
	local EnchantingChildren = {}
	local EngineeringChildren = {}
	local BlacksmithingChildren = {}
	local JewelCraftingChildren = {}
	local AlchemyChildren = {}
	local InscriptionChildren = {}
	local LeatherworkingChildren = {}
	local FailCheckChildren = {}
	
	local Checks = {
			{
			type = "InlineGroup",
			layout="flow",
			children =	{
				{
				type = "Button",
				text = "Add items to Queue",
				fullWidth = true,
				callback = function() Util:QueueItems() end,
				},
				{
				type = "Button",
				text = "Remove items from Queue",
				fullWidth = true,
				callback = function() Util:UnQueueItems() end,
				},
				{
				type = "Button",
				text = "Enable All",
				fullWidth = true,
				callback = function() Util:EnableAll() end,
				},
				{
				type = "Button",
				text = "Disable All",
				fullWidth = true,
				callback = function() Util:DisableAll() end,
				},
				{
				type = "CheckBox",
				value = TSM.db.factionrealm["AutoQueue"],
				label = "AutoQueue "..TSM.AutoQueue,
				tooltip = "Enable / Disable auto queue of professions when ever they are off CD",
				fullWidth = true,
				callback = function() TSM:AutoQueueStatus() end,
				},
			},
		},
		{
		type = "InlineGroup",
		layout="flow",
		title = "Enchanting",
		children =	EnchantingChildren,
		},
		{
		type = "InlineGroup",
		layout="flow",
		title = "Engineering",
		children =	EngineeringChildren,
		},
		{
		type = "InlineGroup",
		layout="flow",
		title = "Tailoring",
		children =	TailoringChildren,
		},
		{
		type = "InlineGroup",
		layout="flow",
		title = "Blacksmithing",
		children =	BlacksmithingChildren,
		},
		{
		type = "InlineGroup",
		layout="flow",
		title = "JewelCrafting",
		children =	JewelCraftingChildren,
		},{
		type = "InlineGroup",
		layout="flow",
		title = "Alchemy (All Share the same CD)",
		children =	AlchemyChildren,
		},
		{
		type = "InlineGroup",
		layout="flow",
		title = "Inscription",
		children =	InscriptionChildren,
		},
		{
		type = "InlineGroup",
		layout="flow",
		title = "Leatherworking",
		children =	LeatherworkingChildren,
		},
		{
		type = "InlineGroup",
		layout="flow",
		title = "",
		children = FailCheckChildren,
		},
	}

	TSM:LocalTime()

	for ID,Name in pairs(TSM.CraftCDs) do -- Loop through CD's and create check boxes
		if CraftIDToProfessionInfo:spellIDToProfession(ID) then
			if CraftIDToProfessionInfo:spellIDToProfession(ID) == "Tailoring" then
				local Check = Util:CreateCheck(Name,ID)
				tinsert(TailoringChildren, Check)
			elseif CraftIDToProfessionInfo:spellIDToProfession(ID) == "Enchanting" then
				local Check = Util:CreateCheck(Name,ID)
				tinsert(EnchantingChildren, Check)
			elseif CraftIDToProfessionInfo:spellIDToProfession(ID) == "Engineering" then
				local Check = Util:CreateCheck(Name,ID)
				tinsert(EngineeringChildren, Check)
			elseif CraftIDToProfessionInfo:spellIDToProfession(ID) == "Blacksmithing" then
				local Check = Util:CreateCheck(Name,ID)
				tinsert(BlacksmithingChildren, Check)
			elseif CraftIDToProfessionInfo:spellIDToProfession(ID) == "JewelCrafting" then
				local Check = Util:CreateCheck(Name,ID)
				tinsert(JewelCraftingChildren, Check)
			elseif CraftIDToProfessionInfo:spellIDToProfession(ID) == "Alchemy" then
				local Check = Util:CreateCheck(Name,ID)
				tinsert(AlchemyChildren, Check)
			elseif CraftIDToProfessionInfo:spellIDToProfession(ID) == "Inscription" then
				local Check = Util:CreateCheck(Name,ID)
				tinsert(InscriptionChildren, Check)
			elseif CraftIDToProfessionInfo:spellIDToProfession(ID) == "Leatherworking" then
				local Check = Util:CreateCheck(Name,ID)
				tinsert(LeatherworkingChildren, Check)
			else
				local Check = Util:CreateCheck(Name,ID)
				tinsert(FailCheckChildren, Check)
			end
		else
			local Check = Util:CreateCheck(Name,ID)
			tinsert(FailCheckChildren, Check)
		end
	end

		
	local page = {
		{
			type="ScrollFrame",
			layout="list",
			children=
			{
				{
				type = "InlineGroup",
				layout="flow",
				title="TradeSkillMaster CoolDowns Options",
				children = Checks,
			},
		},
	},
}
	
	TSMAPI:BuildPage(parent,page)
end