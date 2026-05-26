local config = {
    items = {        
        {2661, 1}, -- scarf
        {2461, 1},  -- leather helmet
        {2467, 1}, -- leather armor        
        {2649, 1}, -- leather legs
        {2643, 1}, -- leather boots
        {30053, 1}, -- espada de treinamento
        {2512, 1}  -- wooden shield
    },
    container = {
        {2120, 1}, -- rope
        {2554, 1}, -- shovel
        {7618, 10}, -- health potion
        {7620, 10}, -- mana potion
        {2666, 20}, -- small backpack
        {2214, 1},  -- ring of healing
        {2214, 1},  -- ring of healing
        {2214, 1},  -- ring of healing
        {2214, 1},  -- ring of healing
        {2214, 1}  -- ring of healing
    },
}
    
    local firstItems = Action()

function firstItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local storage = player:getStorageValue(33735)

    if storage > 0 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You already collected this chest.")
        return true
    end

    for i = 1, #config.items do
        player:addItem(config.items[i][1], config.items[i][2])
    end

    local backpack = player:addItem(1988)
    if not backpack then
        return true
    end

    for i = 1, #config.container do
        backpack:addItem(config.container[i][1], config.container[i][2])
    end
    playSound(player, "open_chest.ogg")
    player:setStorageValue(33735, 1) 
    return true
end

firstItems:aid(33735)
firstItems:register()
