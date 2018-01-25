isCop = false
isInService = false

Keys = {
    ["INPUT_CELLPHONE_LEFT"] = 174,
    ["INPUT_CELLPHONE_SELECT"] = 176,
    ["INPUT_SELECT_WEAPON"] = 37,
    ["INPUT_SELECT_NEXT_WEAPON"] = 16,
    ["INPUT_SELECT_PREV_WEAPON"] = 17,
    ["KEYBOARD_M"] = 244
}

local requiredJobId = 2
local defaultJobId = 1

local rank = "inconnu"
local checkpoints = {}
local existingVeh = nil
local handCuffed = false
local isAlreadyDead = false
local allServiceCops = {}
local blipsCops = {}

local takingService = {
    --{x=850.156677246094, y=-1283.92004394531, z=28.0047378540039},
    { x = 457.956909179688, y = -992.72314453125, z = 30.6895866394043 }
    --{x=1856.91320800781, y=3689.50073242188, z=34.2670783996582},
    --{x=-450.063201904297, y=6016.5751953125, z=31.7163734436035}
}

local armory = {
    { x = 451.7, y = -980.01, z = 30.6895866394043 }
}

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("police:checkIsCop")
end)

RegisterNetEvent('police:receiveIsCop')
AddEventHandler('police:receiveIsCop', function(result)
    if (result == "inconnu") then
        isCop = false
    else
        isCop = true
        rank = result
    end
end)

RegisterNetEvent('police:nowCop')
AddEventHandler('police:nowCop', function()
    isCop = true
end)

RegisterNetEvent('police:resultEmergencyRescue')
AddEventHandler('police:resultEmergencyRescue', function(ems_count)
    if (tonumber(ems_count) <= 0) then
        TriggerEvent('showNotify', "~r~Aucun médecin en service~w~.\nIntervention ~g~autorisée~w~.")
        TriggerEvent('ems:findDeadPlayers')
    else
        TriggerEvent('showNotify', "~b~"..ems_count.." ~w~médecin(s) en ~g~service~w~ actuellement.")
    end
end)

RegisterNetEvent('police:noLongerCop')
AddEventHandler('police:noLongerCop', function()
    isCop = false
    isInService = false

    local playerPed = GetPlayerPed(-1)

    TriggerServerEvent("mm:otherspawn")
    RemoveAllPedWeapons(playerPed)

    if (existingVeh ~= nil) then
        SetEntityAsMissionEntity(existingVeh, true, true)
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
        existingVeh = nil
    end

    ServiceOff()
end)

RegisterNetEvent('police:getArrested')
AddEventHandler('police:getArrested', function()
    if (isCop == false) then
        handCuffed = not handCuffed
        if (handCuffed) then
            TriggerEvent('showNotify', "Vous êtes maintenant ~r~menotté~w~.")
        else
            TriggerEvent('showNotify', "Vous n\'êtes ~g~plus menotté~w~.")
        end
    end
end)

RegisterNetEvent('police:payFines')
AddEventHandler('police:payFines', function(amount, reason)
    TriggerServerEvent('bank:withdrawAmende', amount)
    TriggerEvent('showNotify', "Vous avez payé $" .. amount .. " d\'amende pour : ~r~" .. reason .. "~w~.")
end)

RegisterNetEvent('police:dropIllegalItems')
AddEventHandler('police:dropIllegalItems', function(id)
    TriggerServerEvent("inventory:removeIllegalItems", tonumber(id))
end)

RegisterNetEvent('police:dropIllegalWeapons')
AddEventHandler('police:dropIllegalWeapons', function()
    RemoveAllPedWeapons(GetPlayerPed(-1))
    TriggerServerEvent("weaponshop:playerSpawned")
end)

RegisterNetEvent('police:unseatme')
AddEventHandler('police:unseatme', function()
    local ped = GetPlayerPed(-1)
    if IsPedInAnyVehicle(ped, true) then
        local vehicle = GetVehiclePedIsIn(ped, true)
        if IsEntityAVehicle(vehicle) then
            ClearPedTasksImmediately(ped)
            TaskLeaveVehicle(ped, vehicle, 0)
        end
    end
end)

RegisterNetEvent('police:forcedEnteringVeh')
AddEventHandler('police:forcedEnteringVeh', function(veh)
    if handCuffed then
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local entityWorld = GetOffsetFromEntityInWorldCoords(ped, 0.0, 20.0, 0.0)

        local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, ped, 0)
        local a, b, c, d, vehicle = GetRaycastResult(rayHandle)

        if vehicle ~= nil then
            local seat = 2
            local seatAvailable = false
            while seat >= 0 and not seatAvailable do
                if IsVehicleSeatFree(vehicle, seat) then
                    ClearPedTasksImmediately(ped)
                    TaskWarpPedIntoVehicle(ped, vehicle, seat)
                    seatAvailable = true
                else
                    seat = seat - 1
                end
            end
            if not seatAvailable then
                TriggerEvent('showNotify', "~r~Aucune place libre dans le véhicule.")
            end
        else
            TriggerEvent('showNotify', "~r~Aucun véhicule proche.")
        end
    end
end)

RegisterNetEvent('police:resultAllCopsInService')
AddEventHandler('police:resultAllCopsInService', function(array)
    allServiceCops = array
    enableCopBlips()
end)

function enableCopBlips()

    for k, existingBlip in pairs(blipsCops) do
        RemoveBlip(existingBlip)
    end
    blipsCops = {}

    local localIdCops = {}
    for id = 0, 64 do
        if (NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1)) then
            for i, c in pairs(allServiceCops) do
                if (i == GetPlayerServerId(id)) then
                    localIdCops[id] = c
                    break
                end
            end
        end
    end

    for id, c in pairs(localIdCops) do
        local ped = GetPlayerPed(id)
        local blip = GetBlipFromEntity(ped)

        if not DoesBlipExist(blip) then

            blip = AddBlipForEntity(ped)
            SetBlipSprite(blip, 1)
            Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
            HideNumberOnBlip(blip)
            SetBlipNameToPlayerName(blip, id)

            SetBlipScale(blip, 0.85)
            SetBlipAlpha(blip, 255)

            table.insert(blipsCops, blip)
        else

            blipSprite = GetBlipSprite(blip)

            HideNumberOnBlip(blip)
            if blipSprite ~= 1 then
                SetBlipSprite(blip, 1)
                Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
            end

            Citizen.Trace("Name : " .. GetPlayerName(id))
            SetBlipNameToPlayerName(blip, id)
            SetBlipScale(blip, 0.85)
            SetBlipAlpha(blip, 255)

            table.insert(blipsCops, blip)
        end
    end
end

function GetPlayers()
    local players = {}
    for i = 0, 64 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index, value in ipairs(players) do
        local target = GetPlayerPed(value)
        if (target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
            if (closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function getIsInService()
    return isInService
end

function isNearTakeService()
    for i = 1, #takingService do
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        local distance = GetDistanceBetweenCoords(takingService[i].x, takingService[i].y, takingService[i].z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if (distance < 30) then
            DrawMarker(1, takingService[i].x, takingService[i].y, takingService[i].z - 1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
        end
        if (distance < 2) then
            return true
        end
    end
end

function isNearArmory()
    for i = 1, #armory do
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        local distance = GetDistanceBetweenCoords(armory[i].x, armory[i].y, armory[i].z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if (distance < 30) then
            DrawMarker(1, armory[i].x, armory[i].y, armory[i].z - 1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
        end
        if (distance < 2) then
            return true
        end
    end
end

function ServiceOn()
    isInService = true
    TriggerServerEvent("jobssystem:jobs", requiredJobId)
    TriggerServerEvent("police:takeService")
end

function ServiceOff()
    isInService = false
    TriggerServerEvent("jobssystem:jobs", defaultJobId)
    TriggerServerEvent("police:breakService")
    TriggerServerEvent("mm:otherspawn")

    allServiceCops = {}

    for k, existingBlip in pairs(blipsCops) do
        RemoveBlip(existingBlip)
    end
    blipsCops = {}
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (isCop) then
            if (isNearTakeService()) then
                DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le ~b~Casier de police~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255) -- ~g~E~s~
                if IsControlJustPressed(1, 51) then
                    OpenMenuVest()
                end
            end
            if (isInService) then
                if (isNearArmory()) then
                    DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir l\'~b~Armurerie~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255) -- ~g~E~s~
                    if IsControlJustPressed(1, 51) then
                        OpenArmory()
                    end
                end
            end
        else
            if (handCuffed == true) then
                TriggerEvent("anim:play", 'mp_arresting', 'idle')
            end
        end
    end
end)


-- HANDSUP + handle CUFFED --

Citizen.CreateThread(function()
    local handsup = false
    while true do
        Citizen.Wait(0)
        local lPed = GetPlayerPed(-1)
        RequestAnimDict("random@mugging3")
        if not handcuffed and not IsPedInAnyVehicle(lPed) then
            if IsControlPressed(1, 323) then
                if DoesEntityExist(lPed) then
                    Citizen.CreateThread(function()
                        RequestAnimDict("random@mugging3")
                        while not HasAnimDictLoaded("random@mugging3") do
                            Citizen.Wait(100)
                        end

                        if not handsup then
                            handsup = true
                            TaskPlayAnim(lPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
                        end
                    end)
                end
            end
            if IsControlReleased(1, 323) then
                if DoesEntityExist(lPed) then
                    Citizen.CreateThread(function()
                        RequestAnimDict("random@mugging3")
                        while not HasAnimDictLoaded("random@mugging3") do
                            Citizen.Wait(100)
                        end

                        if handsup then
                            handsup = false
                            ClearPedSecondaryTask(lPed)
                        end
                    end)
                end
            end
        elseif handcuffed then
            -- Disable Menu opening when handcuffed
            DisableControlAction(0, Keys["KEYBOARD_M"], true)
            DisableControlAction(0, Keys["INPUT_CELLPHONE_LEFT"], true)
            DisableControlAction(0, Keys["INPUT_CELLPHONE_SELECT"], true)
            DisableControlAction(0, Keys["INPUT_SELECT_WEAPON"], true)
            DisableControlAction(0, Keys["INPUT_SELECT_NEXT_WEAPON"], true)
            DisableControlAction(0, Keys["INPUT_SELECT_PREV_WEAPON"], true)
        end
    end
end)