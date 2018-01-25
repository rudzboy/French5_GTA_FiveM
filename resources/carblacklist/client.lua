-- CONFIG --

-- Blacklisted vehicle models
local carblacklist = {
    "rhino",
    "barracks",
    "barracks2",
    "crusader",
    "lazer"
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(15)
        if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            local car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            local carModel = GetEntityModel(car)
            if isCarBlacklisted(carModel) then
                NetworkExplodeVehicle(car, true, false, 0)
                TriggerEvent("showNotify", "Il est ~r~interdit~w~ d\'utiliser ce ~b~véhicule~w~ !")
                DeleteBlacklistedVehicle(car)
            end
        end
    end
end)

function DeleteBlacklistedVehicle(entity)
    Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(entity))
end

function isCarBlacklisted(model)
    for _, blacklistedCar in pairs(carblacklist) do
        if model == GetHashKey(blacklistedCar) then
            return true
        end
    end

    return false
end