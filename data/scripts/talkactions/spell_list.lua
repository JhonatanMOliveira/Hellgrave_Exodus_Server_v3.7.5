local spellsCommand = TalkAction("!spells")

function spellsCommand.onSay(player, words, param)
    local spells = {}

    -- Pega todas as instant spells que o jogador tem registradas (inclui as que ainda não desbloqueou)
    for _, spell in ipairs(player:getInstantSpells()) do
        -- Remove a condição de level (agora mostra todas, mesmo as de level maior)
        if spell.level ~= 0 then
            local manaText = spell.mana or "0"
            if spell.manapercent and spell.manapercent > 0 then
                manaText = spell.manapercent .. "%"
            end

            -- Adiciona uma informação extra para deixar claro se o jogador já pode usar ou não
            local canUse = player:getLevel() >= spell.level
            local status = canUse and "" or " (not available)"

            table.insert(spells, {
                level = spell.level,
                words = spell.words,
                name = spell.name,
                mana = manaText,
                status = status
            })
        end
    end

    -- Ordena por level crescente
    table.sort(spells, function(a, b)
        return a.level < b.level
    end)

    local text = ""
    local prevLevel = -1

    for _, spell in ipairs(spells) do
        local line = ""
        if prevLevel ~= spell.level then
            if #text > 0 then
                line = "\n"
            end
            line = line .. "Spells for Level " .. spell.level .. "\n"
            prevLevel = spell.level
        end

        text = text .. line .. "  " .. spell.words .. " - " .. spell.name .. " : " .. spell.mana .. spell.status .. "\n"
    end

    if text == "" then
        text = "Nenhuma spell instantânea encontrada."
    end

    player:showTextDialog(2175, text)
    return false
end

-- Opcional: aceita espaço ou vírgula (útil para jogadores que digitam !spells,)
spellsCommand:separator(" ,")
spellsCommand:register()