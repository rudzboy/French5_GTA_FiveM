function LocalPed()
    return GetPlayerPed(-1)
end

function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

RegisterNetEvent("notworked")
AddEventHandler("notworked", function()


    SetNotificationTextEntry("STRING");
    AddTextComponentString("~r~Vous n'êtes pas autorisé");
    DrawNotification(false, true);
end)

RegisterNetEvent("weazelworked")
AddEventHandler("weazelworked", function()


    SetNotificationTextEntry("STRING");
    AddTextComponentString("~g~Camionette Weazel News sortie");
    DrawNotification(false, true);
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        DrawMarker(1, -544.088, -890.863, 23.889, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)

        if GetDistanceBetweenCoords(-544.088, -890.863, 23.889, GetEntityCoords(LocalPed())) < 1 then

            ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour sortir une ~b~Camionette', 0)

            if IsControlJustPressed(1, 38) then

                TriggerServerEvent("cp:weazelspawncheck")
            end
        end
    end
end)

RegisterNetEvent('weazelspawn')
AddEventHandler('weazelspawn', function()
    local myPed = GetPlayerPed(-1)
    local player = PlayerId()
    local vehicle = GetHashKey('rumpo')
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
        Wait(1)
    end
    local plate = math.random(100, 900)
    local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 0.0, 0)
    local spawned_car = CreateVehicle(vehicle, coords, -544.088, -890.863, 23.889, true, false)
    SetVehicleOnGroundProperly(spawned_car)
    SetVehicleNumberPlateText(spawned_car, "WZL " .. plate .. " ")
    SetPedIntoVehicle(myPed, spawned_car, -1)
    SetModelAsNoLongerNeeded(vehicle)
    Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(spawned_car))
end)
