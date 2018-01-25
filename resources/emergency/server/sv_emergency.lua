require "resources/mysql-async/lib/MySQL"

local inServiceMedics = {}

--ADD EMS job from admin
function addEMS(identifier)
    MySQL.Async.execute("INSERT INTO ems (`identifier`) VALUES (@identifier)", { ['@identifier'] = identifier })
end

function remEMS(identifier)
    MySQL.Async.execute("DELETE FROM ems WHERE identifier = @identifier", { ['@identifier'] = identifier })
end

function checkIsEMS(identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM ems WHERE identifier = @identifier",
        { ['@identifier'] = identifier })
    if (not result[1]) then
        TriggerClientEvent('ems:receiveIsEMS', source, "inconnu")
    else
        TriggerClientEvent('ems:receiveIsEMS', source, result[1].rank)
    end
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function setPlayerDead(player, value)
    MySQL.Sync.execute("UPDATE users SET `is_dead` = @value WHERE identifier = @identifier", { ['@value'] = value, ['@identifier'] = player })
end

function isPlayerDead(player)
    return tonumber(MySQL.Sync.fetchScalar("SELECT `is_dead` FROM users WHERE identifier = @identifier",
        { ['@value'] = value, ['@identifier'] = player }))
end

RegisterServerEvent('ems:checkIsEMS')
AddEventHandler('ems:checkIsEMS', function()
    TriggerEvent("es:getPlayerFromId", source, function(user)
        checkIsEMS(user.identifier)
    end)
end)

RegisterServerEvent('ems:findInjuredPlayers')
AddEventHandler('ems:findInjuredPlayers', function()
    TriggerClientEvent("es_em:isPlayedInjured", -1, source)
end)

RegisterServerEvent('ems:findDeadPlayers')
AddEventHandler('ems:findDeadPlayers', function()
    TriggerClientEvent("es_em:isPlayedDead", -1, source)
end)

RegisterServerEvent('ems:announceDead')
AddEventHandler('ems:announceDead', function(x, y, z, emsPlayerId)
    TriggerClientEvent('ems:canSaveDead', emsPlayerId, source, x, y, z)
end)

RegisterServerEvent('ems:announceInjured')
AddEventHandler('ems:announceInjured', function(x, y, z, emsPlayerId)
    TriggerClientEvent('ems:canSaveInjured', emsPlayerId, source, x, y, z)
end)

RegisterServerEvent('es_em:sv_resurectPlayer')
AddEventHandler('es_em:sv_resurectPlayer', function(sourcePlayerInComa)
    TriggerClientEvent('es_em:cl_resurectPlayer', sourcePlayerInComa)
end)

RegisterServerEvent('es_em:sv_healPlayer')
AddEventHandler('es_em:sv_healPlayer', function(healedPlayerId)
    TriggerClientEvent('es_em:cl_healPlayer', healedPlayerId)
    TriggerClientEvent('showNotify', source, 'Le citoyen a été ~g~soigné~w~.')
end)

RegisterServerEvent('es_em:setPlayerIsDead')
AddEventHandler('es_em:setPlayerIsDead', function(value)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        setPlayerDead(user.identifier, value)
    end)
end)

RegisterServerEvent('es_em:respawnDeadPlayer')
AddEventHandler('es_em:respawnDeadPlayer', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local playerIsDead = isPlayerDead(user.identifier)
        if playerIsDead == 1 then
            TriggerClientEvent('es_em:cl_respawn', source)
            TriggerClientEvent('showNotify', source, 'Vous avez été retrouvé ~b~inconscient~w~ puis transporté à l\'~y~hôpital~w~.')
        else
            TriggerClientEvent("lastPosition:spawnPlayer", source)
        end
    end)
end)

RegisterServerEvent('es_em:sv_getJobId')
AddEventHandler('es_em:sv_getJobId', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local job_id = 1
        local result = MySQL.Sync.fetchAll("SELECT job_id FROM users LEFT JOIN jobs ON jobs.job_id = users.job WHERE users.identifier = @identifier AND job_id IS NOT NULL",
            { ['@identifier'] = user.identifier })
        if (result[1] ~= nil) then
            job_id = result[1].job_id
        end
        TriggerClientEvent('es_em:cl_setJobId', source, job_id)
    end)
end)

RegisterServerEvent('es_em:sv_removeMoney')
AddEventHandler('es_em:sv_removeMoney', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        if (user) then
            if user.money > 0 then
                user:setMoney(0)
            end
        end
    end)
end)

RegisterServerEvent('es_em:sv_setService')
AddEventHandler('es_em:sv_setService', function(service)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        MySQL.Async.execute("UPDATE users SET enService = @service WHERE users.identifier = @identifier",
            { ['@identifier'] = user.identifier, ['@service'] = service })
        TriggerClientEvent('ems:receiveService', source, service)
    end)

    if service == true then
        if (not inServiceMedics[source]) then
            inServiceMedics[source] = GetPlayerName(source)
        end
    else
        if (inServiceMedics[source]) then
            inServiceMedics[source] = nil
        end
    end
    for i, _ in pairs(inServiceMedics) do
        TriggerClientEvent("ems:resultAllMedicsInService", i, inServiceMedics)
    end
end)

RegisterServerEvent('ems:getAllMedicsInService')
AddEventHandler('ems:getAllMedicsInService', function()
    TriggerClientEvent("ems:resultAllMedicsInService", source, inServiceMedics)
end)

RegisterServerEvent('ems:allowEmergencyRescue')
AddEventHandler('ems:allowEmergencyRescue', function()
    TriggerClientEvent('police:resultEmergencyRescue', source, tablelength(inServiceMedics))
end)

AddEventHandler('playerDropped', function()

    if (inServiceMedics[source]) then
        inServiceMedics[source] = nil

        for i, _ in pairs(inServiceMedics) do
            TriggerClientEvent("ems:resultAllMedicsInService", i, inServiceMedics)
        end
    end

    TriggerEvent('es:getPlayerFromId', source, function(user)
        if user ~= nil then
            MySQL.Async.execute("UPDATE users SET enService = 0 WHERE users.identifier = @identifier", { ['@identifier'] = user.identifier })
        end
    end)
end)

--ADD EMS job from admin

-- Admin CMD
--
--

TriggerEvent('es:addGroupCommand', 'emsadd', "admin", function(source, args, user)
    if (not args[2]) then
        TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Usage : /emsadd [ID]")
    else
        if (GetPlayerName(tonumber(args[2])) ~= nil) then
            local player = tonumber(args[2])
            TriggerEvent("es:getPlayerFromId", player, function(target)
                addEMS(target.identifier)
                TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Bien reçu !")
                TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Gouvernement", false, "~g~Félicitations ! Vous venez d'intégrer les services de secours.")
                TriggerClientEvent('ems:nowEMS', player)
            end)
        else
            TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Aucun joueur avec cet ID !")
        end
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Vous n'avez pas la permission !")
end)

TriggerEvent('es:addGroupCommand', 'emsrem', "admin", function(source, args, user)
    if (not args[2]) then
        TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Usage : /emsrem [ID]")
    else
        if (GetPlayerName(tonumber(args[2])) ~= nil) then
            local player = tonumber(args[2])
            TriggerEvent("es:getPlayerFromId", player, function(target)
                remEMS(target.identifier)
                TriggerClientEvent("es_freeroam:notify", player, "CHAR_ANDREAS", 1, "Gouvernement", false, "~r~Vous ne faîtes plus partie des services de secours.")
                TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Bien reçu !")
                TriggerClientEvent('ems:noLongerEMS', player)
            end)
        else
            TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Aucun joueur avec cet ID !")
        end
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, 'GOVERNMENT', { 255, 0, 0 }, "Vous n'avez pas la permission !")
end)