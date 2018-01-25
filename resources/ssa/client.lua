isSecretAgent = false
isInService = false

local requiredJobId = 15
local defaultJobId = 1

local rank = "inconnu"
local checkpoints = {}
local existingVeh = nil
local handCuffed = false
local isAlreadyDead = false
local allServiceSecretAgents = {}
local blipsSecretAgents = {}
local allServiceCops = {}
local blipsCops = {}
local secretServicesBlip = false

local takingService = {
    { x = 135.898, y = -749.355, z = 258.152 }
}

local armory = {
    { x = 151.746, y = -760.687, z = 258.152 }
}

local blipPosition = { x = 135.898, y = -749.355, z = 258.152 }

AddEventHandler("playerSpawned", function()
    TriggerServerEvent("secret_service:checkIsSecretAgent")
end)

--[[
AddEventHandler("onClientResourceStart", function(name)
	if name == "ssa" then
		TriggerServerEvent("secret_service:checkIsSecretAgent")
	end
end)
]]--

RegisterNetEvent('secret_service:receiveIsSecretAgent')
AddEventHandler('secret_service:receiveIsSecretAgent', function(result)
    if (result == "inconnu") then
        isSecretAgent = false
    else
        secretServicesBlip = SetBlip(58, "Services Secrets", 40, blipPosition.x, blipPosition.y, blipPosition.z, 1.0)
        isSecretAgent = true
        rank = result
    end
end)

RegisterNetEvent('secret_service:nowSecretAgent')
AddEventHandler('secret_service:nowSecretAgent', function()
    secretServicesBlip = SetBlip(58, "Services Secrets", 40, blipPosition.x, blipPosition.y, blipPosition.z, 1.0)
    isSecretAgent = true
end)

RegisterNetEvent('secret_service:noLongerSecretAgent')
AddEventHandler('secret_service:noLongerSecretAgent', function()

    RemoveBlip(secretServicesBlip)

    isSecretAgent = false
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

RegisterNetEvent('secret_service:getArrested')
AddEventHandler('secret_service:getArrested', function()
    if (isSecretAgent == false) then
        handCuffed = not handCuffed
        if (handCuffed) then
            TriggerEvent('showNotify', "Vous êtes maintenant ~r~menotté~w~.")
        else
            TriggerEvent('showNotify', "Vous n\'êtes ~g~plus menotté~w~.")
        end
    end
end)

RegisterNetEvent('secret_service:payFines')
AddEventHandler('secret_service:payFines', function(amount, reason)
    TriggerServerEvent('bank:withdrawAmende', amount)
    TriggerEvent('showNotify', "Vous avez payé $" .. amount .. " d\'amende pour : ~r~" .. reason .. "~w~.")
end)

RegisterNetEvent('secret_service:dropIllegalItems')
AddEventHandler('secret_service:dropIllegalItems', function(id)
    TriggerServerEvent("inventory:removeIllegalItems", tonumber(id))
end)

RegisterNetEvent('secret_service:dropIllegalWeapons')
AddEventHandler('secret_service:dropIllegalWeapons', function()
    RemoveAllPedWeapons(GetPlayerPed(-1))
    TriggerServerEvent("weaponshop:playerSpawned")
end)

RegisterNetEvent('secret_service:unseatme')
AddEventHandler('secret_service:unseatme', function()
    local ped = GetPlayerPed(-1)
    if IsPedInAnyVehicle(ped, true) then
        local vehicle = GetVehiclePedIsIn(ped, true)
        if IsEntityAVehicle(vehicle) then
            ClearPedTasksImmediately(ped)
            TaskLeaveVehicle(ped, vehicle, 0)
        end
    end
end)

RegisterNetEvent('secret_service:forcedEnteringVeh')
AddEventHandler('secret_service:forcedEnteringVeh', function(veh)
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

RegisterNetEvent('secret_service:resultAllSecretAgentsInService')
AddEventHandler('secret_service:resultAllSecretAgentsInService', function(array)
    allServiceSecretAgents = array
    enableSecretAgentsBlips()
end)

function enableSecretAgentsBlips()

    for k, existingBlip in pairs(blipsSecretAgents) do
        RemoveBlip(existingBlip)
    end
    blipsSecretAgents = {}

    local localIdAgents = {}
    for id = 0, 64 do
        if (NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1)) then
            for i, c in pairs(allServiceSecretAgents) do
                if (i == GetPlayerServerId(id)) then
                    localIdAgents[id] = c
                    break
                end
            end
        end
    end

    for id, c in pairs(localIdAgents) do
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

            table.insert(blipsSecretAgents, blip)
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

            table.insert(blipsSecretAgents, blip)
        end
    end
end

RegisterNetEvent('ssa:resultAllCopsInService')
AddEventHandler('ssa:resultAllCopsInService', function(array)
    allServiceCops = array
    enableCopBlips()
end)

function enableCopBlips()

    for _, existingBlip in pairs(blipsCops) do
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
            SetBlipColour(blip, 38)
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

function isNearSSAService()
    for i = 1, #takingService do
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        local distance = GetDistanceBetweenCoords(takingService[i].x, takingService[i].y, takingService[i].z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if (distance < 30) then
            DrawMarker(1, takingService[i].x, takingService[i].y, takingService[i].z - 1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 60, 60, 60, 255, 0, 0, 2, 0, 0, 0, 0)
        end
        if (distance < 2) then
            return true
        end
    end
end

function isNearSSAArmory()
    for i = 1, #armory do
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        local distance = GetDistanceBetweenCoords(armory[i].x, armory[i].y, armory[i].z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if (distance < 30) then
            DrawMarker(1, armory[i].x, armory[i].y, armory[i].z - 1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 60, 60, 60, 255, 0, 0, 2, 0, 0, 0, 0)
        end
        if (distance < 2) then
            return true
        end
    end
end

function ServiceOn()
    isInService = true
    TriggerServerEvent("jobssystem:jobs", requiredJobId)
    TriggerServerEvent("secret_service:takeService")
    TriggerEvent('showNotify', 'Vous êtes maintenant en ~g~service~w~.')
    TriggerServerEvent('police:getAllCopsInService')
end

function ServiceOff()
    isInService = false
    TriggerServerEvent("jobssystem:jobs", defaultJobId)
    TriggerServerEvent("secret_service:breakService")
    TriggerEvent('showNotify', 'Vous avez ~r~quitté~w~ votre service.')
    TriggerServerEvent("mm:otherspawn")
    TriggerEvent('ssa:resultAllCopsInService', {})

    allServiceSecretAgents = {}

    for k, existingBlip in pairs(blipsSecretAgents) do
        RemoveBlip(existingBlip)
    end
    blipsSecretAgents = {}

end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (isSecretAgent) then
            if (isNearSSAService()) then
                DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour accéder aux ~b~Services Secrets~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255) -- ~g~E~s~
                if IsControlJustPressed(1, 51) then
                    OpenSSALocker()
                end
            end
            if (isInService) then
                if (isNearSSAArmory()) then
                    DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir l\'~b~Armurerie~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255) -- ~g~E~s~
                    if IsControlJustPressed(1, 51) then
                        OpenSSAArmory()
                    end
                end
            end
        else
            if (handCuffed == true) then
                RequestAnimDict('mp_arresting')

                while not HasAnimDictLoaded('mp_arresting') do
                    Citizen.Wait(0)
                end

                local myPed = PlayerPedId()
                local animation = 'idle'
                local flags = 16

                TaskPlayAnim(myPed, 'mp_arresting', animation, 8.0, -8, -1, flags, 0, 0, 0, 0)
            end
        end
    end
end)

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