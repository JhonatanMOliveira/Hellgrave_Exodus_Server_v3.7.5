 local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)			npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid)		npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)		npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()				npcHandler:onThink()					end

local function getTable(player)
	local itemsList = {
		{name="axe", id=2386, sell=7},
		{name="battle axe", id=2378, sell=80},
		{name="battle hammer", id=2417, sell=120},
		{name="battle shield", id=2417, sell=95},
		{name="brass armor", id=2465, sell=150},
		{name="brass Helmet", id=2460, sell=30},
		{name="brass Legs", id=2478, sell=49},
		{name="brass Shield", id=2511, sell=25},
		{name="Carlin Sword", id=2395, sell=118},
		{name="chain armor", id=2464, sell=70},
		{name="chain helmet", id=2458, sell=17},
		{name="chain legs", id=2648, sell=25},
		{name="Club", id=2382, sell=1},
		{name="Coat", id=2651, sell=1},
		{name="Crowbar", id=2416, sell=50},
		{name="dagger", id=2379, sell=2},
		{name="Doublet", id=2485, sell=3},
		{name="Dwarven Shield", id=2525, sell=100},
		{name="hand axe", id=2380, sell=4},
		{name="leather armor", id=2467, sell=12},
		{name="leather Boots", id=2643, sell=2},
		{name="leather helmet", id=2461, sell=9},
		{name="leather Legs", id=2649, sell=22},
		{name="Longsword", id=2397, sell=51},
		{name="mace", id=2398, sell=30},
		{name="Morning Star", id=2394, sell=100},
		{name="plate armor", id=2463, sell=400},
		{name="plate Shield", id=2510, sell=45},
		{name="rapier", id=2384, sell=5},
		{name="sabre", id=2385, sell=12},
		{name="Scale Armor", id=2483, sell=75},
		{name="spear", id=2389, sell=3},
		{name="Short Sword", id=2406, sell=10},
		{name="Sickle", id=2405, sell=3},
		{name="Soldier Helmet", id=2481, sell=16},
		{name="Spike Sword", id=2383, sell=240},
		{name="steel Helmet", id=2457, sell=293},
		{name="steel shield", id=2509, sell=80},
		{name="Studded Armor", id=2484, sell=25},
		{name="Studded Helmet", id=2482, sell=20},
		{name="Studded Legs", id=2468, sell=15},
		{name="Studded Shield", id=2526, sell=16},
		{name="swampling club", id=20104, sell=40},
		{name="sword", id=2376, sell=25},		
		{name="wooden shield", id=2512, sell=3},
		{name="two handed sword", id=2377, sell=450},
		{name="bone shoulderplate", id=11321, sell=150},
			{name="broken draken mail", id=12616, sell=340},
			{name="broken halberd", id=11335, sell=100},
			{name="Broken Slicer", id=12617, sell=120},
			{name="cursed shoulder spikes", id=11327, sell=320},
			{name="drachaku", id=11308, sell=10000},
			{name="draken boots", id=12646, sell=40000},
			{name="draken wristbands", id=12615, sell=430},
			{name="drakinata", id=11305, sell=10000},
			{name="Elite Draken Mail", id=12607, sell=50000},
			{name="guardian boots", id=11240, sell=35000},
			{name="high guard's shoulderplates", id=11333, sell=130},
			{name="sais", id=11306, sell=16500},
			{name="spiked iron ball", id=11325, sell=100},
			{name="twiceslicer", id=12613, sell=28000},
			{name="twin hooks", id=11309, sell=500},
			{name="wailing widow's necklace", id=11329, sell=3000},
			{name="warmaster's wristguards", id=11322, sell=200},
			{name="zaoan armor", id=11301, sell=14000},
			{name="zaoan halberd", id=11323, sell=500},
			{name="zaoan helmet", id=11302, sell=45000},
			{name="zaoan legs", id=11304, sell=14000},
			{name="zaoan shoes", id=11303, sell=5000},
			{name="zaoan sword", id=11307, sell=30000},
			{name="zaogun's shoulderplates", id=11331, sell=150}
	}

	local tomes = {
		{
			-- 3 tomes
			{name="lizard weapon rack kit", id=11126, buy=500}
		},
		{
			-- 9 tomes
			{name="bone shoulderplate", id=11321, sell=150},
			{name="broken draken mail", id=12616, sell=340},
			{name="broken halberd", id=11335, sell=100},
			{name="Broken Slicer", id=12617, sell=120},
			{name="cursed shoulder spikes", id=11327, sell=320},
			{name="drachaku", id=11308, sell=10000},
			{name="draken boots", id=12646, sell=40000},
			{name="draken wristbands", id=12615, sell=430},
			{name="drakinata", id=11305, sell=10000},
			{name="Elite Draken Mail", id=12607, sell=50000},
			{name="guardian boots", id=11240, sell=35000},
			{name="high guard's shoulderplates", id=11333, sell=130},
			{name="sais", id=11306, sell=16500},
			{name="spiked iron ball", id=11325, sell=100},
			{name="twiceslicer", id=12613, sell=28000},
			{name="twin hooks", id=11309, sell=500},
			{name="wailing widow's necklace", id=11329, sell=3000},
			{name="warmaster's wristguards", id=11322, sell=200},
			{name="zaoan armor", id=11301, sell=14000},
			{name="zaoan halberd", id=11323, sell=500},
			{name="zaoan helmet", id=11302, sell=45000},
			{name="zaoan legs", id=11304, sell=14000},
			{name="zaoan shoes", id=11303, sell=5000},
			{name="zaoan sword", id=11307, sell=30000},
			{name="zaogun's shoulderplates", id=11331, sell=150}
		}
	}

	if player:getStorageValue(Storage.TheNewFrontier.TomeofKnowledge) >= 3 then
		-- 3 tomes
		for i = 1, #tomes[1] do
			itemsList[#itemsList] = tomes[1][i]
		end
	end

	if player:getStorageValue(Storage.TheNewFrontier.TomeofKnowledge) >= 9 then
		-- 9 tomes
		for i = 1, #tomes[2] do
			itemsList[#itemsList] = tomes[2][i]
		end
	end

	return itemsList
end

local function setNewTradeTable(table)
	local items, item = {}
	for i = 1, #table do
		item = table[i]
		items[item.id] = {itemId = item.id, buyPrice = item.buy, sellPrice = item.sell, subType = 0, realName = item.name}
	end
	return items
end


local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, "trade") then
		local player = Player(cid)
		local items = setNewTradeTable(getTable(player))

		local function onBuy(cid, item, subType, amount, ignoreCap, inBackpacks)
			if (ignoreCap == false and (player:getFreeCapacity() < ItemType(items[item].itemId):getWeight(amount) or inBackpacks and player:getFreeCapacity() < (ItemType(items[item].itemId):getWeight(amount) + ItemType(1988):getWeight()))) then
				return player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You don\'t have enough cap.')
			end
			if items[item].buyPrice <= player:getMoney() then
				if inBackpacks then
					local container = Game.createItem(1988, 1)
					local bp = player:addItemEx(container)
					if(bp ~= 1) then
						return player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You don\'t have enough container.')
					end
					for i = 1, amount do
						container:addItem(items[item].itemId, items[item])
					end
				else
					return
					player:addItem(items[item].itemId, amount, false, items[item]) and
					player:removeMoney(amount * items[item].buyPrice) and
					player:sendTextMessage(MESSAGE_INFO_DESCR, 'You bought '..amount..'x '..items[item].realName..' for '..items[item].buyPrice * amount..' gold coins.')
				end
				player:sendTextMessage(MESSAGE_INFO_DESCR, 'You bought '..amount..'x '..items[item].realName..' for '..items[item].buyPrice * amount..' gold coins.')
				player:removeMoney(amount * items[item].buyPrice)
			else
				player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You do not have enough money.')
			end
			return true
		end

		local function onSell(cid, item, subType, amount, ignoreEquipped)
			if items[item].sellPrice then
				return
				player:removeItem(items[item].itemId, amount, -1, ignoreEquipped) and
				player:addMoney(items[item].sellPrice * amount) and

				player:sendTextMessage(MESSAGE_INFO_DESCR, 'You sold '..amount..'x '..items[item].realName..' for '..items[item].sellPrice * amount..' gold coins.')
			end
			return true
		end

		openShopWindow(cid, getTable(player), onBuy, onSell)
		npcHandler:say("Of course, just browse through my wares.", cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Hello, |PLAYERNAME| and welcome to my little forge.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Bye.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
