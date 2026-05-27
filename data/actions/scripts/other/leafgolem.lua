local function doPlayerAddPremiumPoints(cid, count)
		db.query('UPDATE znote_accounts SET points = points+'.. count ..' WHERE account_id = ' .. getAccountNumberByPlayerName(getCreatureName(cid)))
end

function onUse(cid, item, fromPosition, itemEx, toPosition) 
	doPlayerAddPremiumPoints(cid, 100)
	PlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "You have recived 100 shop points to your account.")
	SendMagicEffect(getCreaturePosition(cid), 28)
	doRemoveItem(item.uid,1)
	return true
end