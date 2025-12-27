local autoloot = {
    talkaction = "!autoloot",
    storageBase = 80000,
    freeAccountLimit = 10,
    premiumAccountLimit = 20,
}

local autolootCache = {}

local function getPlayerLimit(player)
    return player:isPremium() and autoloot.premiumAccountLimit or autoloot.freeAccountLimit
end

local function getPlayerAutolootItems(player)
    local limits = getPlayerLimit(player)
    local guid = player:getGuid()
    local itemsCache = autolootCache[guid]
    if itemsCache then
        if #itemsCache > limits then
            local newChache = {unpack(itemsCache, 1, limits)}
            autolootCache[guid] = newChache
            return newChache
        end
        return itemsCache
    end

    local items = {}
    for i = 1, limits do
        local storedValue = player:getStorageValue(autoloot.storageBase + i)
        local itemType = ItemType(math.max(storedValue, 0))
        if itemType and itemType:getId() ~= 0 then
            items[#items + 1] = itemType:getId()
        end
    end

    autolootCache[guid] = items
    return items
end

local function setPlayerAutolootItems(player, newItems)
    autolootCache[player:getGuid()] = nil
    local items = {}
    local limit = getPlayerLimit(player)
    for i = limit, 1, -1 do
        local itemId = newItems[i]
        if itemId then
            player:setStorageValue(autoloot.storageBase + i, itemId)
            items[i] = itemId
        else
            player:setStorageValue(autoloot.storageBase + i, -1)
        end
    end
    autolootCache[player:getGuid()] = items
    return true
end


local function addPlayerAutolootItem(player, itemId)
    local items = getPlayerAutolootItems(player)
    for _, id in pairs(items) do
        if itemId == id then
            return false
        end
    end
    items[#items + 1] = itemId
    return setPlayerAutolootItems(player, items)
end

local function removePlayerAutolootItem(player, itemId)
    local items = getPlayerAutolootItems(player)
    local removed = false
    for i = #items, 1, -1 do
        if items[i] == itemId then
            table.remove(items, i)
            removed = true
        end
    end
    if removed then
        setPlayerAutolootItems(player, items)
    end
    return removed
end


local textEditRequests = {}

function onSay(player, words, param, type)
    local split = param:splitTrimmed(",")
    local action = split[1]
    if not action then
        player:showTextDialog(2160, string.format("Examples of use:\n%s add,gold coin\n%s remove,gold coin\n%s clear\n%s show\n%s edit\n\n~Available slots~\nfreeAccount: %d\npremiumAccount: %d\ncurrency to bank: %s", words, words, words, words, words, autoloot.freeAccountLimit, autoloot.premiumAccountLimit, autoloot.currencyToBank and "yes" or "no"), false)
        return false
    end

    if action == "clear" then
        if textEditRequests[player:getGuid()] then
            textEditRequests[player:getGuid()] = nil
            player:unregisterEvent("autolootEdit")
        end
        autolootCache[player:getGuid()] = nil
        setPlayerAutolootItems(player, {})
        player:sendCancelMessage("Autoloot list cleaned.")
        return false
    elseif action == "show" then
        if textEditRequests[player:getGuid()] then
            textEditRequests[player:getGuid()] = nil
            player:unregisterEvent("autolootEdit")
        end
        autolootCache[player:getGuid()] = nil
        local items = getPlayerAutolootItems(player)
        local description = {string.format('~ Your autoloot list, capacity: %d/%d ~\n', #items, getPlayerLimit(player))}
        for i, itemId in pairs(items) do
            description[#description + 1] = string.format("%d) %s", i, ItemType(itemId):getName())
        end
        player:showTextDialog(2160, table.concat(description, '\n'), false)
        return false
    elseif action == "edit" then
        autolootCache[player:getGuid()] = nil
        local items = getPlayerAutolootItems(player)
        local description = {}
        for i, itemId in pairs(items) do
            description[#description + 1] = ItemType(itemId):getName()
        end
        player:registerEvent("autolootEdit")
        player:showTextDialog(1948, string.format("To add articles you just have to write their IDs or names on each line\nfor example:\n\n%s", table.concat(description, '\n')), true, 666)
        textEditRequests[player:getGuid()] = true
        return false
    end

    local function getItemType()
        local itemType = ItemType(split[2])
        if not itemType or itemType:getId() == 0 then
            itemType = ItemType(math.max(tonumber(split[2]) or 0, 0))
            if not itemType or itemType:getId() == 0 then
                player:sendCancelMessage(string.format("The item %s does not exists!", split[2]))
                return false
            end
        end
        return itemType
    end

    if action == "add" then
        autolootCache[player:getGuid()] = nil
        if textEditRequests[player:getGuid()] then
            textEditRequests[player:getGuid()] = nil
            player:unregisterEvent("autolootEdit")
        end
        local itemType = getItemType()
        if itemType then
            local limits = getPlayerLimit(player)
            if #getPlayerAutolootItems(player) >= limits then
                player:sendCancelMessage(string.format("Your auto loot only allows you to add %d items.", limits))
                return false
            end

            if addPlayerAutolootItem(player, itemType:getId()) then
                autolootCache[player:getGuid()] = nil
                player:sendCancelMessage(string.format("Perfect you have added to the list: %s", itemType:getName()))
            else
                player:sendCancelMessage(string.format("The item %s already exists!", itemType:getName()))
            end
        end
        return false
    elseif action == "remove" then
        if textEditRequests[player:getGuid()] then
            textEditRequests[player:getGuid()] = nil
            player:unregisterEvent("autolootEdit")
        end
        autolootCache[player:getGuid()] = nil  -- Clear cache before removal
        local itemType = getItemType()
        if itemType then
            if removePlayerAutolootItem(player, itemType:getId()) then
                autolootCache[player:getGuid()] = nil  -- Clear again after removal
                player:sendCancelMessage(string.format("Perfect, you have removed from the list: %s", itemType:getName()))
            else
                player:sendCancelMessage(string.format("The item %s does not exist in the list.", itemType:getName()))
            end
        end
        return false
    end    

    return false
end