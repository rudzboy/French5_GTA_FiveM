require "resources/mysql-async/lib/MySQL"

local jobsNames = {}
local result = MySQL.Sync.fetchAll("SELECT * FROM `jobs`", {})
if (result) then
    for _, v in ipairs(result) do
        table.insert(jobsNames, tonumber(v.job_id), tostring(v.job_name))
    end
end

function GetPlayerJobId(identifier)
    return tonumber(MySQL.Sync.fetchScalar("SELECT `job` FROM users WHERE `identifier` = @identifier",
        { ['@identifier'] = identifier }))
end

function SetPlayerJobId(player, job_id)
    MySQL.Async.execute("UPDATE `users` SET `job` = @value WHERE `identifier` = @identifier",
        { ['@value'] = job_id, ['@identifier'] = player })
end

RegisterServerEvent('jobssystem:jobs')
AddEventHandler('jobssystem:jobs', function(id)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        SetPlayerJobId(user.identifier, id)
        TriggerClientEvent("showNotify", source, "Votre métier est maintenant : ~y~" .. jobsNames[id])
        TriggerClientEvent("jobssystem:updateClientJob", source, id)
    end)
end)

RegisterServerEvent('jobssystem:getPlayerJobId')
AddEventHandler('jobssystem:getPlayerJobId', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local id = GetPlayerJobId(user.identifier)
        TriggerClientEvent("jobssystem:updateClientJob", source, id)
    end)
end)
