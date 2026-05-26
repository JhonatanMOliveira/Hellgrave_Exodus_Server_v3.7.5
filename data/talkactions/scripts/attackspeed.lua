function onSay(cid, words, param)
    local player = Player(cid)
    if not player then
        return false
    end

    local attackSpeed = player:getAttackSpeed()
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Your attack speed is " .. attackSpeed .. " ms.")
    return true
end
