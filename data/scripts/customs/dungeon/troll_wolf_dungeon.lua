local config = {
    entryActionId = 63001,
    entryPosition = Position(1182, 609, 8),
    dungeonEntryPosition = Position(1182, 612, 9),
    areaFrom = Position(1182, 612, 9),
    areaTo = Position(1205, 753, 9),
    exitPosition = Position(1093, 411, 5),
    portalPosition = Position(1206, 757, 8),
    bossPosition = Position(1206, 750, 9),
    bossName = "Big Boss Trolliver",
    bossPool = {
        "Big Boss Trolliver",
        "Troll Champion",
        "Troll Guard",
    },
    requiredKills = 10,
    durationSeconds = 30 * 60,
    respawnDelaySeconds = 3,
    initialSpawnCount = 102,
    cooldownStorage = DUNGEON_SYSTEM and DUNGEON_SYSTEM.Storages and DUNGEON_SYSTEM.Storages.timerCooldown or 59003,
    cooldownSeconds = DUNGEON_SYSTEM and DUNGEON_SYSTEM.CooldownTime or 3600,
}

local dungeonSession = {}
local monsterNames = {
    troll = true,
    wolf = true,
}

local function getBossPool()
    return config.bossPool and #config.bossPool > 0 and config.bossPool or {config.bossName}
end

local function isDungeonBoss(name)
    local lowerName = name:lower()
    for _, bossName in ipairs(getBossPool()) do
        if lowerName == bossName:lower() then
            return true
        end
    end
    return false
end

local function pickRandomBoss()
    local pool = getBossPool()
    return pool[math.random(#pool)]
end

local spawnPoints = {
    Troll = {
        Position(1183, 613, 9),
        Position(1184, 613, 9),
        Position(1185, 613, 9),
        Position(1186, 613, 9),
        Position(1187, 613, 9),
        Position(1188, 613, 9),
    },
    Wolf = {
        Position(1183, 614, 9),
        Position(1184, 614, 9),
        Position(1185, 614, 9),
        Position(1186, 614, 9),
        Position(1187, 614, 9),
        Position(1188, 614, 9),
    },
}

local function getAreaCenter()
    local diffX = math.ceil((config.areaTo.x - config.areaFrom.x) / 2)
    local diffY = math.ceil((config.areaTo.y - config.areaFrom.y) / 2)
    return config.areaFrom + Position(diffX, diffY, 0), diffX, diffY
end

local function getAreaSpectators()
    local center, diffX, diffY = getAreaCenter()
    return Game.getSpectators(center, false, false, diffX, diffX, diffY, diffY)
end

local function formatDuration(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d", minutes, secs)
end

local function spawnExitPortal()
    local tile = Tile(config.portalPosition)
    if not tile then
        return false
    end

    local existingPortal = tile:getItemById(1387)
    if existingPortal then
        existingPortal:remove()
    end

    local teleport = Game.createItem(1387, 1, config.portalPosition)
    if not teleport then
        return false
    end

    teleport:setDestination(config.exitPosition)

    addEvent(function()
        local currentTile = Tile(config.portalPosition)
        if not currentTile then
            return
        end

        local portal = currentTile:getItemById(1387)
        if portal then
            portal:remove()
            config.portalPosition:sendMagicEffect(CONST_ME_POFF)
        end
    end, 120 * 1000)

    config.portalPosition:sendMagicEffect(CONST_ME_TELEPORT)
    return true
end

local function cleanupDungeonMonsters()
    for _, spectator in ipairs(getAreaSpectators()) do
        if spectator:isMonster() then
            local name = spectator:getName():lower()
            if monsterNames[name] or isDungeonBoss(name) then
                spectator:remove()
            end
        end
    end
end

local function getFixedSpawnPosition(monsterName)
    local positions = spawnPoints[monsterName]
    if not positions then
        return nil
    end

    for _, pos in ipairs(positions) do
        local tile = Tile(pos)
        if tile and tile:getGround() and not tile:getTopCreature() then
            return pos
        end
    end

    return nil
end

local function spawnDungeonMonster(monsterName)
    local spawnPos = getFixedSpawnPosition(monsterName)
    if not spawnPos then
        return false
    end

    return Game.createMonster(monsterName, spawnPos) ~= nil
end

local function spawnInitialWave()
    for index = 1, config.initialSpawnCount do
        local monsterName = (index % 2 == 1) and "Troll" or "Wolf"
        spawnDungeonMonster(monsterName)
    end
end

local function finishSession(player, session, successMessage)
    if not session or not session.active then
        return
    end

    session.active = false
    if session.timeoutEventId then
        stopEvent(session.timeoutEventId)
    end

    cleanupDungeonMonsters()

    if player and player:isPlayer() then
        player:setStorageValue(config.cooldownStorage, os.time() + config.cooldownSeconds)
        player:teleportTo(config.exitPosition, false)
        config.exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
        if successMessage then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, successMessage)
        end
    end
end

local function completeDungeon(player, session, successMessage)
    if not session or not session.active then
        return
    end

    session.active = false
    if session.timeoutEventId then
        stopEvent(session.timeoutEventId)
    end

    cleanupDungeonMonsters()

    if player and player:isPlayer() then
        player:setStorageValue(config.cooldownStorage, os.time() + config.cooldownSeconds)
        spawnExitPortal()
        if successMessage then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, successMessage)
        end
    end
end

local function startDungeon(player)
    local playerId = player:getId()

    if dungeonSession[playerId] and dungeonSession[playerId].active then
        player:sendCancelMessage("You are already inside this dungeon.")
        return false
    end

    if player:getStorageValue(config.cooldownStorage) - os.time() > 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must wait before entering this dungeon again.")
        return false
    end

    for _, spectator in ipairs(getAreaSpectators()) do
        if spectator:isPlayer() and spectator:getId() ~= playerId then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A player is already inside this dungeon.")
            return false
        end
    end

    cleanupDungeonMonsters()

    local session = {
        active = true,
        playerId = playerId,
        kills = 0,
        bossSpawned = false,
        fromPosition = player:getPosition(),
        timeoutEventId = nil,
    }
    dungeonSession[playerId] = session

    player:registerEvent("TrollWolfDungeonKill")
    player:registerEvent("TrollWolfDungeonLogout")
    player:teleportTo(config.dungeonEntryPosition, false)
    config.dungeonEntryPosition:sendMagicEffect(CONST_ME_TELEPORT)

    player:sendTextMessage(
        MESSAGE_STATUS_SMALL,
        string.format("Dungeon progress: %d/%d kills.", session.kills, config.requiredKills)
    )

    spawnInitialWave()

    session.timeoutEventId = addEvent(function()
        local currentSession = dungeonSession[playerId]
        local currentPlayer = Player(playerId)
        if not currentSession or not currentSession.active then
            return
        end

        finishSession(currentPlayer, currentSession, "Dungeon time is over.")
        dungeonSession[playerId] = nil
    end, config.durationSeconds * 1000)

    return true
end

function TrollWolfDungeonStart(player)
    if not player or not player:isPlayer() then
        return false
    end

    local playerId = player:getId()
    if dungeonSession[playerId] and dungeonSession[playerId].active then
        player:sendCancelMessage("You are already inside this dungeon.")
        return false
    end

    if player:getStorageValue(config.cooldownStorage) - os.time() > 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must wait before entering this dungeon again.")
        return false
    end

    for _, spectator in ipairs(getAreaSpectators()) do
        if spectator:isPlayer() then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A player is already inside this dungeon.")
            return false
        end
    end

    player:teleportTo(config.entryPosition, false)
    config.entryPosition:sendMagicEffect(CONST_ME_TELEPORT)
    return true
end

local entryMoveEvent = MoveEvent()

function entryMoveEvent.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end

    if position.x ~= config.entryPosition.x or position.y ~= config.entryPosition.y or position.z ~= config.entryPosition.z then
        return true
    end

    startDungeon(player)
    return true
end

entryMoveEvent:aid(config.entryActionId)
entryMoveEvent:register()

local dungeonKillLogin = CreatureEvent("TrollWolfDungeonLogin")

function dungeonKillLogin.onLogin(player)
    player:registerEvent("TrollWolfDungeonKill")
    player:registerEvent("TrollWolfDungeonLogout")
    return true
end

dungeonKillLogin:type("login")
dungeonKillLogin:register()

local dungeonKill = CreatureEvent("TrollWolfDungeonKill")

function dungeonKill.onKill(player, target)
    if not player or not target or not target:isMonster() then
        return true
    end

    local session = dungeonSession[player:getId()]
    if not session or not session.active then
        return true
    end

    local targetName = target:getName():lower()

    if isDungeonBoss(targetName) then
        completeDungeon(player, session, "Boss defeated. The exit portal has appeared.")
        dungeonSession[player:getId()] = nil
        return true
    end

    if not monsterNames[targetName] then
        return true
    end

    session.kills = session.kills + 1
    player:sendTextMessage(
        MESSAGE_STATUS_SMALL,
        string.format("Dungeon progress: %d/%d kills.", session.kills, config.requiredKills)
    )

    if session.kills >= config.requiredKills and not session.bossSpawned then
        local bossName = pickRandomBoss()
        local boss = Game.createMonster(bossName, config.bossPosition)
        if boss then
            session.bossSpawned = true
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A boss has appeared in the dungeon!")
            config.bossPosition:sendMagicEffect(CONST_ME_TELEPORT)
        else
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The boss could not appear at the spawn point.")
        end
        return true
    end

    if not session.bossSpawned then
        local monsterName = targetName == "troll" and "Troll" or "Wolf"
        local playerId = player:getId()
        local sessionRef = session
        addEvent(function()
            local currentSession = dungeonSession[playerId]
            local currentPlayer = Player(playerId)
            if not currentSession or not currentSession.active or currentSession ~= sessionRef then
                return
            end
            if currentSession.bossSpawned then
                return
            end
            spawnDungeonMonster(monsterName)
        end, config.respawnDelaySeconds * 1000)
    end

    return true
end

dungeonKill:register()

local dungeonLogout = CreatureEvent("TrollWolfDungeonLogout")

function dungeonLogout.onLogout(player)
    local session = dungeonSession[player:getId()]
    if session and session.active then
        if session.timeoutEventId then
            stopEvent(session.timeoutEventId)
        end
        player:setStorageValue(config.cooldownStorage, os.time() + config.cooldownSeconds)
        cleanupDungeonMonsters()
        dungeonSession[player:getId()] = nil
    end
    return true
end

dungeonLogout:type("logout")
dungeonLogout:register()
