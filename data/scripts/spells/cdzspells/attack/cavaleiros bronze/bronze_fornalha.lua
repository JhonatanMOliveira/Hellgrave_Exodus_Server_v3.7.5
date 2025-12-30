local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 354)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_BLOCKSHIELD, true)

-- Fórmula personalizada usando todos os parâmetros, incluindo magicLevel
function onGetFormulaValues(player, skill, attack, factor)
    local level = player:getLevel()
    local magiclevel = player:getMagicLevel()
    local min = (level / 5) + (magiclevel * 0.1) + (skill * attack * 0.01) * 4
    local max = (level / 5) + (magiclevel * 0.1) + (skill * attack * 0.02) * 4
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

spell:name("Onda Relampago")
spell:words("Onda Relampago")
spell:group("attack")
spell:vocation("Bronze Fornalha")
spell:id(13)  -- ID válido
spell:cooldown(1000)
spell:level(120)
spell:mana(400)
spell:isSelfTarget(false)  -- Evita que a magia ataque o próprio jogador
spell:needTarget(true)  -- Garante que a magia precisa de um alvo
spell:isPremium(true)
spell:register()
