local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_FIREATTACK)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_BLOCKSHIELD, true)

function onGetFormulaValues(player, skill, attack, factor)
    local level = player:getLevel()
    local magiclevel = player:getMagicLevel()
    local min = (level / 5) + (magiclevel * 0.1) + (skill * attack * 0.01) * 3
    local max = (level / 5) + (magiclevel * 0.1) + (skill * attack * 0.02) * 3
    return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end

spell:name("Golpe Serpente")
spell:words("golpe serpente")
spell:group("attack")
spell:vocation("Fantasma SerpentM")
spell:id(10)
spell:cooldown(1000)
spell:groupCooldown(1000)
spell:level(50)
spell:mana(110)
spell:isSelfTarget(false)  -- Evita que a magia ataque o próprio jogador
spell:needTarget(true) 
spell:isPremium(true)
spell:register()