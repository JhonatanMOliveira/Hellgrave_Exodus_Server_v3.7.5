local storeBox = Action()

-- Definição dos itens e suas chances respectivas
local REWARD = {
    {id = 29687, chance = 25}, -- 25% de chance Golfinho
    {id = 29729, chance = 30}, -- 30% de chance  Vampiro
    {id = 29708, chance = 10}, -- 10% de chance  Medusa
    {id = 29715, chance = 35}  -- 35% de chance  SerpentM
}

-- Função para sortear o item com base nas chances
local function getRandomItem()
    local totalChance = 0
    for _, reward in ipairs(REWARD) do
        totalChance = totalChance + reward.chance
    end

    local randomValue = math.random(1, totalChance)
    local cumulativeChance = 0

    for _, reward in ipairs(REWARD) do
        cumulativeChance = cumulativeChance + reward.chance
        if randomValue <= cumulativeChance then
            return reward.id
        end
    end
end

function storeBox.onUse(cid, item, fromPosition, itemEx, toPosition)
    -- Escolher item com base nas chances
    local rewardItem = getRandomItem()
    doPlayerAddItem(cid, rewardItem, 1)

    doSendMagicEffect(getPlayerPosition(cid), 73)
    doRemoveItem(item.uid, 1)
    return true
end

storeBox:id(29737)
storeBox:register()
