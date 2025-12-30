local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREATTACK)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_BLOCKSHIELD, true)

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

spell:name("Golpe Furacao")
spell:words("golpe furacao")
spell:group("attack")
spell:id(4)
spell:vocation("Aco Ceu")
spell:cooldown(1000)
spell:level(10)
spell:mana(35)
spell:isSelfTarget(false)  -- Evita que a magia ataque o próprio jogador
spell:needTarget(true) 
spell:isPremium(false)
spell:register()