local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, 351)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_BLOCKSHIELD, true)
combat:setArea(createCombatArea(AREA_CIRCLE5X5))


function onGetFormulaValues(player, skill, attack, factor)
    local level = player:getLevel()
    local magiclevel = player:getMagicLevel()
    local min = (level / 5) + (skill + attack) * (magiclevel / 3)
    local max = (level / 5) + (skill + attack) * (magiclevel / 3)
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
spell:cooldown(2000)
spell:level(35)
spell:mana(105)
spell:isSelfTarget(false)  -- Evita que a magia ataque o próprio jogador
spell:needTarget(false) 
spell:isPremium(false)
spell:register()