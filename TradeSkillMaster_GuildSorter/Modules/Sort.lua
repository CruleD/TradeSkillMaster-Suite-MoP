local TSM = select(2, ...)
local Sort = TSM:NewModule("Sort")
local Util = TSM:GetModule("Util")
local Moves = {} -- Bags To Bank etc
local moves = {} -- Guild Tab Sort
local current = nil -- Hold current item

TSM.AtBankStatus = false
TSM.SortBank = false

function TSM:GUILDBANKFRAME_OPENED()
--	if not TSM.SortToGBankButton or not TSM.SortGBankButton then
		if (Bagnon ~= nil and not TSM.SortGBankButtonBagnon and BagnonFrameguildbank ~= nil) then  -- Bagnon Handling
			--print("Bagnon detected")
			self.SortToGBankButtonBagnon = CreateFrame("Button","SortToGBankBagnon",BagnonFrameguildbank,"GameMenuButtonTemplate")
			self.SortToGBankButtonBagnon:SetPoint("BOTTOMRIGHT", -190, 5)
			self.SortToGBankButtonBagnon:SetWidth(110)
			self.SortToGBankButtonBagnon:SetText("Sort To Guild")
			self.SortToGBankButtonBagnon:SetScript("OnClick", function()
				self.SortToGBankButtonBagnon:Disable()
				Sort:StartGbankPut()
				end
			)
			
			self.SortGBankButtonBagnon = CreateFrame("Button","SortGBankBagnon", BagnonFrameguildbank,"GameMenuButtonTemplate")
			self.SortGBankButtonBagnon:SetPoint("BOTTOMRIGHT", -300, 5)
			self.SortGBankButtonBagnon:SetWidth(110)
			self.SortGBankButtonBagnon:SetText("Sort Guild")
			self.SortGBankButtonBagnon:SetScript("OnClick", function()
				self.SortGBankButtonBagnon:Disable()
				Sort:StartGbankSort()
				end
			)
--			print(" Bagnon")
		end
		if (not TSM.SortGBankButton and GuildBankFrame ~= nil) then  -- Default GBank Handling
			
			self.HideBackgroundFrame = CreateFrame("Button","SortGBank", GuildBankFrame,"GameMenuButtonTemplate")
			self.HideBackgroundFrame:SetPoint("TOPRIGHT", -180, -30)
			self.HideBackgroundFrame:SetWidth(120)
			self.HideBackgroundFrame:SetText("Show/Hide Button Frame")
			self.HideBackgroundFrame:SetScript("OnClick", function()
				if self.GbankSortBackground:IsShown() then
					self.GbankSortBackground:Hide()
				else
					self.GbankSortBackground:Show()
				end
				end
			)
			
			self.GbankSortBackground = CreateFrame("Frame","GBankSortBackground", GuildBankFrame)
			self.GbankSortBackground:SetWidth(300)
			self.GbankSortBackground:SetHeight(100)
			self.GbankSortBackground:SetPoint("BOTTOMRIGHT",0,-100)
			self.GbankSortBackground.tex = self.GbankSortBackground:CreateTexture()
			self.GbankSortBackground.tex:SetAllPoints(self.GbankSortBackground)
			self.GbankSortBackground.tex:SetTexture("Interface/DialogFrame/UI-DialogBox-Background")
			
			
			self.SortToGBankButton = CreateFrame("Button","SortToGBank", self.GbankSortBackground, "GameMenuButtonTemplate")
			self.SortToGBankButton:SetPoint("TOPLEFT", 0, 0)
			self.SortToGBankButton:SetWidth(110)
			self.SortToGBankButton:SetText("Sort To Guild")
			self.SortToGBankButton:SetScript("OnClick", function()
				self.SortToGBankButton:Disable()
				Sort:StartGbankPut()
				end
			)
			
			self.SortGBankButton = CreateFrame("Button","SortGBank", self.GbankSortBackground,"GameMenuButtonTemplate")
			self.SortGBankButton:SetPoint("TOPRIGHT", 0, 0)
			self.SortGBankButton:SetWidth(110)
			self.SortGBankButton:SetText("Sort Guild")
			self.SortGBankButton:SetScript("OnClick", function()
				self.SortGBankButton:Disable()
				Sort:StartGbankSort()
				end
			)
			
			self.SortTabsButton = CreateFrame("Button","SortTab", self.GbankSortBackground,"GameMenuButtonTemplate")
			self.SortTabsButton:SetPoint("RIGHT", 0, 0)
			self.SortTabsButton:SetWidth(110)
			self.SortTabsButton:SetText("Sort Current Tab")
			self.SortTabsButton:SetScript("OnClick", function()
				local ctrlDown  = IsControlKeyDown()
				self.SortTabsButton:Disable()
				Sort:StartGuildBankTabSort(ctrlDown)
				end
			)
--			print(" Vault")
		end
		TSM.AtBankStatus = true
--	end
end

local function getBagSlots()
	local t = {}
	for i = 1, NUM_BAG_SLOTS + 1 do
		t[i] = i - 1
	end
	return t
end

function Sort:StartGuildBankTabSort(ReverseSort)
	if TSM.AtBankStatus then
		local tab = GetCurrentGuildBankTab()
		local Tab = Sort:CreateTabItems(tab)
		Sort:SortTab(Tab,ReverseSort)
		TSM:Print("Starting")
		TSMAPI:CreateTimeDelay("RunSort",0.5,Sort.RunSortTab,1)
	else
		TSM:Print("Must be at guildbank")
	end
end

function Sort:StartGbankSort()
	if TSM.AtBankStatus then
		TSM.SortBank = true
		TSM:Print("Starting")
		Sort:GenerateMoves()
		TSMAPI:CreateTimeDelay("RunSort",0.5,Sort.RunSort,0.75)
	else
		TSM:Print("Must be at guildbank")
	end
end

function Sort:StartGbankPut()
	if TSM.AtBankStatus then
		TSM:Print("Starting")
		Sort:GenerateMoves()
		TSMAPI:CreateTimeDelay("RunSort",0.5,Sort.RunSort,0.4)
	else
		TSM:Print("Must be at guildbank")
	end
end

function Sort:GenerateMoves()
	if TSM.PlayerGuild == nil then
		TSM.PlayerGuild = select(1,GetGuildInfo("player"))
	end
	
	wipe(Moves)
	if TSM.SortBank == false then
		for i, bag in ipairs(getBagSlots()) do
			for slot = 1, GetContainerNumSlots(bag) do
				local Item = GetContainerItemID(bag,slot)
				local Guild,Tab,BackUpTab = Util:CheckTabAndGuild(Item)
				if Tab == nil or Guild == nil then
					--print("Nil"..bag..slot)
				else
					if TSM.PlayerGuild == Guild then
						tinsert(Moves,{Src = "bags", DestTab = Tab, DestBackUpTab = BackUpTab, SrcBag = bag, SrcSlot = slot})
					else
						TSM:Print(Guild.." not equal to "..TSM.PlayerGuild)
					end
				end
			end
		end
	else
		for i, bag in ipairs(getBagSlots()) do
			for slot = 1, GetContainerNumSlots(bag) do
				local Item = GetContainerItemID(bag,slot)
				local Guild,Tab,BackUpTab = Util:CheckTabAndGuild(Item)
				if Tab == nil or Guild == nil then
					--print("Nil"..bag..slot)
				else
					if TSM.PlayerGuild == Guild then
						tinsert(Moves,{Src = "bags", DestTab = Tab, DestBackUpTab = BackUpTab, SrcBag = bag, SrcSlot = slot})
					else
						TSM:Print(Guild.." not equal to "..TSM.PlayerGuild)
					end
				end
			end
		end
		for cTab=1,GetNumGuildBankTabs(),1  do
			for slot = 1, 98,1 do
				local Item = GetGuildBankItemLink(cTab,slot)
				local Guild,Tab,BackUpTab = Util:CheckTabAndGuild(Item)
				if Tab == nil or Guild == nil then
					--print("Nil"..bag..slot)
				elseif cTab == Tab or cTab == BackUpTab then
					-- nothing
				else
					if TSM.PlayerGuild == Guild then
						tinsert(Moves,{Src = "guildbank", SrcTab = cTab,  SrcSlot = slot, DestTab = Tab, DestBackUpTab = BackUpTab})
					else
						TSM:Print(Guild.." not equal to "..TSM.PlayerGuild)
					end
				end
			end
		end
	end
end

function Sort.RunSort()
	if #Moves > 0 then
		local i = next(Moves)
		local Src = Moves[i].Src
		
		if Src == "guildbank" then
			local DestTab = Moves[i].DestTab
			local SrcTab = Moves[i].SrcTab
			local SrcSlot = Moves[i].SrcSlot
			local DestBackupTab = Moves[i].DestBackUpTab
			--print(format("%d, %d, %d",SrcTab, SrcSlot, DestTab))
			if SrcTab ~= nil and SrcSlot ~= nil and DestTab ~= nil then
				SetCurrentGuildBankTab(SrcTab)
				AutoStoreGuildBankItem(SrcTab, SrcSlot)
			end
			tremove(Moves, i)
			Sort:GenerateMoves()
		
		elseif Src == "bags" then
			local SrcBag = Moves[i].SrcBag
			local SrcSlot = Moves[i].SrcSlot
			local DestTab = Moves[i].DestTab
			local DestBackupTab = Moves[i].DestBackUpTab
			--print(format("%d, %d, %d",SrcBag, SrcSlot, DestTab))
			if SrcBag ~= nil and SrcSlot ~= nil and DestTab ~= nil then
				SetCurrentGuildBankTab(DestTab)
				if Util:CheckTabForFreeSpace() == false then
					SetCurrentGuildBankTab(DestBackupTab)
				end
				UseContainerItem(SrcBag, SrcSlot)
			end
			tremove(Moves, i)
			Sort:GenerateMoves()
		end
		
	else
		TSMAPI:CancelFrame("RunSort")
		TSM:Print("Finished")
		TSM.SortBank = false
		TSM.SortGBankButton:Enable()
		TSM.SortToGBankButton:Enable()
	end
end

function Sort:CreateTabItems(tab)
	local items = 98
	local bag = {}

	for i=1, items, 1 do
		local item = {}

		local _, count = GetGuildBankItemInfo(tab, i)
		local link = GetGuildBankItemLink(tab, i)
		item.tab = tab
		item.slot = i
		item.name = "<EMPTY>"
		item.id = TSMAPI:GetItemID(link)
		if item.id ~= nil then
		    item.count = count
		    item.name, _, item.quality, _, _, item.class, item.subclass, _, item.type, _, item.price = GetItemInfo(item.id)
		end
		table.insert(bag, item)
	end		
	return bag;
end

function Sort:SortTab(Tab,ReverseSort)
	if ReverseSort == 1 then
		for i=#Tab,1,-1 do
			local lowest = i
			for j = 1, i - 1, 1 do
				if (Util:CompareItems(Tab[lowest],Tab[j]) == false) then
					lowest = j
				end
			end
			if i ~= lowest then
				-- store move
				local move = Util:CreateMove(Tab[lowest], Tab[i]);
				table.insert(moves, move);
		    
				-- swap items
				local tmp = Tab[i];
				Tab[i] = Tab[lowest];
				Tab[lowest] = tmp;
		    
				-- swap slots
				tmp = Tab[i].slot;
				Tab[i].slot = Tab[lowest].slot;
				Tab[lowest].slot = tmp;
				tmp = Tab[i].bag;
				Tab[i].bag = Tab[lowest].bag;
				Tab[lowest].bag = tmp;
				tmp = Tab[i].tab;
				Tab[i].tab = Tab[lowest].tab;
				Tab[lowest].tab = tmp;
			end
		end
	else
		for i=1,#Tab,1 do
			local lowest = i
			for j = #Tab, i + 1, -1 do
				if (Util:CompareItems(Tab[lowest],Tab[j]) == false) then
					lowest = j
				end
			end
			if i ~= lowest then
				-- store move
				local move = Util:CreateMove(Tab[lowest], Tab[i]);
				table.insert(moves, move);
		    
				-- swap items
				local tmp = Tab[i];
				Tab[i] = Tab[lowest];
				Tab[lowest] = tmp;
		    
				-- swap slots
				tmp = Tab[i].slot;
				Tab[i].slot = Tab[lowest].slot;
				Tab[lowest].slot = tmp;
				tmp = Tab[i].bag;
				Tab[i].bag = Tab[lowest].bag;
				Tab[lowest].bag = tmp;
				tmp = Tab[i].tab;
				Tab[i].tab = Tab[lowest].tab;
				Tab[lowest].tab = tmp;
			end
		end
	end
end

function Sort.RunSortTab()
	if #moves > 0 then
		if current ~= nil then    
			if CursorHasItem() then
				local type, id = GetCursorInfo();
				if current ~= nil and current.id == id then
					if current.sourcebag ~= nil then
						PickupContainerItem(current.targetbag, current.targetslot);

						local link = select(7, GetContainerItemInfo(current.targetbag, current.targetslot));
						if current.id ~= GetIDFromLink(link) then
							return;
						end
						
					end
				else
					moves = {};
					current = nil;
					return;
				end
			else
				if current.sourcebag ~= nil then
					local link = select(7, GetContainerItemInfo(current.targetbag, current.targetslot));
					if current.id ~= GetIDFromLink(link) then
						return;
					end
					current = nil;
				end
			end
		else      
			if #moves > 0 then
				current = table.remove(moves, 1);

				if current.sourcebag ~= nil then
					PickupContainerItem(current.sourcebag, current.sourceslot);
					if CursorHasItem() == false then
						return;
					end 
			    
					PickupContainerItem(current.targetbag, current.targetslot);
					local link = select(7, GetContainerItemInfo(current.targetbag, current.targetslot));
					if current.id == GetIDFromLink(link) then
						current = nil;
					else
						return;
					end
				else
					PickupGuildBankItem(current.sourcetab, current.sourceslot);    
					PickupGuildBankItem(current.targettab, current.targetslot);    
					if CursorHasItem() then
						PickupGuildBankItem(current.sourcetab, current.sourceslot);    
					end
					current = nil;
					return;
				end
			end
		end
	else
		TSM:Print("Finished")
		TSM.SortTabsButton:Enable()
		TSMAPI:CancelFrame("RunSort")
	end
end