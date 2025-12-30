local storeBox = Action()

local REWARD = {29181, 29188, 29195}
function storeBox.onUse(cid, item, fromPosition, itemEx, toPosition)
      local randomChance = math.random(1, #REWARD)
      doPlayerAddItem(cid, REWARD[randomChance], 1)

local randomLoot = math.random(1,20)
    if randomLoot == 1 then
    doPlayerSendTextMessage(cid, 19, "You found an extra item!")
             local randomChance = math.random(1, #REWARD)
              doPlayerAddItem(cid, REWARD[randomChance], 1)
    end
 
doSendMagicEffect(getPlayerPosition(cid), 73)
   doRemoveItem(item.uid, 1)
   return true
end

storeBox:id(29739)
storeBox:register()