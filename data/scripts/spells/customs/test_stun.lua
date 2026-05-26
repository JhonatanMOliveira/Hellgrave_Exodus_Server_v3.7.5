local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_NONE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_POFF)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_STUN)
condition:setParameter(CONDITION_PARAM_TICKS, 5000)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Test Stun")
spell:words("stun test")
spell:level(1)
spell:magicLevel(1)
spell:mana(10)
spell:range(3)
spell:needTarget(true)
spell:needLearn(false)
spell:isAggressive(false)
spell:group("support")
spell:cooldown(3000)
spell:groupCooldown(3000)
spell:register()
