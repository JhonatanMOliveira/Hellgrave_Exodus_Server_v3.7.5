local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, 86) -- Efeito de projétil
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_BLOCKSHIELD, true)

-- Fórmula personalizada usando todos os parâmetros, incluindo magicLevel
function onGetFormulaValues(player, skill, attack, factor, magicLevel)
    local levelCalc = player:getLevel()
    local damageCalc = (skill + attack + factor) * magicLevel
    local min = levelCalc + damageCalc
    local max = levelCalc + damageCalc
    
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

-- Função para executar a magia com 3 hits
function onCastSpell(creature, variant)
    local target = creature:getTarget() -- Alvo do conjurador
    
    if isCreature(target) then
        -- Aplica o efeito 3 vezes com um intervalo
        for i = 1, 3 do
            addEvent(function()
                combat:execute(creature, variant)
            end, i * 500) -- 500ms de intervalo entre os hits
        end
    end
    
    return true
end

spell:name("Meteoro de Pegasus")
spell:words("meteoro de pegasus")
spell:group("attack")
spell:vocation("Bronze Leao Menor")
spell:id(44)  -- ID válido
spell:cooldown(2 * 1000)
spell:level(120)
spell:mana(360)
spell:isSelfTarget(false)  -- Evita que a magia ataque o próprio jogador
spell:needTarget(true)  -- Garante que a magia precisa de um alvo
spell:isPremium(true)
spell:register()
