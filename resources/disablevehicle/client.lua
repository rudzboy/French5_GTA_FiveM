Citizen.CreateThread(function()
    while true do
        -- These natives has to be called every frame.
        SetVehicleDensityMultiplierThisFrame(1.0)
        SetPedDensityMultiplierThisFrame(1.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.8)
        SetParkedVehicleDensityMultiplierThisFrame(1.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)

        local playerPed = GetPlayerPed(-1)
        local pos = GetEntityCoords(playerPed)

        -- These natives do not have to be called everyframe. (So why is it ?)
        SetGarbageTrucks(0)
        SetRandomBoats(0)

        Citizen.Wait(1)
    end
end)

