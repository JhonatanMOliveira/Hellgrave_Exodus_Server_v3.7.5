local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GROUNDSHAKER)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_BLOCKSHIELD, true)
combat:setArea(createCombatArea(AREA_BEAM8))


function onGetFormulaValues(player, skill, attack, factor)
    local level = player:getLevel()
    local magiclevel = player:getMagicLevel()
    local min = (level / 5) + (skill + attack) * (magiclevel / 3) * 2
    local max = (level / 5) + (skill + attack) * (magiclevel / 3) * 2
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
spell:cooldown(5000)
spell:level(150)
spell:mana(450)
spell:needDirection(true)  -- Obrigatorio para beam: usa a direcao que o jogador esta olhando
spell:isSelfTarget(false)
spell:needTarget(false) 
spell:isPremium(false)
spell:register()