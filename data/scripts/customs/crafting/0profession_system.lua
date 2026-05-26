ProfessionSystem = ProfessionSystem or {}

ProfessionSystem.storageKey = 60001
ProfessionSystem.modalId = 54001

ProfessionSystem.professions = {
	[1] = {
		name = "Herbalista",
		categories = {
			herbalist = true,
			generalcrafting = true
		}
	},
	[2] = {
		name = "Minerador",
		categories = {
			mining = true,
			armorsmith = true,
			weaponsmith = true
		}
	},
	[3] = {
		name = "Lenhador",
		categories = {
			woodcutting = true,
			jewelsmith = true
		}
	}
}

ProfessionSystem.categoryToProfession = {
	herbalist = 1,
	generalcrafting = 1,
	mining = 2,
	armorsmith = 2,
	weaponsmith = 2,
	woodcutting = 3,
	jewelsmith = 3
}

function ProfessionSystem:getProfession(player)
	if not player then
		return 0
	end

	local professionId = tonumber(player:getStorageValue(self.storageKey)) or 0
	if self.professions[professionId] then
		return professionId
	end

	return 0
end

function ProfessionSystem:getProfessionName(player)
	local professionId = self:getProfession(player)
	local profession = self.professions[professionId]
	return profession and profession.name or nil
end

function ProfessionSystem:setProfession(player, professionId)
	if not player or not self.professions[professionId] then
		return false
	end

	if self:getProfession(player) ~= 0 then
		return false
	end

	player:setStorageValue(self.storageKey, professionId)
	return true
end

function ProfessionSystem:resetProfession(player)
	if not player then
		return false
	end

	player:setStorageValue(self.storageKey, 0)
	return true
end

function ProfessionSystem:canCraft(player, category)
	local professionId = self:getProfession(player)
	local profession = self.professions[professionId]
	if not profession then
		return false
	end

	return profession.categories[category] == true
end

function ProfessionSystem:canUseTool(player, professionId)
	return self:getProfession(player) == professionId
end

function ProfessionSystem:getRestrictedMessage(player)
	local professionName = self:getProfessionName(player)
	if professionName then
		return "Sua profissao (" .. professionName .. ") nao permite craftar nesta categoria."
	end

	return "Voce precisa escolher uma profissao primeiro! Use !profissao"
end

function ProfessionSystem:getToolRestrictedMessage(player)
	local professionName = self:getProfessionName(player)
	if professionName then
		return "Sua profissao (" .. professionName .. ") nao permite usar esta ferramenta."
	end

	return "Voce precisa escolher uma profissao primeiro! Use !profissao"
end

local professionTalk = TalkAction("!profissao")

local professionChoice = CreatureEvent("ProfessionSystemModal")

function professionChoice.onModalWindow(player, modalWindowId, buttonId, choiceId)
	if modalWindowId ~= ProfessionSystem.modalId then
		return true
	end

	if buttonId ~= 100 then
		return true
	end

	local selectedProfession = tonumber(choiceId) or 0
	if not ProfessionSystem.professions[selectedProfession] then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Escolha invalida.")
		return true
	end

	if ProfessionSystem:getProfession(player) ~= 0 then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Voce ja escolheu uma profissao e ela nao pode ser alterada.")
		return true
	end

	ProfessionSystem:setProfession(player, selectedProfession)
	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Profissao definida com sucesso: " .. ProfessionSystem.professions[selectedProfession].name .. ".")
	return true
end

professionChoice:register()

function professionTalk.onSay(player, words, param)
	if ProfessionSystem:getProfession(player) ~= 0 then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Voce ja escolheu uma profissao e ela nao pode ser alterada.")
		return false
	end

	player:registerEvent("ProfessionSystemModal")

	local window = ModalWindow(ProfessionSystem.modalId, "Escolha sua profissao", "A profissao e permanente. Escolha com cuidado.")
	window:addChoice(1, "Herbalista")
	window:addChoice(2, "Minerador")
	window:addChoice(3, "Lenhador")
	window:setDefaultEnterButton(100)
	window:setDefaultEscapeButton(101)
	window:addButton(100, "Confirmar")
	window:addButton(101, "Cancelar")
	window:sendToPlayer(player)
	return false
end

professionTalk:register()

local resetProfessionTalk = TalkAction("!resetprofissao")

function resetProfessionTalk.onSay(player, words, param)
	if not player:getGroup():getAccess() then
		player:sendCancelMessage("Voce nao tem permissao para usar este comando.")
		return false
	end

	if param == "" then
		player:sendCancelMessage("Use: !resetprofissao nome_do_player")
		return false
	end

	local target = Player(param)
	if not target then
		player:sendCancelMessage("Player nao encontrado online.")
		return false
	end

	local currentProfession = ProfessionSystem:getProfession(target)
	ProfessionSystem:resetProfession(target)

	player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Profissao do jogador " .. target:getName() .. " foi resetada.")
	if currentProfession > 0 then
		target:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sua profissao foi resetada por um administrador. Use !profissao para escolher novamente.")
	else
		target:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Sua profissao foi resetada por um administrador. Use !profissao para escolher uma profissao.")
	end
	return false
end

resetProfessionTalk:separator(" ")
resetProfessionTalk:register()
