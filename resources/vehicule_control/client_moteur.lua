local engine = true

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local vehicleModel = GetEntityModel(vehicle)

        if ped then
            if IsThisModelACar(vehicleModel) or IsThisModelABike(vehicleModel) then
                -- INPUT_CELLPHONE_RIGHT --
                if IsControlJustPressed(1, 175) then
                    if IsPedSittingInAnyVehicle(ped) then
                        if (GetPedInVehicleSeat(vehicle, -1) == ped) then
                            if engine == true then
                                SetVehicleEngineOn(vehicle, false, false)
                                SetVehicleUndriveable(vehicle, true)
                                TriggerEvent("showNotify", "Moteur ~r~arrêté~w~.")
                                engine = false
                            else
                                SetVehicleUndriveable(vehicle, false)
                                SetVehicleEngineOn(vehicle, true, false)
                                TriggerEvent("showNotify", "Moteur ~g~allumé~w~.")
                                engine = true
                            end
                        end
                    end
                end
            end
        end
    end
end)