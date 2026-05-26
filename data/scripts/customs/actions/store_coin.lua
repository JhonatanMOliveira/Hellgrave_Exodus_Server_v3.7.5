local storeCoin = Action()

function storeCoin.onUse(player, item, fromPosition, target, toPosition, isHotkey)
local coins = (item:getCount())
  db.query("UPDATE `accounts` SET `premium_points` = `premium_points` + '" .. coins .. "' WHERE `id` = '" .. player:getAccountId() .. "';")
  player:sendTextMessage(MESSAGE_INFO_DESCR, "You received "..coins.." Store Coins")
  item:remove()
  playSoundPlayer(player, "coin.ogg")
  return true
end

storeCoin:id(24774)
storeCoin:register()