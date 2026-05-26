local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)

local condition = Condition(CONDITION_PACIFIED)
condition:setParameter(CONDITION_PARAM_TICKS, 5000)
combat:addCondition(condition)

function onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end
