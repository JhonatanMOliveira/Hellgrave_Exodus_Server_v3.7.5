local skillUpgrader = Action()

-- ID do item que será usado (ex: uma "Sword Skill Stone")
local upgraderItemId = 29743  -- Mude para o ID desejado (ex: crystal coin para teste)

-- Lista de IDs de itens alvo (armas de espada que podem receber o upgrade)
local targetSwordIds = {
    29631,  -- Soldier Sword
    2391,  -- Broadsword
    2408,  -- Katana
    2413,  -- Templar Scytheblade
    7390,  -- Magic Sword
    -- Adicione mais IDs de espadas aqui
}

-- Quantidade de níveis de skill sword a adicionar (pode mudar)
local skillIncrease = 1

-- Efeito visual ao usar com sucesso
local successEffect = CONST_ME_MAGIC_GREEN

function skillUpgrader.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target or not target:isItem() then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Você precisa usar isso em uma arma.")
        return true
    end

    local targetId = target:getId()
    local isSword = false
    for _, id in ipairs(targetSwordIds) do
        if targetId == id then
            isSword = true
            break
        end
    end

    if not isSword then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Este item só pode ser usado em armas de espada específicas.")
        return true
    end

    -- Aumenta a skill de sword
    player:addSkillTries(SKILL_SWORD, player:getEffectiveSkillLevel(SKILL_SWORD) * skillIncrease * player:getSkillTriesPerLevel(SKILL_SWORD))

    -- Remove o item usado
    item:remove(1)

    -- Efeitos e mensagem
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Sua skill de sword aumentou em " .. skillIncrease .. " nível!")
    toPosition:sendMagicEffect(successEffect)

    return true
end

skillUpgrader:id(upgraderItemId)
skillUpgrader:register()