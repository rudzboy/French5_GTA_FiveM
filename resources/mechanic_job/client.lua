isMechanic = false
isInService = false

local currentPlayerJobId = false
local currentBlips = {}
local defaultJobId = 1
local requiredJobId = 14
local markerDistance = 30.0
local actionDistance = 3.0
local searchVehicleDistance = 5.0

local servicePosition = { x = -224.198, y = -1319.99, z = 29.890 }
local fullRepairPositions = {
    { x = -211.727, y = -1324.02, z = 30.8903 },
    { x = -205.63, y = -1324.07, z = 30.8903 },
}
local junkyardPosition = { x = -456.977, y = -1712.32, z = 18.6402 }

local vehicleDamageThreshold = 50

local repairAwayDamageThreshold = 30

local Keys = {
    ["K"] = 311 -- Check --
}

-- SERVICE ON/OFF THREAD --
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isMechanic == true then
            local playerPed = GetPlayerPed(-1)
            local playerPos = GetEntityCoords(playerPed, true)

            -- Service --
            if (Vdist(playerPos.x, playerPos.y, playerPos.z, servicePosition.x, servicePosition.y, servicePosition.z) < markerDistance) then

                DrawMarker(1, servicePosition.x, servicePosition.y, servicePosition.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0, 80, 0, 0, 0, 0)

                if (Vdist(playerPos.x, playerPos.y, playerPos.z, servicePosition.x, servicePosition.y, servicePosition.z) < actionDistance) then
                    if isInService == true then
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour quitter votre service.')
                        if (IsControlJustReleased(1, 51)) then
                            TriggerEvent('mechanic:setService', false)
                        end
                    else
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour prendre votre service.')
                        if (IsControlJustReleased(1, 51)) then
                            TriggerEvent('mechanic:setService', true)
                        end
                    end
                end
            end

            -- FullRepairZones --
            for _, fullRepairPosition in pairs(fullRepairPositions) do
                if isInService == true and (Vdist(playerPos.x, playerPos.y, playerPos.z, fullRepairPosition.x, fullRepairPosition.y, fullRepairPosition.z) < markerDistance) then
                    DrawMarker(1, fullRepairPosition.x, fullRepairPosition.y, fullRepairPosition.z - 1, 0, 0, 0, 0, 0, 0, 5.0001, 5.0001, 1.0001, 255, 30, 30, 35, 0, 0, 0, 0)
                end
            end

            -- JunkyardZone --
            if (Vdist(playerPos.x, playerPos.y, playerPos.z, junkyardPosition.x, junkyardPosition.y, junkyardPosition.z) < markerDistance) then
                DrawMarker(1, junkyardPosition.x, junkyardPosition.y, junkyardPosition.z - 1, 0, 0, 0, 0, 0, 0, 5.0001, 5.0001, 1.0001, 180, 75, 30, 60, 0, 0, 0, 0)
                if (Vdist(playerPos.x, playerPos.y, playerPos.z, junkyardPosition.x, junkyardPosition.y, junkyardPosition.z) < actionDistance) then
                    DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~r~détruire~w~ le ~b~véhicule~w~.')
                    if (IsControlJustReleased(1, 51)) then
                        if isInService == true then
                            TriggerEvent('mechanic:destroyCar')
                        else
                            SendNotification("Vous devez être ~y~en service~w~ pour ~r~détruire~w~ un ~b~véhicule~w~.")
                        end
                    end
                end
            end
        end
    end
end)

-- VEHICLE SET UNDRIVABLE WHEN DAMAGE RATIO UNDER THRESHOLD --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsUsing(ped)
            local healthRatio = GetVehicleHealthRatio(vehicle)

            -- SetPlayerVehicleDamageModifier(PlayerId(), 100) -- Seems to not work at the moment --
            if (healthRatio < vehicleDamageThreshold) then
                SetVehicleUndriveable(vehicle, 1)
                SendNotification("Le ~b~véhicule~w~ est ~r~trop endommagé~w~.\nContactez un ~y~dépanneur~w~.")
            end
        end
    end
end)

RegisterNetEvent('mechanic:destroyCar')
AddEventHandler('mechanic:destroyCar', function()
    local playerPed = GetPlayerPed(-1)
    if not IsPedInAnyVehicle(playerPed, true) then
        local pos = GetEntityCoords(playerPed)
        local entityWorld = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, searchVehicleDistance, 0.0)
        local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, playerPed, 0)
        local a, b, c, d, closestVehicle = GetRaycastResult(rayHandle)

        if closestVehicle ~= nil and DoesEntityExist(closestVehicle) then
            local closestVehiclePlate = GetVehicleNumberPlateText(closestVehicle)
            local closestVehicleModelName = GetDisplayNameFromVehicleModel(GetEntityModel(closestVehicle))
            SendNotification("~b~" .. string.lower(closestVehicleModelName):gsub("^%l", string.upper) .. "~w~ : ~y~" .. closestVehiclePlate)
            -- DeleteVehicle(closestVehicle) --
            SetEntityAsMissionEntity(closestVehicle, true, true)
            Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(closestVehicle))
            SendNotification("Le ~y~véhicule~w~ a été ~g~détruit~w~.")
        else
            SendNotification("~r~Aucun véhicule dans la zone.")
        end
    else
        SendNotification("~y~Quittez le véhicule.")
    end
end)

RegisterNetEvent('mechanic:checkClosestCar')
AddEventHandler('mechanic:checkClosestCar', function()
    -- searchVehicleDistance
    local playerPed = GetPlayerPed(-1)
    local pos = GetEntityCoords(playerPed)
    local entityWorld = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, searchVehicleDistance, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, playerPed, 0)
    local a, b, c, d, closestVehicle = GetRaycastResult(rayHandle)

    if closestVehicle ~= nil and DoesEntityExist(closestVehicle) then
        local closestVehiclePlate = GetVehicleNumberPlateText(closestVehicle)
        local closestVehicleModelName = GetDisplayNameFromVehicleModel(GetEntityModel(closestVehicle))
        if closestVehiclePlate ~= nil then
            SendNotification("~b~" .. string.lower(closestVehicleModelName):gsub("^%l", string.upper) .. "~w~ : ~y~" .. closestVehiclePlate)
        end
        if IsVehicleDamaged(closestVehicle) then
            SendNotification("Ce véhicule est ~y~endommagé~w~.")
            local overall = GetVehicleHealthRatio(closestVehicle)
            local engine = GetVehicleEngineHealth(closestVehicle)
            local tank = GetVehiclePetrolTankHealth(closestVehicle)
            local body = GetVehicleBodyHealth(closestVehicle)

            SendNotification("État global : ~y~" .. tostring(math.floor(overall)) .. "~w~/~y~100")
            SendNotification("Moteur : ~b~" .. tostring(math.floor(engine)) .. "~w~/~b~1000")
            SendNotification("Réservoir : ~b~" .. tostring(math.floor(tank)) .. "~w~/~b~1000")
            SendNotification("Carosserie : ~b~" .. tostring(math.floor(body)) .. "~w~/~b~1000")
            local repaired = false
            local inVehicleRange = true
            local canBeRepaired = true
            while canBeRepaired == true and inVehicleRange == true and not repaired and not IsEntityDead(playerPed) do
                Citizen.Wait(0)
                pos = GetEntityCoords(playerPed)
                if (GetDistanceBetweenCoords(pos, GetEntityCoords(closestVehicle), true) < searchVehicleDistance) then
                    DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour réparer le véhicule.')
                    if IsControlJustPressed(1, 38) then -- E or INPUT --

                        local closeToFullRepairPosition = false

                        repairAwayDamageThreshold = math.random(20, 80)

                        SendNotification("~b~Réparation~w~ en cours.")
                        SetEntityHeading(playerPed, GetEntityOppositeHeading(playerPed))
                        TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_VEHICLE_MECHANIC", 0, true)
                        Citizen.Wait(20000)
                        ClearPedTasks(playerPed)

                        for _, fullRepairPosition in pairs(fullRepairPositions) do
                            if (GetDistanceBetweenCoords(fullRepairPosition.x, fullRepairPosition.y, fullRepairPosition.z, GetEntityCoords(closestVehicle), true) < searchVehicleDistance and isInService == true) then
                                closeToFullRepairPosition = true
                            end
                        end

                        if (overall > repairAwayDamageThreshold) or closeToFullRepairPosition then
                            SetVehicleUndriveable(closestVehicle, 0)
                            SetVehicleFixed(closestVehicle)
                            repaired = true
                        else
                            SendNotification("Véhicule ~r~non réparable~w~ sur place.\nDoit être réparé au ~y~garage~w~.")
                            SetNewWaypoint(servicePosition.x, servicePosition.y)
                            canBeRepaired = false
                        end
                    end
                else
                    inVehicleRange = false
                end
            end
            if repaired == true then
                SendNotification("Le véhicule a été ~g~réparé~w~.")
            elseif inVehicleRange == false then
                SendNotification("Vous vous êtes ~y~trop éloigné~w~ du véhicule endommagé.")
            end
        else
            SendNotification("Le véhicule est ~b~intact~w~.")
        end
    else
        SendNotification("~r~Aucun véhicule à proximité.")
    end
end)

RegisterNetEvent('mechanic:receiveIsMechanic')
AddEventHandler('mechanic:receiveIsMechanic', function(result)
    if (result == true) then
        isMechanic = true
        local mechanicBlip = SetBlip(402, "Réparateur", 51, servicePosition.x, servicePosition.y, servicePosition.z, 1.5)
        local junkyardBlip = SetBlip(56, "Décharge", 51, junkyardPosition.x, junkyardPosition.y, junkyardPosition.z, 1.0)
        table.insert(currentBlips, mechanicBlip)
    else
        isMechanic = false
        ResetBlips()
        TriggerEvent('mechanic:isInService', false)
    end
end)

RegisterNetEvent('mechanic:setService')
AddEventHandler('mechanic:setService', function(value)
    isInService = value

    switchJobWeapons(isInService)

    if isInService == true then
        TriggerServerEvent('jobssystem:jobs', requiredJobId)
        TriggerEvent('lscustoms:grantAccess', true)
        SendNotification("Vous êtes maintenant en ~g~service~w~.")
        --SendNotification("Appuyez sur ~y~K~w~ pour ~b~diagnostiquer~w~ un véhicule, ~y~L~w~ pour préparer un ~b~remorquage~w~.")
        -- set mechanic skin --
        local playerPed = GetPlayerPed(-1)
        if (GetEntityModel(playerPed) == GetHashKey("mp_m_freemode_01")) then
            SetPedComponentVariation(playerPed, 3, 41, 0, 0)
            SetPedComponentVariation(playerPed, 4, 9, 7, 0)
            SetPedComponentVariation(playerPed, 6, 12, 6, 0)
            SetPedComponentVariation(playerPed, 11, 0, 1, 0)
            --SetPedPropIndex(playerPed, 0, 55, 1, 2)
        elseif (GetEntityModel(playerPed) == GetHashKey("mp_f_freemode_01")) then
            SetPedComponentVariation(playerPed, 6, 24, 0, 0)
            SetPedComponentVariation(playerPed, 4, 1, 6, 0)
            SetPedComponentVariation(playerPed, 3, 37, 0, 0)
            SetPedComponentVariation(playerPed, 11, 0, 2, 0)
            --SetPedPropIndex(playerPed, 0, 55, 1, 2)
        end
    else
        TriggerEvent('lscustoms:grantAccess', false)
        TriggerServerEvent("mm:otherspawn")
        SendNotification("Vous avez ~r~quitté~w~ votre service.")
        TriggerServerEvent('jobssystem:jobs', defaultJobId)
    end
end)

RegisterNetEvent('jobssystem:updateClientJob')
AddEventHandler('jobssystem:updateClientJob', function(jobId)
    currentPlayerJobId = jobId
    if currentPlayerJobId ~= requiredJobId then
        TriggerEvent('mechanic:isInService', false)
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('mechanic:checkIsMechanic')
end)

function ResetBlips()
    for _, blip in pairs(currentBlips) do
        RemoveBlip(blip)
    end
    currentBlips = {}
end

function switchJobWeapons(isInService)
    local playerPed = GetPlayerPed(-1)
    if isInService then
        RemoveAllPedWeapons(playerPed)
        Citizen.Wait(1)
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_FLASHLIGHT"), true, false)
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_HAMMER"), true, false)
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_CROWBAR"), true, false)
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_FIREEXTINGUISHER"), true, false)
    else
        RemoveAllPedWeapons(playerPed)
        TriggerServerEvent("weaponshop:GiveWeaponsToSelf")
        Citizen.Wait(1)
    end
end

function SetBlip(id, text, color, x, y, z, scale)
    local Blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(Blip, id)
    SetBlipColour(Blip, color)
    SetBlipAsShortRange(Blip, true)
    SetBlipAsShortRange(p0, p1)
    SetBlipScale(Blip, scale)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(Blip)
    return Blip
end

function SendNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function GetEntityOppositeHeading(entity)
    local startHeading = GetEntityHeading(entity)
    local endHeading = startHeading + 180
    if (endHeading > 359) then
        endHeading = endHeading - 360
    end
    return endHeading
end

function GetVehicleHealthRatio(vehicle)
    local vehiclehealth = GetEntityHealth(vehicle) - 100
    local maxhealth = GetEntityMaxHealth(vehicle) - 100
    return (vehiclehealth / maxhealth) * 100
end

function getIsInService()
    return isInService
end
