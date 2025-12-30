local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GROUNDSHAKER)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_BLOCKSHIELD, true)
combat:setArea(createCombatArea(AREA_BEAM8))


function onGetFormulaValues(player, skill, attack, factor)
    local level = player:getLevel()
    local magiclevel = player:getMagicLevel()
    local min = (level / 5) + (magiclevel * 0.1) + (skill * attack * 0.01) + 1
    local max = (level / 5) + (magiclevel * 0.1) + (skill * attack * 0.02) + 2
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Beam Bronze")
spell:words("beam bronze")
spell:group("attack")
spell:id(100)
spell:cooldown(40 * 1000)
spell:groupCooldown(4 * 1000)
spell:level(150)
spell:mana(520)
spell:needDirection(true)        -- ← AQUI: obriga o jogador a escolher uma direção
spell:isSelfTarget(false)  -- Evita que a magia ataque o próprio jogador
spell:needTarget(false) 
spell:isPremium(true)
spell:register()