local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GROUNDSHAKER)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_BLOCKSHIELD, true)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))


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

spell:name("Furia")
spell:words("furia")
spell:group("attack")
spell:id(3)
spell:cooldown(2000)
spell:level(35)
spell:mana(80)
spell:isSelfTarget(false)  -- Evita que a magia ataque o próprio jogador
spell:needTarget(false) 
spell:isPremium(true)
spell:register()