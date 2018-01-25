require "resources/mysql-async/lib/MySQL"

local inServiceSecretAgents = {}

function addSecretAgent(identifier)
    MySQL.Async.execute("INSERT INTO secret_service (`identifier`) VALUES (@identifier)", { ['@identifier'] = identifier })
end

function remSecretAgent(identifier)
    MySQL.Async.execute("DELETE FROM secret_service WHERE identifier = @identifier", { ['@identifier'] = identifier })
end

function checkIsSecretAgent(identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM secret_service WHERE identifier = @identifier",
        { ['@identifier'] = identifier })
    if (not result[1]) then
        TriggerClientEvent('secret_service:receiveIsSecretAgent', source, "inconnu")
    else
        TriggerClientEvent('secret_service:receiveIsSecretAgent', source, result[1].rank)
    end
end

function s_checkIsSecretAgent(identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM secret_service WHERE identifier = @identifier",
        { ['@identifier'] = identifier })
    if (not result[1]) then
        return "nil"
    else
        return result[1].rank
    end
end

RegisterServerEvent('secret_service:targetCheckInventory')
AddEventHandler('secret_service:targetCheckInventory', function(target)
    TriggerClientEvent('showNotify', source, 'Inventaire de : ~b~' .. GetPlayerName(target))
    TriggerEvent("es:getPlayerFromId", target, function(player)
        MySQL.Async.fetchAll("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE user_id = @username",
            { ['@username'] = player.identifier }, function(result)
                if (result) then
                    for _, v in ipairs(result) do
                        if (tonumber(v.quantity) > 0) then
                            TriggerClientEvent('showNotify', source, v.libelle .. ' : ' .. v.quantity)
                        end
                    end
                end
            end)
    end)
end)

RegisterServerEvent('ssa:sendAlert')
AddEventHandler('ssa:sendAlert', function(message)
    for i,_ in ipairs(inServiceSecretAgents) do
        TriggerClientEvent('showNotify', i, message)
    end
end)

RegisterServerEvent('secret_service:targetDropIllegalItems')
AddEventHandler('secret_service:targetDropIllegalItems', function(target)
    TriggerClientEvent('showNotify', source, 'Suppression des objets illégaux de : ' .. GetPlayerName(target))
    TriggerClientEvent('secret_service:dropIllegalItems', source, target)
end)

RegisterServerEvent('secret_service:targetDropIllegalWeapons')
AddEventHandler('secret_service:targetDropIllegalWeapons', function(target)
    TriggerClientEvent('showNotify', source, 'Suppression des armes illégales de : ' .. GetPlayerName(target))
    TriggerClientEvent('secret_service:dropIllegalWeapons', target)
end)

AddEventHandler('playerDropped', function()
    if (inServiceSecretAgents[source]) then
        inServiceSecretAgents[source] = nil
        for i, _ in pairs(inServiceSecretAgents) do
            TriggerClientEvent("secret_service:resultAllSecretAgentsInService", i, inServiceSecretAgents)
        end
    end
end)

AddEventHandler('es:playerDropped', function(player)
    local isSecretAgent = s_checkIsSecretAgent(player.identifier)
    if (isSecretAgent ~= "nil") then
        TriggerEvent("jobssystem:disconnectReset", player, 3)
    end
end)

RegisterServerEvent('secret_service:checkIsSecretAgent')
AddEventHandler('secret_service:checkIsSecretAgent', function()
    TriggerEvent("es:getPlayerFromId", source, function(user)
        checkIsSecretAgent(user.identifier)
    end)
end)

RegisterServerEvent('secret_service:takeService')
AddEventHandler('secret_service:takeService', function()

    if (not inServiceSecretAgents[source]) then
        inServiceSecretAgents[source] = GetPlayerName(source)

        for i, _ in pairs(inServiceSecretAgents) do
            TriggerClientEvent("secret_service:resultAllSecretAgentsInService", i, inServiceSecretAgents)
        end
    end
end)

RegisterServerEvent('secret_service:breakService')
AddEventHandler('secret_service:breakService', function()

    if (inServiceSecretAgents[source]) then
        inServiceSecretAgents[source] = nil

        for i, _ in pairs(inServiceSecretAgents) do
            TriggerClientEvent("secret_service:resultAllSecretAgentsInService", i, inServiceSecretAgents)
        end
    end
end)

RegisterServerEvent('secret_service:getAllSecretAgentsInService')
AddEventHandler('secret_service:getAllSecretAgentsInService', function()
    TriggerClientEvent("secret_service:resultAllSecretAgentsInService", source, inServiceSecretAgents)
end)

RegisterServerEvent('secret_service:checkingPlate')
AddEventHandler('secret_service:checkingPlate', function(plate)
    MySQL.Async.fetchAll("SELECT Nom FROM user_vehicle JOIN users ON user_vehicle.identifier = users.identifier WHERE vehicle_plate = @plate",
        { ['@plate'] = plate }, function(result)
            if (result[1]) then
                for _, v in ipairs(result) do
                    TriggerClientEvent('showNotify', source, "Le véhicule #" .. plate .. " est la propriété de ~b~" .. v.Nom .. "~w~.")
                end
            else
                TriggerClientEvent('showNotify', source, "Le véhicule #" .. plate .. " est ~r~inconnu~w~ au fichier des ~b~immatriculations~w~.")
            end
        end)
end)

RegisterServerEvent('secret_service:confirmUnseat')
AddEventHandler('secret_service:confirmUnseat', function(t)
    --TriggerClientEvent('showNotify', source, GetPlayerName(t).. " est sorti du véhicule.")
    TriggerClientEvent('secret_service:unseatme', t)
end)

RegisterServerEvent('secret_service:cuffGranted')
AddEventHandler('secret_service:cuffGranted', function(t)
    --TriggerClientEvent('showNotify', source, GetPlayerName(t).. " menotté/démenotté !")
    TriggerClientEvent('secret_service:getArrested', t)
end)

RegisterServerEvent('secret_service:forceEnterAsk')
AddEventHandler('secret_service:forceEnterAsk', function(t, v)
    --TriggerClientEvent('showNotify', source, GetPlayerName(t).. " est forcé de rentrer dans le véhicule.")
    TriggerClientEvent('secret_service:forcedEnteringVeh', t, v)
end)

-----------------------------------------------------------------------
------------- COMMANDE ADMIN AJOUT / SUPP AGENT SECRET ----------------
-----------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'ssaadd', "admin", function(source, args, user)
    if (not args[2]) then
        TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Usage : /ssaadd [ID]")
    else
        if (GetPlayerName(tonumber(args[2])) ~= nil) then
            local player = tonumber(args[2])
            TriggerEvent("es:getPlayerFromId", player, function(target)
                addSecretAgent(target.identifier)
                TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Bien reçu !")
                TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Gouvernement", false, "~g~Félicitations ! Vous venez d'intégrer les services secrets !")
                TriggerClientEvent('secret_service:nowSecretAgent', player)
            end)
        else
            TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Aucun joueur avec cet ID !")
        end
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Vous n'avez pas la permission !")
end)

TriggerEvent('es:addGroupCommand', 'ssarem', "admin", function(source, args, user)
    if (not args[2]) then
        TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Usage : /ssarem [ID]")
    else
        if (GetPlayerName(tonumber(args[2])) ~= nil) then
            local player = tonumber(args[2])
            TriggerEvent("es:getPlayerFromId", player, function(target)
                remSecretAgent(target.identifier)
                TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Gouvernement", false, "~r~Vous ne faîtes maintenant plus partie des services secrets.")
                TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Bien reçu !")
                --TriggerClientEvent('chatMessage', player, 'GOVERNMENT', {255, 0, 0}, "You're no longer a Secret Agent !")
                TriggerClientEvent('secret_service:noLongerSecretAgent', player)
            end)
        else
            TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Aucun joueur avec cet ID !")
        end
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Vous n'avez pas la permission !")
end)