--DO-NOT-EDIT-BELLOW-THIS-LINE--

vehicleWashStation = {
    { 26.5906, -1392.0261, 27.3634 },
    { 167.1034, -1719.4704, 27.2916 },
    { -74.5693, 6427.8715, 29.4400 },
    { -699.6325, -932.7043, 17.0139 }
}

Citizen.CreateThread(function()
    Citizen.Wait(0)
    for i = 1, #vehicleWashStation do
        local station = vehicleWashStation[i]
        stationBlip = AddBlipForCoord(station[1], station[2], station[3])
        SetBlipSprite(stationBlip, 100) -- 100 = carwash
        SetBlipAsShortRange(stationBlip, true)
    end
    return
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
            for i = 1, #vehicleWashStation do
                local station = vehicleWashStation[i]
                DrawMarker(1, station[1], station[2], station[3], 0, 0, 0, 0, 0, 0, 5.0, 5.0, 2.0, 0, 157, 0, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), station[1], station[2], station[3], true) < 5 then
                    DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour nettoyer votre véhicule.")
                    if (IsControlJustPressed(1, 38)) then
                        TriggerServerEvent('carwash:checkmoney')
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('carwash:success')
AddEventHandler('carwash:success', function(price)
    SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
    SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
    msg = "Votre véhicule est ~g~propre ~w~! - $~g~" .. price .. "~w~"
    ShowNotification(msg, 5000)
    Wait(5000)
end)

RegisterNetEvent('carwash:notenoughmoney')
AddEventHandler('carwash:notenoughmoney', function(moneyleft)
    msg = "~r~Vous n\'avez pas assez d\'argent !"
    ShowNotification(msg, 5000)
    Wait(5000)
end)

RegisterNetEvent('carwash:free')
AddEventHandler('carwash:free', function()
    SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
    SetVehicleUndriveable(GetVehiclePedIsUsing(GetPlayerPed(-1)), false)
    msg = "Le nettoyage est ~g~gratuit~w~ !"
    ShowNotification(msg, 5000)
    Wait(5000)
end)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, false)
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end