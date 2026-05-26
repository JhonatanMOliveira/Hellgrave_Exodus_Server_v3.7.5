--- Script created by
--- ______     __         ______     __  __   
---/\  __ \   /\ \       /\  ___\   /\_\_\_\  
---\ \  __ \  \ \ \____  \ \  __\   \/_/\_\/_ 
--- \ \_\ \_\  \ \_____\  \ \_____\   /\_\/\_\
---  \/_/\/_/   \/_____/   \/_____/   \/_/\/_/
                                           

print(">> Pet System Loaded")

local pet_experience = 633451
local pet_level = 633452
local pet_id = 633453
local pet_name = 633454

local cooldown_storage = 808815
local familiar_duration = 30
local familiar_cooldown = 60
local familiar_total_wait = familiar_duration + familiar_cooldown

local familiarChoiceNames = {
  [1] = "Knight Familiar",
  [2] = "Black Dracadet",
  [3] = "Black Dracadet [2]",
  [4] = "Black Dracadet [3]",
  [5] = "Frost Dracadet",
  [6] = "Frost Dracadet [2]",
  [7] = "Frost Dracadet [3]",
  [8] = "Swamp Dracadet",
  [9] = "Swamp Dracadet [2]",
  [10] = "Swamp Dracadet [3]",
  [11] = "Stone Dracadet",
  [12] = "Stone Dracadet [2]",
  [13] = "Stone Dracadet [3]",
  [14] = "Fire Dracadet",
  [15] = "Fire Dracadet [2]",
  [16] = "Fire Dracadet [3]",
}

local familiarSummons = {
  {storage = Expeditions.FrostDracadetPetChoice3, name = "Frost Dracadet [3]"},
  {storage = Expeditions.FrostDracadetPetChoice2, name = "Frost Dracadet [2]"},
  {storage = Expeditions.FrostDracadetPetChoice, name = "Frost Dracadet"},
  {storage = Expeditions.FireDracadetPetChoice3, name = "Fire Dracadet [3]"},
  {storage = Expeditions.FireDracadetPetChoice2, name = "Fire Dracadet [2]"},
  {storage = Expeditions.FireDracadetPetChoice, name = "Fire Dracadet"},
  {storage = Expeditions.StoneDracadetPetChoice3, name = "Stone Dracadet [3]"},
  {storage = Expeditions.StoneDracadetPetChoice2, name = "Stone Dracadet [2]"},
  {storage = Expeditions.StoneDracadetPetChoice, name = "Stone Dracadet"},
  {storage = Expeditions.SwampDracadetPetChoice3, name = "Swamp Dracadet [3]"},
  {storage = Expeditions.SwampDracadetPetChoice2, name = "Swamp Dracadet [2]"},
  {storage = Expeditions.SwampDracadetPetChoice0, name = "Swamp Dracadet"},
  {storage = Expeditions.BlackDracadetPetChoice3, name = "Black Dracadet [3]"},
  {storage = Expeditions.BlackDracadetPetChoice2, name = "Black Dracadet [2]"},
  {storage = Expeditions.BlackDracadetPetChoice, name = "Black Dracadet"},
  {storage = Expeditions.NormalFamiliarChoice, name = "Knight Familiar"},
}

local function getSelectedFamiliarName(player)
  local selectedChoice = player:getStorageValue(pet_name)
  if selectedChoice and selectedChoice > 0 then
    local choiceName = familiarChoiceNames[selectedChoice]
    if choiceName then
      return choiceName
    end
  end

  for _, entry in ipairs(familiarSummons) do
    if player:getStorageValue(entry.storage) == 1 then
      return entry.name
    end
  end

  return "Knight Familiar"
end

local function expireFamiliar(petId, playerId)
  local pet = Creature(petId)
  if not pet then
    return
  end

  local master = pet:getMaster()
  if not master or master:getId() ~= playerId then
    return
  end

  local player = Player(playerId)
  if player and player:getStorageValue(pet_id) == petId then
    player:setStorageValue(pet_id, 0)
    player:setStorageValue(cooldown_storage, os.time() + familiar_cooldown)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Your Familiar has vanished. You can summon it again in 1 minute.")
  end

  pet:remove()
end

function createPet(cid, petName)
  local player = Player(cid)
  if not player then
    return
  end

  local summons = player:getSummons()
  for _, summon in ipairs(summons) do
    if summon:isMonster() then
      player:sendTextMessage(MESSAGE_INFO_DESCR, "You already have a pet or familiar summoned.")
      return
    end
  end

  local currentCooldown = player:getStorageValue(cooldown_storage)
  if currentCooldown > os.time() then
    local remainingCooldown = currentCooldown - os.time()
    local minutes = math.ceil(remainingCooldown / 60)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "You need to wait " .. minutes .. " more minutes before summoning a Familiar again.")
    return
  end

  local pet = nil
  local summonName = petName
  if summonName == nil or summonName == "" then
    summonName = getSelectedFamiliarName(player)
  end

  pet = Game.createMonster(summonName, player:getPosition())
  if not pet and summonName ~= "Knight Familiar" then
    pet = Game.createMonster("Knight Familiar", player:getPosition())
  end

  if pet ~= nil then
    playSound(player, "monster_summoned.ogg")
    pet:setMaster(player)
    pet:registerEvent('SummonFollow')
    local petStorageValue = 655421 + player:getAccountId()
    pet:setStorageValue(tostring(petStorageValue), pet:getId())
    pet:setStorageValue(pet_experience, 0) 
    pet:setStorageValue(pet_level, 1)
    player:setStorageValue(pet_id, pet:getId())
    player:setStorageValue(cooldown_storage, os.time() + familiar_total_wait)
    addEvent(expireFamiliar, familiar_duration * 1000, pet:getId(), player:getId())
    player:sendTextMessage(MESSAGE_INFO_DESCR, "You have summoned your Familiar.")
  else
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Unable to create the Familiar.")
  end
end


local pet_storage_experience = 633451
local pet_storage_level = 633452

function loadPlayerPet(player)
  local petId = player:getStorageValue(pet_id)
  if petId > 0 then
    local pet = Creature(petId)  
    if pet then
      local accountId = player:getAccountId()
      local query = db.storeQuery("SELECT `pet_experience`, `pet_level` FROM `players` WHERE `id` = " .. player:getGuid())
      if query ~= nil then
        local petExperience = result.getNumber(query, "pet_experience")
        local petLevel = result.getNumber(query, "pet_level")
        result.free(query)

        pet:setStorageValue(pet_storage_experience, petExperience)
        pet:setStorageValue(pet_storage_level, petLevel)
        return pet
      end
    end
  else
    return true  
  end
  return nil  
end



local storageGet = TalkAction("!summonfamiliar")

storageGet.onSay = function(player, words)
  if player:getLevel() >= 1 then
  if words == "!summonfamiliar" then
    local playerPos = player:getPosition()
    local summons = Game.getSpectators(playerPos, false, true, 1, 1, 1, 1)
    for _, summon in ipairs(summons) do
      if summon:isMonster() and summon:getMaster() == player then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You already have a pet or familiar summoned.")
        return false
      end
    end
    loadPlayerPet(player)
    local petName = getSelectedFamiliarName(player)
    createPet(player, petName)
    return false
  end
else
  player:sendTextMessage(MESSAGE_INFO_DESCR, "You need level 200 to summon your Familiar.")
end
  return true
end

storageGet:separator(" ")
storageGet:register()

local petLevelAction = TalkAction("!familiarlevel")

function calculateNextLevelExperience(level)
  return level * level * 200
end

petLevelAction.onSay = function(player, words)
  if words == "!familiarlevel" then
    local pet = loadPlayerPet(player)
    
    if pet then
      local petLevel = pet:getStorageValue(pet_level)
      local petExperience = pet:getStorageValue(pet_experience)
      local petNextLevelExperience = calculateNextLevelExperience(petLevel)
      
      player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Your Familiar is currently level %d.\nYour Familiar has experience %d/%d.", petLevel, petExperience, petNextLevelExperience))
    else
      player:sendTextMessage(MESSAGE_INFO_DESCR, "You don't have a Familiar summoned.")
    end
    
    return false
  end
  
  return true
end

petLevelAction:separator(" ")
petLevelAction:register()


local familiarChoiceModal = TalkAction("!choosefamiliar")

function showFamiliarChoiceWindow(player)
    local modal = ModalWindow(1000, "Choose your Familiar", "Select your Familiar.")
    player:registerEvent("choiceFamiliar")

    modal:addChoice(1, "Normal Familiar")
    modal:addChoice(2, "Black Dracadet")
    modal:addChoice(3, "Black Dracadet [2]")
    modal:addChoice(4, "Black Dracadet [3]")
    modal:addChoice(5, "Frost Dracadet")
    modal:addChoice(6, "Frost Dracadet [2]")
    modal:addChoice(7, "Frost Dracadet [3]")
    modal:addChoice(8, "Swamp Dracadet")
    modal:addChoice(9, "Swamp Dracadet [2]")
    modal:addChoice(10, "Swamp Dracadet [3]")
    modal:addChoice(11, "Stone Dracadet")
    modal:addChoice(12, "Stone Dracadet [2]")
    modal:addChoice(13, "Stone Dracadet [3]")
    modal:addChoice(14, "Fire Dracadet")
    modal:addChoice(15, "Fire Dracadet [2]")
    modal:addChoice(16, "Fire Dracadet [3]")


    modal:setDefaultEnterButton(100)
    modal:setDefaultEscapeButton(101)

    modal:addButton(100, "OK")
    modal:addButton(101, "Cancel")
    modal:sendToPlayer(player)
end

local familiarSummonNames = {
  [1] = "Knight Familiar",
  [2] = "Black Dracadet",
  [3] = "Black Dracadet [2]",
  [4] = "Black Dracadet [3]",
  [5] = "Frost Dracadet",
  [6] = "Frost Dracadet [2]",
  [7] = "Frost Dracadet [3]",
  [8] = "Swamp Dracadet",
  [9] = "Swamp Dracadet [2]",
  [10] = "Swamp Dracadet [3]",
  [11] = "Stone Dracadet",
  [12] = "Stone Dracadet [2]",
  [13] = "Stone Dracadet [3]",
  [14] = "Fire Dracadet",
  [15] = "Fire Dracadet [2]",
  [16] = "Fire Dracadet [3]",
}

familiarChoiceModal.onSay = function(player, words, param)
    showFamiliarChoiceWindow(player)
    return false
end

familiarChoiceModal:register()
