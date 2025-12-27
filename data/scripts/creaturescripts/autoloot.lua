local autoloot = {
    talkaction = "!autoloot",
    storageBase = 80000,
    freeAccountLimit = 10,
    premiumAccountLimit = 20,
}


local autolootCache = {}
local textEditRequests = {}

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
    local items = getPlayerAutolootItems(player)
    for i = getPlayerLimit(player), 1, -1 do
        local itemId = newItems[i]
        if itemId then
            player:setStorageValue(autoloot.storageBase + i, itemId)
            items[i] = itemId
        else
            player:setStorageValue(autoloot.storageBase + i, -1)
            table.remove(items, i)
        end
    end
    return true
end


local function hasPlayerAutolootItem(player, itemId)
    for _, id in pairs(getPlayerAutolootItems(player)) do
        if itemId == id then
            return true
        end
    end
    return false
end

local ec = EventCallback

local coinMultipliers = {
    [2148] = 1,
    [2152] = 100,
    [2160] = 1000,
    [28872] = 10000,
    [28873] = 100000
}

function ec.onDropLoot(monster, corpse)
    if not corpse:getType():isContainer() then
        return
    end

    local corpseOwner = Player(corpse:getCorpseOwner())
    if not corpseOwner then
        return
    end
    autolootCache[corpseOwner:getGuid()] = nil
    local items = corpse:getItems()
    for _, item in pairs(items) do
        local itemId = item:getId()
        if hasPlayerAutolootItem(corpseOwner, itemId) then
            if coinMultipliers[itemId] then
                local itemCount = item:getCount()
                item:remove()
                PlayerSetBalance(corpseOwner, getPlayerBalance(corpseOwner) + (itemCount * coinMultipliers[itemId]))
            else
                if not item:moveTo(corpseOwner) then
                    corpseOwner:sendTextMessage(MESSAGE_INFO_DESCR, "You don't have capacity.")
                    break
                end
            end
        end
    end
end


ec:register(3)


local creatureEvent = CreatureEvent("autolootCleanCache")

function creatureEvent.onLogout(player)
    setPlayerAutolootItems(player, getPlayerAutolootItems(player))
    autolootCache[player:getGuid()] = nil
    return true
end

creatureEvent:register()

creatureEvent = CreatureEvent("autolootEdit")

function creatureEvent.onTextEdit(player, item, text)
    player:unregisterEvent("autolootEdit")

    local split = text:splitTrimmed("\n")
    local items = {}
    for index, name in pairs(split) do
        repeat
            local itemType = ItemType(name)
            if not itemType or itemType:getId() == 0 then
                itemType = ItemType(tonumber(name))
                if not itemType or itemType:getId() == 0 then
                    break
                end
                break
            end

            items[#items + 1] = itemType:getId()
        until true
    end
    textEditRequests[player:getGuid()] = nil
    setPlayerAutolootItems(player, items)
    autolootCache[player:getGuid()] = nil
    player:sendTextMessage(MESSAGE_INFO_DESCR, "You have sucessfully set your autoloot items.")
    return true
end

creatureEvent:register()
