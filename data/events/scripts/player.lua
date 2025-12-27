function Player:onBrowseField(position)
	if hasEventCallback(EVENT_CALLBACK_ONBROWSEFIELD) then
		return EventCallback(EVENT_CALLBACK_ONBROWSEFIELD, self, position)
	end
	return true
end

function Player:onLook(thing, position, distance)
    local description = ""
    
    if hasEventCallback(EVENT_CALLBACK_ONLOOK) then
        local callbackResult = EventCallback(EVENT_CALLBACK_ONLOOK, self, thing, position, distance, description)
        
        if callbackResult then
            description = callbackResult
        end
    end
    
    if thing:isCreature() then
        if thing:isPlayer() then
            local rankTask = getRankTask(thing)
            if rankTask then
                description = string.format("%s\n Ancestral Rank: %s", description, rankTask)
            end
        end
    end
    
    self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInBattleList(creature, distance)
	local description = ""
	if hasEventCallback(EVENT_CALLBACK_ONLOOKINBATTLELIST) then
		description = EventCallback(EVENT_CALLBACK_ONLOOKINBATTLELIST, self, creature, distance, description)
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInTrade(partner, item, distance)
	local description = "You see " .. item:getDescription(distance)
	if hasEventCallback(EVENT_CALLBACK_ONLOOKINTRADE) then
		description = EventCallback(EVENT_CALLBACK_ONLOOKINTRADE, self, partner, item, distance, description)
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

function Player:onLookInShop(itemType, count, description)
	local description = "You see " .. description
	if hasEventCallback(EVENT_CALLBACK_ONLOOKINSHOP) then
		description = EventCallback(EVENT_CALLBACK_ONLOOKINSHOP, self, itemType, count, description)
	end
	self:sendTextMessage(MESSAGE_INFO_DESCR, description)
end

local PAD_AID = 46201
local PAD_SINGLE = { [1387] = true }
local PAD_FIRST, PAD_LAST = 29629, 29641

local function isPadId(id)
  if PAD_SINGLE[id] then
    return true
  end
  if id >= PAD_FIRST and id <= PAD_LAST then
    return true
  end
  return false
end

local function isPadItem(it)
  return it and it:isItem() and isPadId(it:getId()) and it:getActionId() == PAD_AID
end

local function tileHasPad(tile)
  if not tile then return false end

  local g = tile:getGround()
  if isPadItem(g) then
    return true
  end

  if tile.getItems then
    for _, it in ipairs(tile:getItems()) do
      if isPadItem(it) then
        return true
      end
    end
  else
    local n = tile:getThingCount()
    for i = 0, n - 1 do
      local th = tile:getThing(i)
      if isPadItem(th) then
        return true
      end
    end
  end

  return false
end

function Player:onMoveItem(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	local BLOCK_CARDS_AID = 37866
    if item:getActionId() == BLOCK_CARDS_AID then
        self:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot move an activated card, first deactivate it.")
        return RETURNVALUE_NOTENOUGHROOM
    end
	-- Make items disappear when dropped on sea tiles
	local restrictedTiles = {27725, 27728, 27729, 27730, 27731}
	if toPosition and toPosition.x > 0 and toPosition.y > 0 and toPosition.z >= 0 then
		local tile = Tile(toPosition)
		if tile then
			local ground = tile:getGround()
			if ground and isInArray(restrictedTiles, ground:getId()) then
				toPosition:sendMagicEffect(2) -- Optional visual
				item:remove()
				return RETURNVALUE_NOERROR
			end
		end
	end

	if toPosition.x ~= CONTAINER_POSITION then
		local tile = (toCylinder and toCylinder.isTile and toCylinder:isTile()) and toCylinder or Tile(toPosition)
		if tile and tileHasPad(tile) then
		self:sendCancelMessage("You cannot drop items on a portal.")
		toPosition:sendMagicEffect(CONST_ME_POFF)
		return RETURNVALUE_NOTPOSSIBLE
		end
	end

	-- -- Restrict Gloves onEquip
	-- local restrictedGloves = {29577, 29582, 29583, 29584, 29586, 29587, 29588, 29589, 29590 }
	-- local storageKeyGloves = 249571
	-- local storageKeyEquippedGloves = 249572
	-- local CONST_SLOT_BELT = CONST_SLOT_BELT or 15
    -- local CONST_SLOT_GLOVES = CONST_SLOT_GLOVES or 16
	-- local itemId = item:getId()
	-- if table.contains(restrictedGloves, itemId) then
    --     if toPosition.y == CONST_SLOT_BELT or toPosition.y == CONST_SLOT_GLOVES then
    --         if self:getStorageValue(storageKeyGloves) == 1 then
    --             if self:getStorageValue(storageKeyEquippedGloves) ~= itemId then
    --                 self:sendTextMessage(MESSAGE_INFO_DESCR, "You can only equip one glove at time.")
    --                 return RETURNVALUE_NOTENOUGHROOM
    --             end
    --             local slots = {CONST_SLOT_BELT, CONST_SLOT_GLOVES}
    --             for _, slot in ipairs(slots) do
    --                 local equippedItem = self:getSlotItem(slot)
    --                 if equippedItem and equippedItem:getId() == itemId then
    --                     self:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot equip the same item twice.")
    --                     return RETURNVALUE_NOTENOUGHROOM
    --                 end
    --             end
    --         end
    --         self:setStorageValue(storageKeyGloves, 1)
    --         self:setStorageValue(storageKeyEquippedGloves, itemId)
    --         return RETURNVALUE_NOERROR
    --     end
    --     if fromPosition.y == CONST_SLOT_BELT or fromPosition.y == CONST_SLOT_GLOVES then
    --         if self:getStorageValue(storageKeyEquippedGloves) == itemId then
    --             self:setStorageValue(storageKeyGloves, 0)
    --             self:setStorageValue(storageKeyEquippedGloves, -1)
    --         end
    --         return RETURNVALUE_NOERROR
    --     end
    -- end
	-- -- Restrict Belts onEquip
	-- local restrictedBelts = {29578, 29591, 29592, 29593, 29594, 29595, 29596, 29597, 29598}
	-- local storageKeyBelt = 249573
	-- local storageKeyEquippedBelt = 249574
	-- local CONST_SLOT_BELT = CONST_SLOT_BELT or 15
    -- local CONST_SLOT_GLOVES = CONST_SLOT_GLOVES or 16
	-- local itemId = item:getId()
	-- if table.contains(restrictedBelts, itemId) then
    --     if toPosition.y == CONST_SLOT_BELT or toPosition.y == CONST_SLOT_GLOVES then
    --         if self:getStorageValue(storageKeyBelt) == 1 then
    --             if self:getStorageValue(storageKeyEquippedBelt) ~= itemId then
    --                 self:sendTextMessage(MESSAGE_INFO_DESCR, "You can only equip one belt at time.")
    --                 return RETURNVALUE_NOTENOUGHROOM
    --             end
    --             local slots = {CONST_SLOT_BELT, CONST_SLOT_GLOVES}
    --             for _, slot in ipairs(slots) do
    --                 local equippedItem = self:getSlotItem(slot)
    --                 if equippedItem and equippedItem:getId() == itemId then
    --                     self:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot equip the same item twice.")
    --                     return RETURNVALUE_NOTENOUGHROOM
    --                 end
    --             end
    --         end
    --         self:setStorageValue(storageKeyBelt, 1)
    --         self:setStorageValue(storageKeyEquippedBelt, itemId)
    --         return RETURNVALUE_NOERROR
    --     end
    --     if fromPosition.y == CONST_SLOT_BELT or fromPosition.y == CONST_SLOT_GLOVES then
    --         if self:getStorageValue(storageKeyEquippedBelt) == itemId then
    --             self:setStorageValue(storageKeyBelt, 0)
    --             self:setStorageValue(storageKeyEquippedBelt, -1)
    --         end
    --         return RETURNVALUE_NOERROR
    --     end
    -- end
	-- -- Restrict Decks onEquip
	-- local restrictedDeck = {27632, 27633, 27634}
	-- local storageKeyDeck = 249575
	-- local storageKeyEquippedDeck = 249576
	-- local CONST_SLOT_DECK = CONST_SLOT_DECK or 12
    -- local CONST_SLOT_BADGE = CONST_SLOT_BADGE or 13
	-- local itemId = item:getId()
	-- if table.contains(restrictedDeck, itemId) then
    --     if toPosition.y == CONST_SLOT_DECK or toPosition.y == CONST_SLOT_BADGE then
    --         if self:getStorageValue(storageKeyDeck) == 1 then
    --             if self:getStorageValue(storageKeyEquippedDeck) ~= itemId then
    --                 self:sendTextMessage(MESSAGE_INFO_DESCR, "You can only equip one deck at time.")
    --                 return RETURNVALUE_NOTENOUGHROOM
    --             end
    --             local slots = {CONST_SLOT_DECK, CONST_SLOT_BADGE}
    --             for _, slot in ipairs(slots) do
    --                 local equippedItem = self:getSlotItem(slot)
    --                 if equippedItem and equippedItem:getId() == itemId then
    --                     self:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot equip the same item twice.")
    --                     return RETURNVALUE_NOTENOUGHROOM
    --                 end
    --             end
    --         end
    --         self:setStorageValue(storageKeyDeck, 1)
    --         self:setStorageValue(storageKeyEquippedDeck, itemId)
    --         return RETURNVALUE_NOERROR
    --     end
    --     if fromPosition.y == CONST_SLOT_DECK or fromPosition.y == CONST_SLOT_BADGE then
    --         if self:getStorageValue(storageKeyEquippedDeck) == itemId then
    --             self:setStorageValue(storageKeyDeck, 0)
    --             self:setStorageValue(storageKeyEquippedDeck, -1)
    --         end
    --         return RETURNVALUE_NOERROR
    --     end
    -- end
	-- -- Restrict Badges onEquip
	-- local restrictedBadge = {27803, 27804, 27805, 27806, 27807, 27808, 27809, 27810, 27811, 27812, 27813, 27814, 27815, 27816, 27817, 27818, 27819, 27820, 27821, 27822, 27823, 27824, 27825, 27826, 27827, 27828, 27829, 27830, 27831, 27832, 27833, 27834, 27835, 27836, 27837, 27838, 27839, 27840, 27841, 27842}
	-- local storageKeyBadge = 249577
	-- local storageKeyEquippedBadge = 249578
	-- local CONST_SLOT_DECK = CONST_SLOT_DECK or 12
    -- local CONST_SLOT_BADGE = CONST_SLOT_BADGE or 13
	-- local itemId = item:getId()
	-- if table.contains(restrictedBadge, itemId) then
    --     if toPosition.y == CONST_SLOT_DECK or toPosition.y == CONST_SLOT_BADGE then
    --         if self:getStorageValue(storageKeyBadge) == 1 then
    --             if self:getStorageValue(storageKeyEquippedBadge) ~= itemId then
    --                 self:sendTextMessage(MESSAGE_INFO_DESCR, "You can only equip one badge at time.")
    --                 return RETURNVALUE_NOTENOUGHROOM
    --             end
    --             local slots = {CONST_SLOT_DECK, CONST_SLOT_BADGE}
    --             for _, slot in ipairs(slots) do
    --                 local equippedItem = self:getSlotItem(slot)
    --                 if equippedItem and equippedItem:getId() == itemId then
    --                     self:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot equip the same item twice.")
    --                     return RETURNVALUE_NOTENOUGHROOM
    --                 end
    --             end
    --         end
    --         self:setStorageValue(storageKeyBadge, 1)
    --         self:setStorageValue(storageKeyEquippedBadge, itemId)
    --         return RETURNVALUE_NOERROR
    --     end
    --     if fromPosition.y == CONST_SLOT_DECK or fromPosition.y == CONST_SLOT_BADGE then
    --         if self:getStorageValue(storageKeyEquippedBadge) == itemId then
    --             self:setStorageValue(storageKeyBadge, 0)
    --             self:setStorageValue(storageKeyEquippedBadge, -1)
    --         end
    --         return RETURNVALUE_NOERROR
    --     end
    -- end
	
	-- Restrict player de equip boat if navigating
	local restrictedTiles = {27725, 27728, 27729, 27730, 27731}
    local CONST_SLOT_SHIP = CONST_SLOT_SHIP or 14

	if self:getStorageValue(109017) == 1 then
		-- Only block if player is trying to unequip something from the SHIP slot
		if fromPosition.y == CONST_SLOT_SHIP and toPosition.x > 0 and toPosition.y > 0 and toPosition.z >= 0 then
			local playerTile = self:getPosition():getTile()
			if playerTile then
				local ground = playerTile:getGround()
				if ground and isInArray(restrictedTiles, ground:getId()) then
					self:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot deequip the boat while navigating.")
					return RETURNVALUE_NOTENOUGHROOM
				end
			end
		end
	end

    if hasEventCallback(EVENT_CALLBACK_ONMOVEITEM) then
        return EventCallback(EVENT_CALLBACK_ONMOVEITEM, self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
    end
	return RETURNVALUE_NOERROR
end

function Player:onItemMoved(item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	if hasEventCallback(EVENT_CALLBACK_ONITEMMOVED) then
		EventCallback(EVENT_CALLBACK_ONITEMMOVED, self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
	end
end

function Player:onMoveCreature(creature, fromPosition, toPosition)
	if hasEventCallback(EVENT_CALLBACK_ONMOVECREATURE) then
		return EventCallback(EVENT_CALLBACK_ONMOVECREATURE, self, creature, fromPosition, toPosition)
	end
	local blockedActionIds = {31768}
	if table.contains(blockedActionIds, fromPosition:getTile():getGround():getActionId()) then
		return false
	end
	return true
end

function Player:onReportRuleViolation(targetName, reportType, reportReason, comment, translation)
	if hasEventCallback(EVENT_CALLBACK_ONREPORTRULEVIOLATION) then
		EventCallback(EVENT_CALLBACK_ONREPORTRULEVIOLATION, self, targetName, reportType, reportReason, comment, translation)
	end
end

function Player:onReportBug(message, position, category)
	if hasEventCallback(EVENT_CALLBACK_ONREPORTBUG) then
		return EventCallback(EVENT_CALLBACK_ONREPORTBUG, self, message, position, category)
	end
	return true
end

function Player:onTurn(direction)
	if hasEventCallback(EVENT_CALLBACK_ONTURN) then
		return EventCallback(EVENT_CALLBACK_ONTURN, self, direction)
	end
	return true
end

function Player:onTradeRequest(target, item)
	local BLOCK_CARDS_AID = 37866
    if item:getActionId() == BLOCK_CARDS_AID then
        self:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot trade an activated card, first deactivate it.")
        return RETURNVALUE_NOTENOUGHROOM
    end
	if hasEventCallback(EVENT_CALLBACK_ONTRADEREQUEST) then
		return EventCallback(EVENT_CALLBACK_ONTRADEREQUEST, self, target, item)
	end
	return true
end

function Player:onTradeAccept(target, item, targetItem)
	if hasEventCallback(EVENT_CALLBACK_ONTRADEACCEPT) then
		return EventCallback(EVENT_CALLBACK_ONTRADEACCEPT, self, target, item, targetItem)
	end
	return true
end

function Player:onTradeCompleted(target, item, targetItem, isSuccess)
	if hasEventCallback(EVENT_CALLBACK_ONTRADECOMPLETED) then
		EventCallback(EVENT_CALLBACK_ONTRADECOMPLETED, self, target, item, targetItem, isSuccess)
	end
end

local soulCondition = Condition(CONDITION_SOUL, CONDITIONID_DEFAULT)
soulCondition:setTicks(4 * 60 * 1000)
soulCondition:setParameter(CONDITION_PARAM_SOULGAIN, 1)

local function useStamina(player)
	local staminaMinutes = player:getStamina()
	if staminaMinutes == 0 then
		return
	end

	local playerId = player:getId()
	if not nextUseStaminaTime[playerId] then
		nextUseStaminaTime[playerId] = 0
	end

	local currentTime = os.time()
	local timePassed = currentTime - nextUseStaminaTime[playerId]
	if timePassed <= 0 then
		return
	end

	if timePassed > 60 then
		if staminaMinutes > 2 then
			staminaMinutes = staminaMinutes - 2
		else
			staminaMinutes = 0
		end
		nextUseStaminaTime[playerId] = currentTime + 120
	else
		staminaMinutes = staminaMinutes - 1
		nextUseStaminaTime[playerId] = currentTime + 60
	end
	player:setStamina(staminaMinutes)
end

local pet_storage_experience = 633451
local pet_storage_level = 633452
local pet_id = 633453

function Player:getPet()
    local petId = self:getStorageValue(pet_id)
    if petId > 0 then
        return Creature(petId)
    end
    return nil
end

local monsterExpBoosts = {
    ["bloated man-maggot"] = 876547,
    ["converter"] = 876548,
    ["darklight construct"] = 876549,
	["darklight emitter"] = 876550,
	["darklight matter"] = 876551,
	["darklight source"] = 876552,
	["darklight striker"] = 876553,
	["meandering mushroom"] = 876554,
	["mycobiontic beetle"] = 876555,
	["oozing carcass"] = 876556,
	["oozing corpus"] = 876557,
	["elder bloodjaw"] = 876558,
	["rotten man-maggot"] = 876559,
	["sopping carcass"] = 876560,
	["sopping corpus"] = 876561,
	["walking pillar"] = 876562,
	["wandering pillar"] = 876563,
	["bony sea devil"] = 876564,
	["brachiodemon"] = 876565,
	["branchy crawler"] = 876566,
	["capricious phantom"] = 876567,
	["cloak of terror"] = 876568,
	["courage leech"] = 876569,
	["distorted phantom"] = 876570,
	["druid's apparition"] = 876571,
	["hazardous phantom"] = 876572,
	["infernal demon"] = 876573,
	["infernal phantom"] = 876574,
	["knight's apparition"] = 876575,
	["many faces"] = 876576,
	["mould phantom"] = 876577,
	["paladin's apparition"] = 876578,
	["rotten golem"] = 876579,
	["sorcerer's apparition"] = 876580,
	["turbulent elemental"] = 876581,
	["vibrant phantom"] = 876582
}

function Player:onGainExperience(source, exp, rawExp)
	if not source or source:isPlayer() then
		return exp
	end
	local sourceName = source:getName():lower()
    local storageValue = monsterExpBoosts[sourceName]
    if storageValue then
        if self:getStorageValue(storageValue) >= 1 then
            exp = exp * 1.03 -- Gives 3% EXP Boost Permanent to the monster - 1.00 = Normal, 1.03 = 3%, 2.00 = 100% Plus
        end
    end
	if source:isMonster() then
        local bonusExperience = source:getMonsterLevel() * 0.03
        if source:getMonsterLevel() > 0 and bonusExperience > 1 then
            exp = exp * bonusExperience
        end
    end
	-- Soul regeneration
	local vocation = self:getVocation()
	if self:getSoul() < vocation:getMaxSoul() and exp >= self:getLevel() then
		soulCondition:setParameter(CONDITION_PARAM_SOULTICKS, vocation:getSoulGainTicks() * 1000)
		self:addCondition(soulCondition)
	end

	-- Apply experience stage multiplier
	exp = exp * Game.getExperienceStage(self:getLevel())

	-- Stamina modifier
	if configManager.getBoolean(configKeys.STAMINA_SYSTEM) then
		useStamina(self)
		local staminaMinutes = self:getStamina()
		if staminaMinutes > 2400 and self:isPremium() then
			exp = exp * 1.5
		elseif staminaMinutes <= 840 then
			exp = exp * 0.5
		end
	end
	if self:getStorageValue(6000) >= os.time() then
        exp = exp * 2.00
    end

	local pet = self:getPet()
    if not pet then
        return exp
    end
    local petId = self:getStorageValue(pet_id)

    if petId <= 0 then
        return exp
    end

    local pet_experience = pet:getStorageValue(pet_storage_experience)
    local pet_level = pet:getStorageValue(pet_storage_level)
    local petNextLevelExperience = calculateNextLevelExperience(pet_level)
    local petExp = exp * 0.2 

    pet_experience = pet_experience + petExp

    while pet_experience >= petNextLevelExperience do
        pet_level = pet_level + 1
        pet_experience = pet_experience - petNextLevelExperience
        petNextLevelExperience = calculateNextLevelExperience(pet_level)

        if pet_level == 50 then
            self:setStorageValue(688110, 1)
        elseif pet_level == 100 then
            self:setStorageValue(688111, 1)
        elseif pet_level == 150 then
            self:setStorageValue(688112, 1)
        elseif pet_level == 200 then
            self:setStorageValue(688113, 1)
        elseif pet_level == 250 then
            self:setStorageValue(688114, 1)
        elseif pet_level == 300 then
            self:setStorageValue(688115, 1)
        end
    end

    pet:setStorageValue(pet_storage_experience, pet_experience)
    pet:setStorageValue(pet_storage_level, pet_level)

    db.query("UPDATE `players` SET `pet_experience` = " .. pet_experience .. ", `pet_level` = " .. pet_level .. " WHERE `id` = " .. self:getGuid())

    return exp
end


function Player:onLoseExperience(exp)
	return hasEventCallback(EVENT_CALLBACK_ONLOSEEXPERIENCE) and EventCallback(EVENT_CALLBACK_ONLOSEEXPERIENCE, self, exp) or exp
end

function Player:onGainSkillTries(skill, tries)
	if APPLY_SKILL_MULTIPLIER == false then
		return hasEventCallback(EVENT_CALLBACK_ONGAINSKILLTRIES) and EventCallback(EVENT_CALLBACK_ONGAINSKILLTRIES, self, skill, tries) or tries
	end

	if skill == SKILL_MAGLEVEL then
		tries = tries * configManager.getNumber(configKeys.RATE_MAGIC)
		return hasEventCallback(EVENT_CALLBACK_ONGAINSKILLTRIES) and EventCallback(EVENT_CALLBACK_ONGAINSKILLTRIES, self, skill, tries) or tries
	end
	tries = tries * configManager.getNumber(configKeys.RATE_SKILL)
	return hasEventCallback(EVENT_CALLBACK_ONGAINSKILLTRIES) and EventCallback(EVENT_CALLBACK_ONGAINSKILLTRIES, self, skill, tries) or tries
end

function Player:onWrapItem(item)
	local topCylinder = item:getTopParent()
	if not topCylinder then return end

	local tile = Tile(topCylinder:getPosition())
	if not tile then return end

	local house = tile:getHouse()
	if not house then
		self:sendTextMessage(MESSAGE_INFO_DESCR,"You can only wrap and unwrap this item inside a house.")
		return
	end

	if house:getOwnerGuid() ~= self:getGuid() and not string.find(house:getAccessList(SUBOWNER_LIST):lower(), "%f[%a]" .. self:getName():lower() .. "%f[%A]") then
		self:sendTextMessage(MESSAGE_INFO_DESCR,"You cannot wrap or unwrap items from a house, which you are only guest to.")
		return
	end

	local wrapId = item:getAttribute("wrapid")
	if not wrapId or wrapId == 0 then
		wrapId = ItemType(item:getId()).wrapId
	end
	if wrapId and wrapId > 0 then
		if item:isContainer() and item:getSize() > 0 then
			self:sendTextMessage(MESSAGE_INFO_DESCR, "You must empty the container before wrapping it.")
			return
		end
		if not hasEventCallback(EVENT_CALLBACK_ONWRAPITEM) or EventCallback(EVENT_CALLBACK_ONWRAPITEM, self, item) then
			local oldId = item:getId()
			item:remove(1)
			local newItem = tile:addItem(wrapId)
			if newItem then
				newItem:setAttribute("unwrapid", oldId)
				newItem:setActionId(0)
			end
		end
		return
	end
	local unwrapId = item:getAttribute("unwrapid")
	if not unwrapId or unwrapId == 0 then
		unwrapId = ItemType(item:getId()).unwrapId
	end
	if unwrapId and unwrapId > 0 then
		if not hasEventCallback(EVENT_CALLBACK_ONWRAPITEM) or EventCallback(EVENT_CALLBACK_ONWRAPITEM, self, item) then
			local oldId = item:getId()
			item:remove(1)
			local newItem = tile:addItem(unwrapId)
			if newItem then
				newItem:setAttribute("wrapid", oldId)
				if unwrapId == 29624 then
					newItem:setActionId(42707)
				end
			end
		end
		return
	end

	self:sendTextMessage(MESSAGE_INFO_DESCR,"This item cannot be wrapped or unwrapped.")
end