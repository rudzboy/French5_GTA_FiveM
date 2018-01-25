local propslist = {}
local propsLimitPerPlayer = 10

RegisterNetEvent('props:spawnObject')
AddEventHandler('props:spawnObject', function(model)
    if(#propslist < propsLimitPerPlayer) then
        Citizen.CreateThread(function()
            local prophash = GetHashKey(model)
            RequestModel(prophash)
            while not HasModelLoaded(prophash) do
                Citizen.Wait(0)
            end
            local offset = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 0.75, 0.0)
            local _, worldZ = GetGroundZFor_3dCoord(offset.x, offset.y, offset.z)
            local propsobj = CreateObjectNoOffset(prophash, offset.x, offset.y, worldZ, true, true, true)
            local heading = GetEntityHeading(GetPlayerPed(-1))
            SetEntityHeading(propsobj, heading)
            SetModelAsNoLongerNeeded(prophash)
            SetEntityAsMissionEntity(propsobj)
            propslist[#propslist+1] = ObjToNet(propsobj)
        end)
    end
end)

RegisterNetEvent('props:removeLastSpawnedObject')
AddEventHandler('props:removeLastSpawnedObject', function()
    DeleteObject(NetToObj(propslist[#propslist]))
    propslist[#propslist] = nil
end)

RegisterNetEvent('props:removeAllSpawnedObjects')
AddEventHandler('props:removeAllSpawnedObjects', function()
    for i, props in pairs(propslist) do
        DeleteObject(NetToObj(props))
        propslist[i] = nil
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        for _, props in pairs(propslist) do
            local ox, oy, oz = table.unpack(GetEntityCoords(NetToObj(props), true))
            local cVeh = GetClosestVehicle(ox, oy, oz, 20.0, 0, 70)
            if(IsEntityAVehicle(cVeh)) then
                if IsEntityAtEntity(cVeh, NetToObj(props), 20.0, 20.0, 2.0, 0, 1, 0) then
                    local cDriver = GetPedInVehicleSeat(cVeh, -1)
                    TaskVehicleTempAction(cDriver, cVeh, 6, 1000)
                    SetVehicleHandbrake(cVeh, true)
                    SetVehicleIndicatorLights(cVeh, 0, true)
                    SetVehicleIndicatorLights(cVeh, 1, true)
                end
            end
        end
    end
end)