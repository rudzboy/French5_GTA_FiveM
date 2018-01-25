-- Spawn override
AddEventHandler('onClientMapStart', function()
    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end)

-- Allows the server to spawn the player
RegisterNetEvent('es_freeroam:spawnPlayer')
AddEventHandler('es_freeroam:spawnPlayer', function(x, y, z)
    exports.spawnmanager:spawnPlayer({ x = x, y = y, z = z })
end)

AddEventHandler("playerSpawned", function(spawn)
    
    -- Send notifications
    Citizen.CreateThread(function()
        while true do
            Wait(0)

            SetNotificationTextEntry("STRING");
            AddTextComponentString("~y~Inscriptions Whitelist~w~, ~g~règlement~w~ et ~b~plus d\'infos~w~ sur ~w~french~g~5~w~.fr !");
            SetNotificationMessage("CHAR_ALL_PLAYERS_CONF", "CHAR_ALL_PLAYERS_CONF", true, 1, "GTA French5 RP", "v1.6.0");
            DrawNotification(false, true);
            Wait(10000000)
        end
    end)
    
end)

RegisterNetEvent("es_freeroam:wanted")
AddEventHandler("es_freeroam:wanted", function()
    Citizen.CreateThread(function()
        SetPlayerWantedLevel(PlayerId(), 0, 0)
        SetPlayerWantedLevelNow(PlayerId(), 0)
    end)
end)

-- Display text
RegisterNetEvent("es_freeroam:displaytext")
AddEventHandler("es_freeroam:displaytext", function(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end)

-- Display notification
RegisterNetEvent("es_freeroam:notify")
AddEventHandler("es_freeroam:notify", function(icon, type, sender, title, text)
    Citizen.CreateThread(function()
        Wait(1)
        SetNotificationTextEntry("STRING");
        AddTextComponentString(text);
        SetNotificationMessage(icon, icon, true, type, sender, title, text);
        DrawNotification(false, true);
    end)
end)
