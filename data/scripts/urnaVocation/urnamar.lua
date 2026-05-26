local config = {
    itemids = {
        [1] = 29940, -- cabeça
        [4] = 29941, -- armor
        [7] = 29942, -- legs
        [8] = 29943  -- boots
    },
    storage = 29939, -- Storage para verificar se o jogador já usou
    urnaItemID = 29939, -- Substitua pelo ID da urna
    newVocationID = 13, -- Substitua pelo ID da nova vocação (no caso, 16)
    newOutfitLookType = 1442, -- Substitua pelo lookType do novo outfit (completo com 3 addons)
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

local function isActive(player)
    if player:getStorageValue(config.storage) == 1 then
        return true
    end

    for slot, itemid in pairs(config.itemids) do
        local slotItem = player:getSlotItem(slot)
        if slotItem and slotItem:getId() == itemid then
            return true
        end
    end

    return false
end

local function findStoredItem(player, itemid)
    local inbox = player:getInbox()
    if not inbox then
        return nil
    end

    for _, inboxItem in ipairs(inbox:getItems()) do
        if inboxItem:getId() == itemid then
            return inboxItem
        end
    end

    return nil
end

local function activateUrna(player)
    -- Verificar se algum slot alvo ja esta ocupado por outro item
    local ocupados = {}
    local slotNames = {
        [CONST_SLOT_HEAD] = "cabeca",
        [CONST_SLOT_ARMOR] = "corpo",
        [CONST_SLOT_LEGS] = "pernas",
        [CONST_SLOT_FEET] = "pes"
    }
    
    for slot, itemid in pairs(config.itemids) do
        local slotItem = player:getSlotItem(slot)
        if slotItem and slotItem:getId() ~= itemid then
            table.insert(ocupados, slotNames[slot] or "slot " .. slot)
        end
    end
    
    if #ocupados > 0 then
        local msg = "Você precisa remover os itens equipados nos seguintes slots: " .. table.concat(ocupados, ", ") .. "."
        player:sendTextMessage(MESSAGE_INFO_DESCR, msg)
        return false
    end

    for slot, itemid in pairs(config.itemids) do
        local slotItem = player:getSlotItem(slot)
        if not slotItem or slotItem:getId() ~= itemid then
            local storedItem = findStoredItem(player, itemid)
            if storedItem then
                if not storedItem:moveTo(player) then
                    player:sendTextMessage(MESSAGE_INFO_DESCR, "NNao foi possivel restaurar os itens da urna.")
                    return false
                end
            else
                local newItem = player:addItem(itemid, 1, true, slot)
                if not newItem then
                    player:sendTextMessage(MESSAGE_INFO_DESCR, "Nao foi possivel adicionar os itens aos slots.")
                    return false
                end
            end
        end
    end

    player:setStorageValue(config.storage, 1)
    player:setVocation(config.newVocationID)
    player:removeCondition(CONDITION_OUTFIT)
    player:setOutfit({ lookType = config.newOutfitLookType, addons = 3 })
    player:getPosition():sendMagicEffect(config.efeitoativado)
    player:say(config.vozativar, TALKTYPE_MONSTER_YELL)
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, config.mensagemAtivar)
    return true
end

local function deactivateUrna(player)
    local inbox = player:getInbox()
    if not inbox then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Nao foi possível acessar o depósito oculto.")
        return false
    end

    for slot, itemid in pairs(config.itemids) do
        local slotItem = player:getSlotItem(slot)
        if slotItem and slotItem:getId() == itemid then
            if not slotItem:moveTo(inbox) then
                player:sendTextMessage(MESSAGE_INFO_DESCR, "Nao foi possivel guardar os itens da urna.")
                return false
            end
        end
    end

    player:setStorageValue(config.storage, 0)
    player:setVocation(config.originalVocationID)
    player:removeCondition(CONDITION_OUTFIT)
    player:addOutfitAddon(0, 3)
    player:setOutfit({ lookType = config.originalOutfitLookType, addons = 0 })
    player:getPosition():sendMagicEffect(config.efeitodesativado)
    player:say(config.vozdesativar, TALKTYPE_MONSTER_YELL)
    player:sendTextMessage(MESSAGE_STATUS_DEFAULT, config.mensagemDesativar)
    return true
end

-- Callback para movimento de item desabilitado
-- function ec.onMoveItem(player, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
--     if item:getId() == config.urnaItemID and toPosition.x == CONTAINER_POSITION and toPosition.y == CONST_SLOT_LEFT then
--         if not isActive(player) then
--             if not activateUrna(player) then
--                 return RETURNVALUE_NOTPOSSIBLE
--             end
--         end
--     end

--     return RETURNVALUE_NOERROR
-- end

-- ec:register(-777)

local urnaItemID = Action()

function urnaItemID.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == config.urnaItemID then
        if isActive(player) then
            if not deactivateUrna(player) then
                return false
            end
        else
            if not activateUrna(player) then
                return false
            end
        end
        return true
    end
    return true
end

urnaItemID:id(config.urnaItemID)
urnaItemID:register()
