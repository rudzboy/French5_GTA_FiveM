--Version 1.3
require "resources/mysql-async/lib/MySQL"

--Intégration de la position dans MySQL
RegisterServerEvent("lastPosition:saveLastPosition")
AddEventHandler("lastPosition:saveLastPosition", function(LastPosX, LastPosY, LastPosZ, LastPosH)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        --Récupération du SteamID.
        local player = user.identifier
        --Formatage des données en JSON pour intégration dans MySQL.
        local lastPos = "{" .. LastPosX .. ", " .. LastPosY .. ",  " .. LastPosZ .. ", " .. LastPosH .. "}"
        --Exécution de la requêtes SQL.
        MySQL.Async.execute("UPDATE users SET `lastpos` = @lastpos WHERE identifier = @username", { ['@username'] = player, ['@lastpos'] = lastPos })
        TriggerClientEvent("showNotify", source, "Position ~g~sauvegardée~w~.")
    end)
end)


--Récupération de la position depuis MySQL
RegisterServerEvent("lastPosition:spawnPlayer")
AddEventHandler("lastPosition:spawnPlayer", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @username",
            { ['@username'] = user.identifier }, function(result)
                if (result) then
                    for _, v in ipairs(result) do
                        if v.lastpos ~= "" then
                            local ToSpawnPos = json.decode(v.lastpos)
                            local PosX = ToSpawnPos[1]
                            local PosY = ToSpawnPos[2]
                            local PosZ = ToSpawnPos[3]
                            -- local PosH = ToSpawnPos[4]
                            TriggerClientEvent("lastPosition:spawnLastPosition", source, PosX, PosY, PosZ)
                        end
                    end
                end
            end)
    end)
end)