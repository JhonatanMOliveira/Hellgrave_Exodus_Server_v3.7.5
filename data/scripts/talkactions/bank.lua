local bankCommand = TalkAction("!bank")

function bankCommand.onSay(player, words, param)
	local balance = player:getBankBalance() or 0
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, ("Your bank balance is %d gold."):format(balance))
	return false
end

bankCommand:register()
