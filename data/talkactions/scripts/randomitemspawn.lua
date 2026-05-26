-- ============================================================
-- Talkaction: /spawnitem
-- Forca o respawn manual de todos os grupos
-- Uso: /spawnitem
-- ============================================================

local ACTIVE_COUNT = 5

local group1 = {
	items = { 26405 },
	positions = {
		Position(1039, 488, 6),
		Position(1034, 487, 6),
		Position(1033, 489, 6),
		Position(1034, 492, 6),
		Position(1034, 494, 6),
		Position(1039, 496, 6),
		Position(1044, 492, 5),
		Position(1052, 492, 5),
		Position(1057, 491, 5),
		Position(1057, 495, 6),
		Position(1089, 500, 7),
		Position(1091, 505, 7),
		Position(1091, 509, 7),
		Position(1092, 513, 7),
		Position(1092, 517, 7),
		Position(1092, 519, 7),
		Position(1113, 511, 7),
		Position(1114, 508, 7),
		Position(1113, 504, 7),
		Position(1113, 500, 7)
	}
}

local group2 = {
	items = { 26406, 26407 },
	positions = {
		Position(1000, 1000, 7),
		Position(1001, 1001, 7),
		Position(1002, 1002, 7),
		Position(1003, 1003, 7),
		Position(1004, 1004, 7),
		Position(1005, 1005, 7),
		Position(1006, 1006, 7),
		Position(1007, 1007, 7),
		Position(1008, 1008, 7),
		Position(1009, 1009, 7),
		Position(1010, 1010, 7),
		Position(1011, 1011, 7),
		Position(1012, 1012, 7),
		Position(1013, 1013, 7),
		Position(1014, 1014, 7),
		Position(1015, 1015, 7),
		Position(1016, 1016, 7),
		Position(1017, 1017, 7),
		Position(1018, 1018, 7),
		Position(1019, 1019, 7)
	}
}

local group3 = {
	items = { 26408, 26409 },
	positions = {
		Position(2000, 2000, 7),
		Position(2001, 2001, 7),
		Position(2002, 2002, 7),
		Position(2003, 2003, 7),
		Position(2004, 2004, 7),
		Position(2005, 2005, 7),
		Position(2006, 2006, 7),
		Position(2007, 2007, 7),
		Position(2008, 2008, 7),
		Position(2009, 2009, 7),
		Position(2010, 2010, 7),
		Position(2011, 2011, 7),
		Position(2012, 2012, 7),
		Position(2013, 2013, 7),
		Position(2014, 2014, 7),
		Position(2015, 2015, 7),
		Position(2016, 2016, 7),
		Position(2017, 2017, 7),
		Position(2018, 2018, 7),
		Position(2019, 2019, 7)
	}
}

local group4 = {
	items = { 26410, 26411 },
	positions = {
		Position(3000, 3000, 7),
		Position(3001, 3001, 7),
		Position(3002, 3002, 7),
		Position(3003, 3003, 7),
		Position(3004, 3004, 7),
		Position(3005, 3005, 7),
		Position(3006, 3006, 7),
		Position(3007, 3007, 7),
		Position(3008, 3008, 7),
		Position(3009, 3009, 7),
		Position(3010, 3010, 7),
		Position(3011, 3011, 7),
		Position(3012, 3012, 7),
		Position(3013, 3013, 7),
		Position(3014, 3014, 7),
		Position(3015, 3015, 7),
		Position(3016, 3016, 7),
		Position(3017, 3017, 7),
		Position(3018, 3018, 7),
		Position(3019, 3019, 7)
	}
}

local allGroups = { group1, group2, group3, group4 }

local function getRandomPositions(positions, count)
	local indices = {}
	for i = 1, #positions do
		indices[i] = i
	end
	for i = #indices, 2, -1 do
		local j = math.random(1, i)
		indices[i], indices[j] = indices[j], indices[i]
	end
	local selected = {}
	for i = 1, count do
		selected[i] = positions[indices[i]]
	end
	return selected
end

local function removeGroupItems(group)
	for _, pos in ipairs(group.positions) do
		local tile = Tile(pos)
		if tile then
			for _, itemId in ipairs(group.items) do
				local item = tile:getItemById(itemId)
				if item then
					item:remove()
				end
			end
		end
	end
end

local function spawnGroup(group)
	removeGroupItems(group)
	local newPositions = getRandomPositions(group.positions, ACTIVE_COUNT)
	local spawned = 0
	for _, pos in ipairs(newPositions) do
		local chosenId = group.items[math.random(1, #group.items)]
		local item = Game.createItem(chosenId, 1, pos)
		if item then
			spawned = spawned + 1
		end
	end
	return spawned
end

function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	local totalSpawned = 0
	for _, group in ipairs(allGroups) do
		totalSpawned = totalSpawned + spawnGroup(group)
	end

	player:sendTextMessage(MESSAGE_STATUS_WARNING, "[SpawnMinerio] " .. totalSpawned .. " minerios spawnados em 4 grupos!")
	print("[SpawnMinerio] Ativado por " .. player:getName() .. ". Total: " .. totalSpawned .. " minerios.")
	return false
end
