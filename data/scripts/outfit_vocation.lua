local outfitVoc = {
    -- lookType = { vocations permitidas }
    [128] = {1, 5}, -- Sorcerer / Master Sorcerer
    [129] = {2, 6}, -- Druid / Elder Druid
    [130] = {3, 7}, -- Paladin / Royal Paladin
    [131] = {4, 8}, -- Knight / Elite Knight
}

local outfitCallback = EventCallback

function outfitCallback.onChangeOutfit(player, outfit)
    local vocId = player:getVocation():getId()
    local allowed = outfitVoc[outfit.lookType]

    -- Outfit livre
    if not allowed then
        return true
    end

    -- Verifica vocação
    for _, v in ipairs(allowed) do
        if v == vocId then
            return true
        end
    end

    player:sendCancelMessage("Este outfit nao pertence a sua vocacao.")
    return false
end

outfitCallback:register()
