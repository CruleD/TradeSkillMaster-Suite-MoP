local TSM = select(2, ...)
local Options = TSM:NewModule("Options")
local AceGUI = LibStub("AceGUI-3.0")

function Options:Load(parent, operation, group)
	Options.treeGroup = AceGUI:Create("TSMTreeGroup")
	Options.treeGroup:SetLayout("Fill")
	Options.treeGroup:SetCallback("OnGroupSelected", function(...) Options:SelectTree(...) end)
	Options.treeGroup:SetStatusTable(TSM.db.global.optionsTreeStatus)
	parent:AddChild(Options.treeGroup)

	Options:UpdateTree()
	if operation then
		if operation == "" then
			Options.currentGroup = group
			Options.treeGroup:SelectByPath(2)
			Options.currentGroup = nil
		else
			Options.treeGroup:SelectByPath(2, operation)
		end
	else
		Options.treeGroup:SelectByPath(1)
	end
end

function Options:UpdateTree()
	local operationTreeChildren = {}

	for name in pairs(TSM.operations) do
		tinsert(operationTreeChildren, { value = name, text = name })
	end
	
	sort(operationTreeChildren, function(a, b) return a.value < b.value end)

	Options.treeGroup:SetTree({ { value = 1, text = "Options" }, { value = 2, text = "Operations", children = operationTreeChildren } })
end

function Options:SelectTree(treeGroup, _, selection)
	treeGroup:ReleaseChildren()

	local major, minor = ("\001"):split(selection)
	major = tonumber(major)
	if major == 1 then
		Options:LoadGeneralSettings(treeGroup)
	elseif minor then
		Options:DrawOperationSettings(treeGroup, minor)
	else
		Options:DrawNewOperation(treeGroup)
	end
end

function Options:DrawNewOperation(container)
	local currentGroup = Options.currentGroup
	local page = {
		{
			-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = "New Operation",
					children = {
						{
							type = "Label",
							text = "Guild Sorter operations allow for quick and easy sorting of items in guild banks.",
							relativeWidth = 1,
						},
						{
							type = "EditBox",
							label = "Operation Name",
							relativeWidth = 0.8,
							callback = function(self, _, name)
								name = (name or ""):trim()
								if name == "" then return end
								if TSM.operations[name] then
									self:SetText("")
									return TSM:Printf("Error creating operation. Operation with name '%s' already exists.", name)
								end
								TSM.operations[name] = CopyTable(TSM.operationDefaults)
								Options:UpdateTree()
								Options.treeGroup:SelectByPath(2, name)
								TSMAPI:NewOperationCallback("GuildSorter", currentGroup, name)
							end,
							tooltip = "Give the new operation a name. A descriptive name will help you find this operation later.",
						},
					},
				},
			},
		},
	}
	TSMAPI:BuildPage(container, page)
end


function Options:DrawOperationSettings(container, operationName)
	local tg = AceGUI:Create("TSMTabGroup")
	tg:SetLayout("Fill")
	tg:SetFullHeight(true)
	tg:SetFullWidth(true)
	tg:SetTabs({{value=1, text="General"}, {value=2, text="Relationships"}, {value=3, text="Management"}})
	tg:SetCallback("OnGroupSelected", function(self,_,value)
			tg:ReleaseChildren()
			TSMAPI:UpdateOperation("GuildSorter", operationName)
			if value == 1 then
				Options:DrawOperationGeneral(self, operationName)
			elseif value == 2 then
				Options:DrawOperationRelationships(self, operationName)
			elseif value == 3 then
				TSMAPI:DrawOperationManagement(TSM, self, operationName)
			end
		end)
	container:AddChild(tg)
	tg:SelectTab(1)
end

function Options:DrawOperationGeneral(container, operationName)
	local operationSettings = TSM.operations[operationName]
	
	local GuildList = {}
	GuildList["<None>"] = "<None>"
	for Name in pairs(TSM.db.global["Guilds"]) do
		GuildList[Name] = Name
	end
	
	local page = {
		{
			-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = "Operation Settings",
					children = {
						{
							type = "Dropdown",
							label = "Guild:",
							value = operationSettings.GBank,
							list = GuildList,
							relativeWidth = 0.5,
							multiselect = false,
							disabled = false,
							callback = function(_,_,key) operationSettings.GBank = key end,
						},
						{
							type = "Dropdown",
							label = "Tab:",
							settingInfo = {operationSettings, "GBankTab"},
							list = {[1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6, [7] = 7, [8] = 8},
							relativeWidth = 0.5,
							multiselect = false,
							disabled = false,
						},
						{
							type = "Dropdown",
							label = "Backup Tab:",
							settingInfo = {operationSettings, "GBankBackupTab"},
							list = {[1] = 1, [2] = 2, [3] = 3, [4] = 4, [5] = 5, [6] = 6, [7] = 7, [8] = 8},
							relativeWidth = 0.5,
							multiselect = false,
							disabled = false,
						},
					},
				},
			},
		},
	}
	TSMAPI:BuildPage(container, page)
end

function Options:DrawOperationRelationships(container, operationName)
	local settingInfo = {
		{
			label = "General Settings",
		},
	}
	TSMAPI:ShowOperationRelationshipTab(TSM, container, TSM.operations[operationName], settingInfo)
end

function Options:LoadGeneralSettings(container)
	local page = {
		{
			-- scroll frame to contain everything
			type = "ScrollFrame",
			layout = "List",
			children = {
				{
					type = "InlineGroup",
					layout = "flow",
					title = "General Settings",
					relativeWidth = 1,
					children = {
						{
							type="Label",
							text = "No options available yet. More features to come.",
						},
					},
				},
			},
		},
	}

	TSMAPI:BuildPage(container, page)
end