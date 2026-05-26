local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 354)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_BLOCKSHIELD, true)

-- Fórmula personalizada dividida por 3 para cada disparo
function onGetFormulaValues(player, skill, attack, factor)
    local level = player:getLevel()
    local magiclevel = player:getMagicLevel()
    local min = ((level / 5) + (magiclevel * 0.1) + (skill * attack * 0.01) * 2) / 3
    local max = ((level / 5) + (magiclevel * 0.1) + (skill * attack * 0.02) * 2) / 3
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
    if not variant then
        return false
    end
    -- Executa 3 disparos com intervalo de 400ms entre cada um
    for i = 1, 3 do
        addEvent(function()
            combat:execute(creature, variant)
        end, (i - 1) * 400)
    end
    return true
end

spell:name("Onda Relampago Tripla")
spell:words("Onda Relampago Tripla")
spell:group("attack")
spell:vocation("Bronze Fornalha")
spell:id(14)  -- ID único
spell:cooldown(2000)  -- Cooldown maior devido a 3 disparos
spell:level(120)
spell:mana(360)  -- Mana maior
spell:isSelfTarget(false)
spell:needTarget(true)
spell:isPremium(true)
spell:register()