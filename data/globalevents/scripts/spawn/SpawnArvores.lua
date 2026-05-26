-- ============================================================
-- SpawnArvores.lua
-- 4 grupos independentes, cada um com 5 micro-grupos de 5 spots.
-- De cada micro-grupo, 1 posicao e sorteada para spawn.
-- Troca a cada 30 minutos.
-- ============================================================

-- ============================================================
-- GRUPO 1: Itens 26635, 26634, 26605, 26604
-- ============================================================
local group1 = {
	items = { 26635, 26634, 26605, 26606 },
	subgroups = {
		-- Micro-grupo 1 (1 sera sorteado) deserto
		{
			Position(1039, 488, 6),
			Position(1034, 487, 6),
			Position(1033, 489, 6),
			Position(1034, 492, 6),
			Position(1034, 494, 6),
		},
		-- Micro-grupo 2 (1 sera sorteado) floresta
		{
			Position(1039, 496, 6),
			Position(1044, 492, 5),
			Position(1052, 492, 5),
			Position(1057, 491, 5),
			Position(1057, 495, 6),
		},
		-- Micro-grupo 3 (1 sera sorteado) gelo
		{
			Position(1089, 500, 7),
			Position(1091, 505, 7),
			Position(1091, 509, 7),
			Position(1092, 513, 7),
			Position(1092, 517, 7),
		},
		-- Micro-grupo 4 (1 sera sorteado) terra
		{
			Position(1092, 519, 7),
			Position(1113, 511, 7),
			Position(1114, 508, 7),
			Position(1113, 504, 7),
			Position(1113, 500, 7),
		},
		-- Micro-grupo 5 (1 sera sorteado) - EDITE aleatorio
		{
			Position(1000, 1000, 7),
			Position(1001, 1001, 7),
			Position(1002, 1002, 7),
			Position(1003, 1003, 7),
			Position(1004, 1004, 7),
		},
	}
}

-- ============================================================
-- GRUPO 2: Itens 26611, 26610
-- EDITE as posicoes dos 5 micro-grupos abaixo
-- ============================================================
local group2 = {
	items = { 26611, 26610 },
	subgroups = {
		-- Micro-grupo 1 (1 sera sorteado) deserto
		{
			Position(2000, 2000, 7),
			Position(2001, 2001, 7),
			Position(2002, 2002, 7),
			Position(2003, 2003, 7),
			Position(2004, 2004, 7),
		},
		-- Micro-grupo 2 floresta
		{
			Position(2005, 2005, 7),
			Position(2006, 2006, 7),
			Position(2007, 2007, 7),
			Position(2008, 2008, 7),
			Position(2009, 2009, 7),
		},
		-- Micro-grupo 3 gelo
		{
			Position(2010, 2010, 7),
			Position(2011, 2011, 7),
			Position(2012, 2012, 7),
			Position(2013, 2013, 7),
			Position(2014, 2014, 7),
		},
		-- Micro-grupo 4 terra
		{
			Position(2015, 2015, 7),
			Position(2016, 2016, 7),
			Position(2017, 2017, 7),
			Position(2018, 2018, 7),
			Position(2019, 2019, 7),
		},
		-- Micro-grupo 5 aleatorio
		{
			Position(2020, 2020, 7),
			Position(2021, 2021, 7),
			Position(2022, 2022, 7),
			Position(2023, 2023, 7),
			Position(2024, 2024, 7),
		},
	}
}

-- ============================================================
-- GRUPO 3: Itens 26614, 26613
-- EDITE as posicoes dos 5 micro-grupos abaixo
-- ============================================================
local group3 = {
	items = { 26614, 26613 },
	subgroups = {
		-- Micro-grupo 1 deserto
		{
			Position(3000, 3000, 7),
			Position(3001, 3001, 7),
			Position(3002, 3002, 7),
			Position(3003, 3003, 7),
			Position(3004, 3004, 7),
		},
		-- Micro-grupo 2 floresta
		{
			Position(3005, 3005, 7),
			Position(3006, 3006, 7),
			Position(3007, 3007, 7),
			Position(3008, 3008, 7),
			Position(3009, 3009, 7),
		},
		-- Micro-grupo 3 gelo
		{
			Position(3010, 3010, 7),
			Position(3011, 3011, 7),
			Position(3012, 3012, 7),
			Position(3013, 3013, 7),
			Position(3014, 3014, 7),
		},
		-- Micro-grupo 4 terra
		{
			Position(3015, 3015, 7),
			Position(3016, 3016, 7),
			Position(3017, 3017, 7),
			Position(3018, 3018, 7),
			Position(3019, 3019, 7),
		},
		-- Micro-grupo 5 aleatorio
		{
			Position(3020, 3020, 7),
			Position(3021, 3021, 7),
			Position(3022, 3022, 7),
			Position(3023, 3023, 7),
			Position(3024, 3024, 7),
		},
	}
}

-- ============================================================
-- GRUPO 4: Itens 26608, 26609
-- EDITE as posicoes dos 5 micro-grupos abaixo
-- ============================================================
local group4 = {
	items = { 26608, 26609 },
	subgroups = {
		-- Micro-grupo 1 deserto
		{
			Position(4000, 4000, 7),
			Position(4001, 4001, 7),
			Position(4002, 4002, 7),
			Position(4003, 4003, 7),
			Position(4004, 4004, 7),
		},
		-- Micro-grupo 2 floresta
		{
			Position(4005, 4005, 7),
			Position(4006, 4006, 7),
			Position(4007, 4007, 7),
			Position(4008, 4008, 7),
			Position(4009, 4009, 7),
		},
		-- Micro-grupo 3 gelo
		{
			Position(4010, 4010, 7),
			Position(4011, 4011, 7),
			Position(4012, 4012, 7),
			Position(4013, 4013, 7),
			Position(4014, 4014, 7),
		},
		-- Micro-grupo 4 terra
		{
			Position(4015, 4015, 7),
			Position(4016, 4016, 7),
			Position(4017, 4017, 7),
			Position(4018, 4018, 7),
			Position(4019, 4019, 7),
		},
		-- Micro-grupo 5 aleatorio
		{
			Position(4020, 4020, 7),
			Position(4021, 4021, 7),
			Position(4022, 4022, 7),
			Position(4023, 4023, 7),
			Position(4024, 4024, 7),
		},
	}
}

-- Lista de todos os grupos
local allGroups = { group1, group2, group3, group4 }

-- ============================================================
-- FUNCOES
-- ============================================================

-- Coleta todas as posicoes de todos os subgrupos de um grupo
local function getAllPositions(group)
	local all = {}
	for _, subgroup in ipairs(group.subgroups) do
		for _, pos in ipairs(subgroup) do
			table.insert(all, pos)
		end
	end
	return all
end

-- Remove todos os itens de um grupo de todas as suas posicoes
local function removeGroupItems(group)
	local allPos = getAllPositions(group)
	for _, pos in ipairs(allPos) do
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

-- Spawna itens de um grupo: sorteia 1 posicao de cada micro-grupo
local function spawnGroup(group)
	removeGroupItems(group)
	local spawned = 0
	for _, subgroup in ipairs(group.subgroups) do
		-- Sorteia 1 posicao aleatoria deste micro-grupo
		local pos = subgroup[math.random(1, #subgroup)]
		-- Sorteia 1 item aleatorio do grupo
		local chosenId = group.items[math.random(1, #group.items)]
		local item = Game.createItem(chosenId, 1, pos)
		if item then
			spawned = spawned + 1
		end
	end
	local itemNames = ""
	for i, id in ipairs(group.items) do
		itemNames = itemNames .. id
		if i < #group.items then
			itemNames = itemNames .. "/"
		end
	end
	print("[SpawnArvores] Grupo [" .. itemNames .. "]: " .. spawned .. " arvores spawnadas.")
end

-- Spawna todos os grupos
local function spawnAllGroups()
	for _, group in ipairs(allGroups) do
		spawnGroup(group)
	end
end

-- Chamado ao iniciar o servidor
function onStartup()
	spawnAllGroups()
	return true
end

-- Chamado a cada 30 minutos (1800000 ms)
function onThink(interval, lastExecution, thinkInterval)
	spawnAllGroups()
	return true
end
