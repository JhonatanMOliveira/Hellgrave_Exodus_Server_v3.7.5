local config = {
    itemids = {
        [1] = 29933, -- cabeça
        [4] = 29934, -- armor
        [7] = 29935, -- legs
        [8] = 29936  -- boots
    },
    storage = 29932, -- Storage para verificar se o jogador já usou
    urnaItemID = 29932, -- Substitua pelo ID da urna
    newVocationID = 12, -- Substitua pelo ID da nova vocação (no caso, 16)
    newOutfitLookType = 1441, -- Substitua pelo lookType do novo outfit (completo com 3 addons)
    originalVocationID = 11, -- Substitua pelo ID da vocação original (no caso, 12)
    originalOutfitLookType = 1440, -- Substitua pelo lookType do outfit original (no caso, 268)
	
	efeitoativado = 28, -- Efeito visual ao ativar
	efeitodesativado = 28, -- Efeito visual ao desativar
	
	vozativar = "Cavaleiro Zoológico: Voz que vira o Cavaleiro",
	vozdesativar = "Cavaleiro Zoológico: Voz que volta o Cavaleiro ao normal",
	
	mensagemAtivar = "Itens adicionados aos slots e alterações ativadas.",
	mensagemDesativar = "Itens removidos dos slots e alterações desativadas."
}

local ec = EventCallback

function ec.onMoveItem(player, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
    if item:getId() == config.urnaItemID and toPosition.x == CONTAINER_POSITION and toPosition.y == CONST_SLOT_LEFT then
        for slot, itemid in pairs(config.itemids) do
            local newItem = player:addItem(itemid, 1)
            if not newItem then
                return RETURNVALUE_NOTPOSSIBLE
            end
        end
        player:getPosition():sendMagicEffect(config.efeitoativado)
        player:say(config.vozativar, TALKTYPE_MONSTER_YELL)
    end
    return RETURNVALUE_NOERROR
end

ec:register(-777)

local function removeItemsFromSlots(player)
    for slot, _ in pairs(config.itemids) do
        local item = player:getSlotItem(slot)
        if item then
            player:removeItem(item:getId(), 1)
        end
    end
end

local urnaItemID = Action()

function urnaItemID.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == config.urnaItemID then
        local hasItems = false
        for slot, _ in pairs(config.itemids) do
            local slotItem = player:getSlotItem(slot)
            if slotItem then
                hasItems = true
                break
            end
        end

        if hasItems then
            removeItemsFromSlots(player)
            player:setVocation(config.originalVocationID)
            player:removeCondition(CONDITION_OUTFIT)
            player:addOutfitAddon(0, 3) -- Restaurar os addons da roupa original
            player:setOutfit({ lookType = config.originalOutfitLookType, addons = 0 }) -- Mudança permanente de roupa
            player:getPosition():sendMagicEffect(config.efeitodesativado)
            player:say(config.vozdesativar, TALKTYPE_MONSTER_YELL)
            player:sendTextMessage(MESSAGE_STATUS_DEFAULT, config.mensagemDesativar)
        else
            for slot, itemid in pairs(config.itemids) do
                local newItem = player:addItem(itemid, 1)
                if not newItem then
                    player:sendCancelMessage("Não foi possível adicionar os itens aos slots.")
                    return false
                end
            end
            player:setVocation(config.newVocationID)
            player:removeCondition(CONDITION_OUTFIT)
            player:setOutfit({ lookType = config.newOutfitLookType, addons = 3 }) -- Mudança permanente de roupa
            player:getPosition():sendMagicEffect(config.efeitoativado)
            player:say(config.vozativar, TALKTYPE_MONSTER_YELL)
            player:sendTextMessage(MESSAGE_STATUS_DEFAULT, config.mensagemAtivar)
        end
    end
    return true
end

urnaItemID:id(config.urnaItemID)
urnaItemID:register()