local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 337)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_BLOCKSHIELD, true)

-- Fórmula personalizada usando todos os parâmetros, incluindo magicLevel
function onGetFormulaValues(player, skill, attack, factor, magicLevel)
    local levelCalc = player:getLevel() / 3
    local damageCalc = (skill + attack + factor) * magicLevel
    local min = levelCalc + damageCalc
    local max = levelCalc + damageCalc
    
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
    -- Verificar se a variante (variant) é válida e executa o combate corretamente
    if not variant then
        return false -- Se a variante não for válida, interrompe a execução.
    end
    return combat:execute(creature, variant)
end

spell:name("Po de Diamante")
spell:words("po de diamante")
spell:group("attack")
spell:vocation("Bronze Cisne")
spell:id(100)  -- ID válido
spell:cooldown(2 * 1000)
spell:level(1)
spell:mana(12)
spell:isSelfTarget(false)  -- Evita que a magia ataque o próprio jogador
spell:needTarget(true)  -- Garante que a magia precisa de um alvo
spell:isPremium(true)
spell:register()
