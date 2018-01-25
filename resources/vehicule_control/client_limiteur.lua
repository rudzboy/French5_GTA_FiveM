local limiteur = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local vehicleModel = GetEntityModel(vehicle)
        local speed = GetEntitySpeed(vehicle)
        local Max = GetVehicleMaxSpeed(vehicleModel)

        if (ped) then
            -- Pour éviter d'activer les messages à l'arrêt en voiture
            if (IsControlJustPressed(1, 73) and speed > 1) then
                local inVehicle = IsPedSittingInAnyVehicle(ped)
                if inVehicle and (IsThisModelACar(vehicleModel) or IsThisModelABike(vehicleModel)) then
                    if (GetPedInVehicleSeat(vehicle, -1) == ped) then
                        if limiteur == false then
                            SetEntityMaxSpeed(vehicle, speed)
                            TriggerEvent("showNotify", "Limiteur de vitesse ~g~activé~w~.")
                            limiteur = true
                        else
                            SetEntityMaxSpeed(vehicle, Max)
                            TriggerEvent("showNotify", "Limiteur de vitesse ~r~désactivé~w~.")
                            limiteur = false
                        end
                    end
                end
            end
        end
    end
end)
















