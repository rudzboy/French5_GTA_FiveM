TriggerEvent("es:addGroup", "admin", "user", function(group) end)

--Help Commands
TriggerEvent('es:addCommand', 'help', function(source, args, user)
    TriggerClientEvent("chatMessage", source, "^3SYSTEM", { 255, 255, 255 }, "Player Commands ")
    TriggerClientEvent("chatMessage", source, "^3SYSTEM", { 255, 255, 255 }, "-------------------------------------------------------")
    TriggerClientEvent("chatMessage", source, "^3SYSTEM", { 255, 255, 255 }, "/pv - Get teleported in your personal vehicle")
    TriggerClientEvent("chatMessage", source, "^3SYSTEM", { 255, 255, 255 }, "/rmwanted - Remove your wanted level")
end)

TriggerEvent('es:addCommand', 'group', function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Group: ^2" .. user.group.group)
end)

-- Kicking
TriggerEvent('es:addGroupCommand', 'kick', "mod", function(source, args, user)
    if (GetPlayerName(tonumber(args[2]))) then
        local player = tonumber(args[2])

        -- User permission check
        TriggerEvent("es:getPlayerFromId", player, function(target)
            if (tonumber(target.permission_level) > tonumber(user.permission_level)) then
                TriggerClientEvent("chatMessage", source, "SYSTEM", { 255, 0, 0 }, "You're not allowed to target this person!")
                return
            end

            local reason = args
            table.remove(reason, 1)
            table.remove(reason, 1)
            if (#reason == 0) then
                reason = "Kicked: You have been kicked from the server"
            else
                reason = "Kicked: " .. table.concat(reason, " ")
            end

            --TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 has been kicked(^2" .. reason .. "^0)")
            DropPlayer(player, reason)
        end)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Incorrect player ID!")
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficienct permissions!")
end)


TriggerEvent('es:addCommand', 'rmwanted', function(source)
    TriggerEvent("es:getPlayerFromId", source, function(user)
        if (user.money > 100) then
            user:removeMoney((100))
            TriggerClientEvent('es_freeroam:wanted', source)
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_LESTER", 1, "Lester", false, "Troubles in paradise are fixed")
        else
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_LESTER", 1, "Lester", false, "Sorry but you need more cash before i can help you")
        end
    end)
end)
