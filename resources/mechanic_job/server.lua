require "resources/mysql-async/lib/MySQL"

-- FUNCTIONS --

function addMechanic(identifier, player)
    MySQL.Async.execute("INSERT INTO mechanic (`identifier`) VALUES (@identifier)", { ['@identifier'] = identifier })
    TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Gouvernement", false, "~g~Félicitations ! Vous venez d'intégrer l'équipe de mécanicien/dépanneur.")
    TriggerClientEvent('mechanic:receiveIsMechanic', player, true)
end

function remMechanic(identifier, player)
    MySQL.Async.execute("DELETE FROM mechanic WHERE identifier = @identifier", { ['@identifier'] = identifier })
    TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Gouvernement", false, "~r~Vous ne faîtes plus partie de l'équipe de mécanicien/dépanneur.")
    TriggerClientEvent('mechanic:receiveIsMechanic', player, false)
end

function checkIsMechanic(identifier, player)
    MySQL.Async.fetchAll("SELECT * FROM mechanic WHERE identifier = @identifier",
        { ['@identifier'] = identifier }, function(result)
            if (not result[1]) then
                TriggerClientEvent('mechanic:receiveIsMechanic', player, false)
            else
                TriggerClientEvent('mechanic:receiveIsMechanic', player, true)
            end
        end)
end

-- EVENTS --

RegisterServerEvent('mechanic:checkIsMechanic')
AddEventHandler('mechanic:checkIsMechanic', function()
    TriggerEvent("es:getPlayerFromId", source, function(user)
        local identifier = user.identifier
        checkIsMechanic(identifier, source)
    end)
end)

-- COMMANDS --

TriggerEvent('es:addGroupCommand', 'mechadd', "admin", function(source, args, user)
    if (not args[2]) then
        TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Usage : /mechadd [ID]")
    else
        if (GetPlayerName(tonumber(args[2])) ~= nil) then
            local player = tonumber(args[2])
            TriggerEvent("es:getPlayerFromId", player, function(target)
                addMechanic(target.identifier, player)
                TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Bien reçu !")
            end)
        else
            TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Aucun joueur avec cet ID !")
        end
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Vous n'avez pas la permission !")
end)

TriggerEvent('es:addGroupCommand', 'mechrem', "admin", function(source, args, user)
    if (not args[2]) then
        TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Usage : /mechrem [ID]")
    else
        if (GetPlayerName(tonumber(args[2])) ~= nil) then
            local player = tonumber(args[2])
            TriggerEvent("es:getPlayerFromId", player, function(target)
                remMechanic(target.identifier, player)
                TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Bien reçu !")
            end)
        else
            TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Aucun joueur avec cet ID !")
        end
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Vous n'avez pas la permission !")
end)