local itemFusionOpcode = 67

print(">> Item Fusion Loaded")

local clientToServerMapping = {
  -- ClientID = ServerID
  --- Item to Infuse Client ID = Item to Infuse Item ID (3 same items)
  [3079] = 2195, -- Boots of Haste
  [3281]  = 2393, -- Giant Sword
  [3296]  = 2408, -- Warlord Sword
  [27423]  = 30059, -- 1
  [27424]  = 30060, -- 1
  [27425]  = 30061, -- 1
  [27412]  = 30062, -- 2
  [27413]  = 30063, -- 2
  [27414]  = 30064, -- 2
  [27432]  = 30065, -- 3
  [27431]  = 30066, -- 3
  [27433]  = 30067, -- 3
  [27409]  = 30068, -- 4
  [27409]  = 30069, -- 4
  [27410]  = 30070, -- 4

  

}

local function convertClientToServer(clientId)
  return clientToServerMapping[clientId] or clientId
end

--- Not Used ATM, it's for the all rest of items, so example: Resources items and Rewards
local fusionRewardsDefault = {
  { id = 29623, chance = 50 },
}

local fusionInputV1Table = {
  30059, -- Arco 1
  30060, -- Escudo 1
  30061, -- Espada 1
}

local fusionInputV2Table = {
  30062, -- Arco 2
  30063, -- Escudo 2
  30064, -- Espada 2
}

local fusionInputV3Table = {
  30065, -- Arco 3
  30066, -- Escudo 3
  30067, -- Espada 3
}

local fusionInputV4Table = {
  30068, -- Arco 4
  30069, -- Escudo 4
  30070, -- Espada 4
}

local fusionRewardTables = {
  [1] = {
    { id = 29619, chance = 100 }, -- Upgrade Rune v1
  },
  [2] = {
    { id = 29620, chance = 100 }, -- Upgrade Rune v2
  },
  [3] = {
    { id = 29621, chance = 100 }, -- Upgrade Rune v3
  },
  [4] = {
    { id = 29622, chance = 100 }, -- Upgrade Rune v4
  },
}

local fusionInputTiers = {}

local function registerFusionTier(tier, itemList)
  for _, itemId in ipairs(itemList) do
    fusionInputTiers[itemId] = tier
  end
end

registerFusionTier(1, fusionInputV1Table)
registerFusionTier(2, fusionInputV2Table)
registerFusionTier(3, fusionInputV3Table)
registerFusionTier(4, fusionInputV4Table)


local function weightedRandom(tableData)
  local totalChance = 0
  for _, entry in ipairs(tableData) do
    totalChance = totalChance + entry.chance
  end
  local rand = math.random() * totalChance
  local cumulative = 0
  for _, entry in ipairs(tableData) do
    cumulative = cumulative + entry.chance
    if rand <= cumulative then
      return entry.id
    end
  end
  return nil
end

local function getFusionTier(itemId)
  return fusionInputTiers[itemId]
end

local itemFusionExtended = CreatureEvent("ItemFusionExtended")

function itemFusionExtended.onExtendedOpcode(player, opcode, buffer)

  if opcode ~= itemFusionOpcode then
    return false
  end

  local data = json.decode(buffer)
  if not data or type(data) ~= "table" then
    return false
  end

  if data.action == "clear_items" then
    return true
  elseif data.action == "added_item" then
    if not data.item then
      return true
    end
    local clientId = data.item.clientId
    local convertedServerId = convertClientToServer(clientId)
    return true  
  elseif data.action == "fuse" then
    if not data.items or #data.items < 3 then
      local response = {
        action = "invalid_item",
        message = "You need 3 identical items to fuse."
      }
      player:sendExtendedOpcode(itemFusionOpcode, json.encode(response))
      return true
    end
    local firstClientId = data.items[1].clientId
    local convertedFirstId = convertClientToServer(firstClientId)
    local allIdentical = true
    for i = 2, #data.items do
      if convertClientToServer(data.items[i].clientId) ~= convertedFirstId then
        allIdentical = false
        break
      end
    end

    if not allIdentical then
      local response = {
        action = "invalid_item",
        message = "All items must be identical to fuse."
      }
      player:sendExtendedOpcode(itemFusionOpcode, json.encode(response))
      return true
    end

    local outputId = nil
    local fusionTier = getFusionTier(convertedFirstId)

    if fusionTier then
      local rewardTable = fusionRewardTables[fusionTier]
      outputId = rewardTable and weightedRandom(rewardTable) or nil
    else
      outputId = weightedRandom(fusionRewardsDefault)
    end

    if not outputId then
      local response = {
        action = "invalid_item",
        message = "Fusion failed due to internal error."
      }
      player:sendExtendedOpcode(itemFusionOpcode, json.encode(response))
      return true
    end
 
    if player:removeItem(convertedFirstId, 3) then
      player:addItem(outputId, 1)
      local response = { action = "fused_success", outputId = outputId }
      player:sendExtendedOpcode(itemFusionOpcode, json.encode(response))
    else
      local response = {
        action = "invalid_item",
        message = "You do not have enough items."
      }
      player:sendExtendedOpcode(itemFusionOpcode, json.encode(response))
    end
    return true
  elseif data.action == "show" then
    return true
  end
  return true
end

itemFusionExtended:type("extendedopcode")
itemFusionExtended:register()

local LoginEvent = CreatureEvent("ItemFusionLogin")

function LoginEvent.onLogin(player)
  player:registerEvent("ItemFusionExtended")
  return true
end

LoginEvent:type("login")
LoginEvent:register()
