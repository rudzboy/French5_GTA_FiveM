require "resources/mysql-async/lib/MySQL"

local inServiceCops = {}

function addCop(identifier)
    MySQL.Async.execute("INSERT INTO police (`identifier`) VALUES (@identifier)", { ['@identifier'] = identifier })
end

function remCop(identifier)
    MySQL.Async.execute("DELETE FROM police WHERE identifier = @identifier", { ['@identifier'] = identifier })
end

function checkIsCop(identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM police WHERE identifier = @identifier",
        { ['@identifier'] = identifier })
    if (not result[1]) then
        TriggerClientEvent('police:receiveIsCop', source, "inconnu")
    else
        TriggerClientEvent('police:receiveIsCop', source, result[1].rank)
    end
end

function s_checkIsCop(identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM police WHERE identifier = @identifier",
        { ['@identifier'] = identifier })
    if (not result[1]) then
        return "nil"
    else
        return result[1].rank
    end
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

RegisterServerEvent('police:targetCheckInventory')
AddEventHandler('police:targetCheckInventory', function(target)
    TriggerClientEvent('showNotify', source, 'Inventaire de : ~b~' .. GetPlayerName(target))
    TriggerEvent("es:getPlayerFromId", target, function(player)
        MySQL.Async.fetchAll("SELECT * FROM `user_inventory` JOIN items ON items.id = user_inventory.item_id WHERE user_id = @username",
        {['@username'] = player.identifier}, function(result)
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

RegisterServerEvent('police:sendAlert')
AddEventHandler('police:sendAlert', function(message)
    for i,_ in ipairs(inServiceCops) do
        TriggerClientEvent('showNotify', i, message)
    end
end)

RegisterServerEvent('police:targetDropIllegalItems')
AddEventHandler('police:targetDropIllegalItems', function(target)
    TriggerClientEvent('showNotify', source, 'Suppression des objets illégaux de : ' .. GetPlayerName(target))
    TriggerClientEvent('police:dropIllegalItems', source, target)
end)

RegisterServerEvent('police:targetDropIllegalWeapons')
AddEventHandler('police:targetDropIllegalWeapons', function(target)
    TriggerClientEvent('showNotify', source, 'Suppression des armes illégales de : ' .. GetPlayerName(target))
    TriggerClientEvent('police:dropIllegalWeapons', target)
end)

RegisterServerEvent('police:cancelDrivingLicence')
AddEventHandler('police:cancelDrivingLicence', function(target)
    TriggerClientEvent('showNotify', source, '~r~Retrait~w~ du ~y~permis de conduire~w~ de ~b~' .. GetPlayerName(target) .. "~w~.")
    TriggerClientEvent("licences:setDriverLicense", target, 0)
    TriggerClientEvent('showNotify', target, 'Votre ~y~permis de conduire~w~ vous a été ~r~retiré~w~.')
end)

AddEventHandler('playerDropped', function()
    if (inServiceCops[source]) then
        inServiceCops[source] = nil

        for i, _ in pairs(inServiceCops) do
            TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
            TriggerClientEvent("ssa:resultAllCopsInService", i, inServiceCops)
        end
    end
end)

AddEventHandler('es:playerDropped', function(player)
    local isCop = s_checkIsCop(player.identifier)
    if (isCop ~= "nil") then
        TriggerEvent("jobssystem:disconnectReset", player, 3)
    end
end)

RegisterServerEvent('police:checkIsCop')
AddEventHandler('police:checkIsCop', function()
    TriggerEvent("es:getPlayerFromId", source, function(user)
        checkIsCop(user.identifier)
    end)
end)

RegisterServerEvent('police:takeService')
AddEventHandler('police:takeService', function()

    if (not inServiceCops[source]) then
        inServiceCops[source] = GetPlayerName(source)

        for i, _ in pairs(inServiceCops) do
            TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
            TriggerClientEvent("ssa:resultAllCopsInService", i, inServiceCops)
        end
    end
end)

RegisterServerEvent('police:breakService')
AddEventHandler('police:breakService', function()

    if (inServiceCops[source]) then
        inServiceCops[source] = nil

        for i, _ in pairs(inServiceCops) do
            TriggerClientEvent("police:resultAllCopsInService", i, inServiceCops)
            TriggerClientEvent("ssa:resultAllCopsInService", i, inServiceCops)
        end
    end
end)

RegisterServerEvent('police:getAllCopsInService')
AddEventHandler('police:getAllCopsInService', function()
    TriggerClientEvent("police:resultAllCopsInService", source, inServiceCops)
    TriggerClientEvent("ssa:resultAllCopsInService", source, inServiceCops)
end)

RegisterServerEvent('police:checkingPlate')
AddEventHandler('police:checkingPlate', function(plate)
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

RegisterServerEvent('police:confirmUnseat')
AddEventHandler('police:confirmUnseat', function(t)
    --TriggerClientEvent('showNotify', source, GetPlayerName(t).. " est sorti du véhicule.")
    TriggerClientEvent('police:unseatme', t)
end)

RegisterServerEvent('police:finesGranted')
AddEventHandler('police:finesGranted', function(t, amount, reason)
    TriggerClientEvent('showNotify', source, GetPlayerName(t) .. " a payé $" .. amount .. " pour : ~r~" .. reason .. "~w~.")
    TriggerClientEvent('police:payFines', t, amount, reason)
end)

RegisterServerEvent('police:cuffGranted')
AddEventHandler('police:cuffGranted', function(t)
    --TriggerClientEvent('showNotify', source, GetPlayerName(t).. " menotté/démenotté !")
    TriggerClientEvent('police:getArrested', t)
end)

RegisterServerEvent('police:forceEnterAsk')
AddEventHandler('police:forceEnterAsk', function(t, v)
    --TriggerClientEvent('showNotify', source, GetPlayerName(t).. " est forcé de rentrer dans le véhicule.")
    TriggerClientEvent('police:forcedEnteringVeh', t, v)
end)

---------------------------- ROBBERIES -------------------------------

RegisterServerEvent('police:isBankRobbable')
AddEventHandler('police:isBankRobbable', function(location)
    TriggerClientEvent('es_bank:isrobbingpossible', source, location, tablelength(inServiceCops))
end)

RegisterServerEvent('police:isShopRobbable')
AddEventHandler('police:isShopRobbable', function(location)
    TriggerClientEvent('es_holdup:isrobbingpossible', source, location, tablelength(inServiceCops))
end)

-----------------------------------------------------------------------
--------------------- COMMANDE ADMIN AJOUT / SUPP COP-------------------
-----------------------------------------------------------------------
TriggerEvent('es:addGroupCommand', 'copadd', "admin", function(source, args, user)
    if (not args[2]) then
        TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Usage : /copadd [ID]")
    else
        if (GetPlayerName(tonumber(args[2])) ~= nil) then
            local player = tonumber(args[2])
            TriggerEvent("es:getPlayerFromId", player, function(target)
                addCop(target.identifier)
                TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Bien reçu !")
                TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Gouvernement", false, "~g~Félicitations ! Vous venez d'intégrer le LSPD.")
                TriggerClientEvent('police:nowCop', player)
            end)
        else
            TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Aucun joueur avec cet ID !")
        end
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Vous n'avez pas la permission !")
end)

TriggerEvent('es:addGroupCommand', 'coprem', "admin", function(source, args, user)
    if (not args[2]) then
        TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Usage : /coprem [ID]")
    else
        if (GetPlayerName(tonumber(args[2])) ~= nil) then
            local player = tonumber(args[2])
            TriggerEvent("es:getPlayerFromId", player, function(target)
                remCop(target.identifier)
                TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Gouvernement", false, "~r~Vous ne faîtes maintenant plus partie du LSPD.")
                TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Roger that !")
                --TriggerClientEvent('chatMessage', player, 'GOVERNMENT', {255, 0, 0}, "You're no longer a cop !")
                TriggerClientEvent('police:noLongerCop', player)
            end)
        else
            TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Aucun joueur avec cet ID !")
        end
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, 'Gouvernement', { 255, 0, 0 }, "Vous n'avez pas la permission !")
end)