--Version 1.3
RegisterNetEvent("lastPosition:spawnLastPosition")
RegisterNetEvent("lastPosition:spawnPlayer")

local firstspawn = 0
local loaded = false

Citizen.CreateThread(function()
    while true do
        --Durée entre chaque requêtes : 120000 = 120 secondes
        Citizen.Wait(120000)
        local LastPosX, LastPosY, LastPosZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
        TriggerServerEvent("lastPosition:saveLastPosition", LastPosX, LastPosY, LastPosZ, GetEntityHeading(GetPlayerPed(-1)))
    end
end)

AddEventHandler("lastPosition:spawnLastPosition", function(PosX, PosY, PosZ)
    if not loaded then
        SetEntityCoords(GetPlayerPed(-1), PosX, PosY, PosZ, 1, 0, 0, 1)
        loaded = true
    end
end)

AddEventHandler("lastPosition:spawnPlayer", function()
    TriggerServerEvent("lastPosition:spawnPlayer")
end)

AddEventHandler('playerSpawned', function(spawn)
    if firstspawn == 0 then
        TriggerServerEvent('es_em:respawnDeadPlayer')
        firstspawn = 1
    end
end)