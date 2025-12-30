local storeBox = Action()

-- Definição dos itens e suas chances respectivas
local REWARD = {
    {id = 29694, chance = 30}, -- 25% de chance Leao Menor
    {id = 29681, chance = 10}, -- 30% de chance Fornalha
    {id = 29701, chance = 35},  -- 10% de chance Lobo
	{id = 29722, chance = 25}  -- 35% de chance Unicornio
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

storeBox:id(29738)
storeBox:register()
