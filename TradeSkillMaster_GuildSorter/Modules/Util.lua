local TSM = select(2, ...)
local Util = TSM:NewModule("Util")

function Util:CheckTabAndGuild(Item)
	local Guild, Tab, BackUpTab
	local ops = TSMAPI:GetItemOperation(TSMAPI:GetItemString(Item), "GuildSorter")
	
	if (ops) then
		for _, operationName in pairs(ops) do
		--	print(operationName, ops)
			TSMAPI:UpdateOperation("GuildSorter", operationName)
			Tab = TSM.operations[operationName].GBankTab
			BackUpTab = TSM.operations[operationName].GBankBackupTab
			Guild = TSM.operations[operationName].GBank
			--print(format("Guild: %s, Tab: %d",Guild,Tab))
			if Guild == TSM.PlayerGuild then
				return Guild, Tab, BackUpTab
			end
		end
	end
end

function Util:CheckTabForFreeSpace()
	local cTab = GetCurrentGuildBankTab()
	local Count = 0
	for Slot = 1, 98, 1 do
		local iCount = select(2,GetGuildBankItemInfo(cTab, Slot))
		if iCount > 0 then
			Count = Count + 1
		end
	end
	if Count >= 98 then
		return false
	end
end

function Util:CompareItems(lItem, rItem)
    if rItem.id == nil then
        return true;
    elseif lItem.id == nil then
        return false;
    elseif lItem.quality ~= rItem.quality then
        return (lItem.quality > rItem.quality);
    elseif lItem.class ~= rItem.class then
        return (lItem.class < rItem.class);
    elseif lItem.subclass ~= rItem.subclass then
        return (lItem.subclass < rItem.subclass);
    elseif lItem.name ~= rItem.name then
        return (lItem.name < rItem.name);
    elseif lItem.count ~= rItem.count then
        return (lItem.count >= rItem.count);
    else
        return true;
    end
end

function Util:CreateMove(source, target)
    local move = {};
    if source.id ~= nil then
        move.id = source.id;
        move.name = source.name;
        move.sourcebag = source.bag;
        move.sourcetab = source.tab;
        move.sourceslot = source.slot;
        move.targetbag = target.bag;
        move.targettab = target.tab;
        move.targetslot = target.slot;
    else
        move.id = target.id;
        move.name = target.name;
        move.sourcebag = target.bag;
        move.sourcetab = target.tab;
        move.sourceslot = target.slot;
        move.targetbag = source.bag;
        move.targettab = source.tab;
        move.targetslot = source.slot;
    end
    return move;    
end