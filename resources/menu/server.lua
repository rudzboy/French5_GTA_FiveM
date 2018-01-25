require "resources/mysql-async/lib/MySQL"

-- CONFIG --

local services = {
    ["Police"] = 2,
    ["Taxi"] = 5,
    ["Ambulance"] = 11,
    ["Dépanneur"] = 14
}

-- END CONFIG --

RegisterServerEvent("menu:getConnectedPlayers")
AddEventHandler("menu:getConnectedPlayers", function()
    --[[
    TriggerEvent('es:getPlayers', function(p)
        TriggerClientEvent("menu:getConnectedPlayers", -1, getConnectedPlayers(p))
    end)
    ]]--
    TriggerClientEvent("showNotify", -1, "~g~" .. GetPlayerName(source) .. "~w~ a rejoint le serveur.")
end)

RegisterServerEvent("phone:giveMoney")
AddEventHandler("phone:giveMoney", function(amount)
end)

RegisterServerEvent("phone:sendMessage")
AddEventHandler("phone:sendMessage", function(message, receiver)
    -- DM to Players --
    TriggerEvent('es:getPlayers', function(p)
        for id, _ in pairs(p) do
            if tonumber(id) == tonumber(receiver) then
                TriggerClientEvent("showNotify", source, 'Message envoyé à ~y~' .. GetPlayerName(receiver))
                TriggerClientEvent("phone:receiveMessage", id, message, GetPlayerName(source))
            end
        end
    end)

    -- Services --
    for jobName, jobId in pairs(services) do
        if (tostring(receiver) == jobName) then
            local messageSent = false

            MySQL.Async.fetchAll("SELECT * FROM users WHERE job = @job",
                { ['@job'] = jobId }, function(result)

                    if (result) then
                        TriggerEvent('es:getPlayers', function(p)
                            for kp, vp in pairs(p) do
                                for kj, vj in pairs(result) do
                                    if (vj.identifier == vp.identifier) then
                                        TriggerEvent('es:getPlayerFromId', source, function(user)
                                            TriggerClientEvent("service:receiveMessage", tonumber(vp.source), message, source, GetPlayerName(source), user, jobId)
                                        end)
                                        messageSent = true
                                    end
                                end
                            end
                        end)
                    end

                    if messageSent ~= false then
                        TriggerClientEvent("showNotify", source, 'Message envoyé à ~b~' .. jobName .. '~w~.')
                    else
                        TriggerClientEvent("showNotify", source, 'Aucun personnel du service demandé ne peut répondre à votre demande.')
                    end
                end)
        end
    end
end)

RegisterServerEvent("service:handleMessage")
AddEventHandler("service:handleMessage", function(senderId, handled, jobId)
    local senderName = GetPlayerName(senderId)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE job = @job",
        { ['@job'] = jobId }, function(result)
            if (result) then
                TriggerEvent('es:getPlayers', function(p)
                    for kp, vp in pairs(p) do
                        for kj, vj in pairs(result) do
                            if (vj.identifier == vp.identifier and vp.source ~= source) then
                                if handled == true then
                                    TriggerClientEvent("showNotify", vp.source, "~g~" .. GetPlayerName(source) .. "~w~ a accepté l\'appel de ~b~" .. senderName .. '~w~.')
                                else
                                    TriggerClientEvent("showNotify", vp.source, "~r~" .. GetPlayerName(source) .. "~w~ a refusé l\'appel de ~b~" .. senderName .. '~w~.')
                                end
                            end
                        end
                    end
                end)
            end

            if (handled == true) then
                TriggerClientEvent("showNotify", senderId, "Un personnel du service demandé a ~g~accepté~w~ votre appel.")
            end
        end)
end)

AddEventHandler('playerDropped', function()
    --[[
    TriggerEvent('es:getPlayers', function(p)
        TriggerClientEvent("menu:getConnectedPlayers", -1, getConnectedPlayers(p))
    end)
    ]]--
    TriggerClientEvent("showNotify", -1, "~r~" .. GetPlayerName(source) .. "~w~ a quitté le serveur.")
end)

function getConnectedPlayers(p)
    local connectedPlayers = {}
    for id, _ in pairs(p) do
        if (GetPlayerName(id)) then
            t = { ["id"] = tonumber(id), ["name"] = GetPlayerName(id) }
            table.insert(connectedPlayers, t)
        end
    end
    return connectedPlayers
end

function tprint(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            tprint(v, indent + 1)
        else
            print(formatting .. v)
        end
    end
end