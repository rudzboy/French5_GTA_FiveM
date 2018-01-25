Citizen.CreateThread(function()
    while true do
        Wait(1)

        playerPed = GetPlayerPed(-1)

        if playerPed then
            playerCar = GetVehiclePedIsIn(playerPed, false)
            if playerCar and GetPedInVehicleSeat(playerCar, -1) == playerPed and not IsEntityDead(playerPed) then
                speedKmh = math.ceil(GetEntitySpeed(playerCar) * 3.6)
                engineHealth = GetVehicleEngineHealth(playerCar)
                tankHealth = GetVehiclePetrolTankHealth(playerCar)
                bodyHealth = GetVehicleBodyHealth(playerCar)

                SendNUIMessage({
                    showhud = true,
                    unit = "KM/H",
                    speed = speedKmh,
                    engine = engineHealth,
                    tank = tankHealth,
                    body = bodyHealth
                })
            else
                SendNUIMessage({ hidehud = true })
            end
        end
    end
end)