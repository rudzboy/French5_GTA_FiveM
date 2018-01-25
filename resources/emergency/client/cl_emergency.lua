--[[
################################################################
- Creator: Jyben
- Date: 01/05/2017
- Url: https://github.com/Jyben/emergency
- Licence: Apache 2.0
################################################################
--]]

local Keys = {
    ["H"] = 74,
    ["K"] = 311
}

local lang = 'fr'

local txt = {
    ['fr'] = {
        ['getService'] = 'Appuyez sur ~INPUT_CONTEXT~ pour prendre votre service',
        ['dropService'] = 'Appuyez sur ~INPUT_CONTEXT~ pour terminer votre service',
        ['getAmbulance'] = 'Appuyez sur ~INPUT_CONTEXT~ pour sortir une ambulance',
        ['storeAmbulance'] = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger l\'ambulance',
        ['callTaken'] = 'L\'appel a été pris par ~b~',
        ['emergency'] = '<b>~r~URGENCE~s~ <br><br>~b~Raison~s~ : </b>',
        ['takeCall'] = '<b>Appuyez sur ~g~Y~s~ pour prendre l\'appel</b>',
        ['callExpires'] = '<b>~r~URGENCE~s~ <br><br>Attention, l\'appel précèdent a expiré !</b>',
        ['gps'] = 'Un point a été placé sur votre GPS là où se trouve la victime en détresse',
        ['res'] = 'Appuyez sur ~g~E~s~ pour réanimer le joueur',
        ['notDoc'] = 'Vous n\'êtes pas médecin',
        ['stopService'] = 'Vous avez ~r~quitté~w~ votre service.',
        ['startService'] = 'Vous êtes maintenant en ~g~service~w~. ~y~K~w~ pour soigner et ~y~H~w~ pour réanimer un citoyen.'
    }
}

local defaultJobId = 1
local requiredJobId = 11
local enableActionKeys = false

isEMS = false
isInService = false

local medicServiceBlips = {}
local jobId = -1

local allServiceMedics = {}
local blipsMedics = {}

local activeVehicle = false
local activeVehicleBlip = false

local rank = "inconnu"

local servicePositions = {
    { x = -454.67, y = -340.127, z = 34.3635 },
    { x = 296.212, y = -1446.82, z = 29.9666 },
    { x = 1839.54, y = 3672.46, z = 34.2767 }
}

local ambulanceSpawns = {
    { x = -467.806, y = -339.945, z = 34.3709, h = 0.0 },
    { x = 317.145, y = -1449.11, z = 29.81, h = 240.0 },
    { x = 1842.81, y = 3706.02, z = 33.6265, h = 0.0 }
}

-- SERVICE ON/OFF --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
        for _, servicePosition in pairs(servicePositions) do
            if (Vdist(playerPos.x, playerPos.y, playerPos.z, servicePosition.x, servicePosition.y, servicePosition.z) < 100.0) and isEMS == true then --jobId == requiredJobId then
                DrawMarker(1, servicePosition.x, servicePosition.y, servicePosition.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 0, 0, 200, 165, 0, 0, 0, 0)
                if (Vdist(playerPos.x, playerPos.y, playerPos.z, servicePosition.x, servicePosition.y, servicePosition.z) < 2.0) then
                    if isInService then
                        DisplayHelpText(txt[lang]['dropService'])
                    else
                        DisplayHelpText(txt[lang]['getService'])
                    end
                    if (IsControlJustReleased(1, 38)) then
                        TriggerServerEvent('es_em:sv_getJobId')
                    end
                end
            end
        end
    end
end)

-- AMBULANCES --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isInService and (jobId == requiredJobId) then
            local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
            for _, ambulanceSpawn in pairs(ambulanceSpawns) do
                if (Vdist(playerPos.x, playerPos.y, playerPos.z, ambulanceSpawn.x, ambulanceSpawn.y, ambulanceSpawn.z) < 100.0) then
                    DrawMarker(1, ambulanceSpawn.x, ambulanceSpawn.y, ambulanceSpawn.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0, 165, 0, 0, 0, 0)
                    if (Vdist(playerPos.x, playerPos.y, playerPos.z, ambulanceSpawn.x, ambulanceSpawn.y, ambulanceSpawn.z) < 2.0) then
                        if activeVehicle == false then
                            DisplayHelpText(txt[lang]['getAmbulance'])
                            if (IsControlJustReleased(1, 38)) then
                                TriggerEvent('ems:spawnVehicle', ambulanceSpawn)
                            end
                        else
                            DisplayHelpText(txt[lang]['storeAmbulance'])
                            if (IsControlJustReleased(1, 38)) then
                                TriggerEvent('ems:unspawnVehicle')
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- MEDIC SKILLS --
if enableActionKeys then
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            if jobId == requiredJobId then -- being in service is not mandatory
                if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
                    if IsControlJustReleased(1, Keys["H"]) then
                        SendNotification('Vous cherchez un citoyen inconscient.')
                        TriggerEvent('ems:findDeadPlayers')
                    end
                    if IsControlJustReleased(1, Keys["K"]) then
                        SendNotification('Vous cherchez un citoyen blessé.')
                        TriggerEvent('ems:findInjuredPlayers')
                    end
                end
            end
        end
    end)
end

-- ACTIVE CAR DESTRUCTION --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if (activeVehicle ~= false) then
            if (tonumber(GetVehicleCauseOfDestruction(activeVehicle) ~= 0) or (IsVehicleDriveable(activeVehicle, 0)) == false) then
                TriggerEvent('ems:vehicleIsDestroyed')
            end
        end
    end
end)

--[[
################################
            EVENTS
################################
--]]


AddEventHandler("playerSpawned", function()
    TriggerServerEvent("ems:checkIsEMS")
end)

RegisterNetEvent('ems:receiveService')
AddEventHandler('ems:receiveService', function(value)
    isInService = value
    switchJobWeapons()
end)

RegisterNetEvent('ems:resultAllMedicsInService')
AddEventHandler('ems:resultAllMedicsInService', function(array)
    allServiceMedics = array
    enableMedicsBlips()
end)

RegisterNetEvent('ems:findDeadPlayers')
AddEventHandler('ems:findDeadPlayers', function()
    TriggerServerEvent('ems:findDeadPlayers')
end)

RegisterNetEvent('ems:findInjuredPlayers')
AddEventHandler('ems:findInjuredPlayers', function()
    TriggerServerEvent('ems:findInjuredPlayers')
end)

RegisterNetEvent('ems:canSaveDead')
AddEventHandler('ems:canSaveDead', function(deadPlayerId, x, y, z)
    local triggerActionDistance = 5.0
    local notificationDistance = 50.0
    local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
    local virtualDistance = Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z)

    local targetBlip = DisplayBlip({ x, y, z }, "Citoyen inconscient", 4)

    if (virtualDistance < triggerActionDistance) then
        TriggerEvent('ems:rescueCloseDead', x, y, z, deadPlayerId)
    elseif (virtualDistance < notificationDistance) then
        SendNotification('La victime est ~y~proche~w~ de vous : ' .. math.abs(virtualDistance) .. "m.")
    end

    Citizen.Wait(15000)
    RemoveBlip(targetBlip)
end)

RegisterNetEvent('ems:canSaveInjured')
AddEventHandler('ems:canSaveInjured', function(injuredPlayerId, x, y, z)
    local triggerActionDistance = 5.0
    local notificationDistance = 50.0
    local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
    local virtualDistance = Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z)

    local targetBlip = DisplayBlip({ x, y, z }, "Citoyen bléssé", 4)

    if (virtualDistance < triggerActionDistance) then
        TriggerEvent('ems:rescueCloseInjured', x, y, z, injuredPlayerId)
    elseif (virtualDistance < notificationDistance) then
        SendNotification('Le joueur blessé est ~y~proche~w~ de vous : ' .. math.abs(virtualDistance) .. "m.")
    end

    Citizen.Wait(15000)
    RemoveBlip(targetBlip)
end)

RegisterNetEvent('ems:receiveIsEMS')
AddEventHandler('ems:receiveIsEMS', function(result)
    if (result == "inconnu") then
        isEMS = false
        jobId = defaultJobId
        if medicServiceBlip ~= false then
            RemoveBlip(medicServiceBlip)
        end
        medicServiceBlip = false
    else
        isEMS = true
        rank = result
        jobId = requiredJobId
        for _, servicePosition in pairs(servicePositions) do
            local blip = DisplayBlip(servicePosition, "Médecin : Service", 75)
            table.insert(medicServiceBlips, blip)
        end
    end
end)

RegisterNetEvent('ems:nowEMS')
AddEventHandler('ems:nowEMS', function()
    isEMS = true
    jobId = requiredJobId
    for _, servicePosition in pairs(servicePositions) do
        local blip = DisplayBlip(servicePosition, "Médecin : Service", 75)
        table.insert(medicServiceBlips, blip)
    end
end)

RegisterNetEvent('ems:noLongerEMS')
AddEventHandler('ems:noLongerEMS', function()
    isEMS = false
    isInService = false
    ResetBlips(medicServiceBlips)
    TriggerServerEvent("mm:otherspawn")
    jobId = defaultJobId

    local playerPed = GetPlayerPed(-1)

    RemoveAllPedWeapons(playerPed)

    if (existingVeh ~= nil) then
        SetEntityAsMissionEntity(existingVeh, true, true)
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
        existingVeh = nil
    end
end)

RegisterNetEvent('ems:rescueCloseDead')
AddEventHandler('ems:rescueCloseDead', function(x, y, z, deadPlayerId)
    local actionDistance = 5.0
    local notificationDistance = 50.0
    local ped = GetPlayerPed(-1);
    local done = false
    while not done do
        Citizen.Wait(0)
        if (GetDistanceBetweenCoords(GetEntityCoords(ped), x, y, z, true) < actionDistance) then
            TriggerEvent("anim:emote", 'CODE_HUMAN_MEDIC_TEND_TO_DEAD')
            Citizen.Wait(8000)
            ClearPedTasks(ped);
            TriggerServerEvent('es_em:sv_resurectPlayer', deadPlayerId)
        elseif (GetDistanceBetweenCoords(GetEntityCoords(ped), x, y, z, true) < notificationDistance) then
            SendNotification('Vous êtes ~b~trop loin~w~ de la victime.')
        end
        done = true
    end
end)

RegisterNetEvent('ems:rescueCloseInjured')
AddEventHandler('ems:rescueCloseInjured', function(x, y, z, deadPlayerId)
    local actionDistance = 5.0
    local notificationDistance = 50.0
    local ped = GetPlayerPed(-1);
    local done = false
    while not done do
        Citizen.Wait(0)
        if (GetDistanceBetweenCoords(GetEntityCoords(ped), x, y, z, true) < actionDistance) then
            TriggerEvent("anim:emote", 'CODE_HUMAN_MEDIC_TIME_OF_DEATH')
            Citizen.Wait(8000)
            ClearPedTasks(ped);
            TriggerServerEvent('es_em:sv_healPlayer', deadPlayerId)
        elseif (GetDistanceBetweenCoords(GetEntityCoords(ped), x, y, z, true) < notificationDistance) then
            SendNotification('Vous êtes ~b~trop loin~w~ de la victime.')
        end
        done = true
    end
end)

RegisterNetEvent('es_em:cl_setJobId')
AddEventHandler('es_em:cl_setJobId', function(p_jobId)
    jobId = p_jobId
    GetService()
end)


RegisterNetEvent('ems:spawnVehicle')
AddEventHandler('ems:spawnVehicle', function(p)
    local hash = GetHashKey('ambulance')
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end

    activeVehicle = CreateVehicle(hash, p.x, p.y, p.z, p.h, true, false)
    activeVehicleBlip = SetVehicleBlip(activeVehicle, 61, "Ambulance", 4)
    SetPedIntoVehicle(GetPlayerPed(-1), activeVehicle, -1)
    SetVehicleHasBeenOwnedByPlayer(activeVehicle, true)
    SetModelAsNoLongerNeeded(hash)
    local id = NetworkGetNetworkIdFromEntity(activeVehicle)
    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(activeVehicle)
end)

RegisterNetEvent('ems:unspawnVehicle')
AddEventHandler('ems:unspawnVehicle', function()
    RemoveBlip(activeVehicleBlip)
    DeleteVehicle(activeVehicle)
    activeVehicle = false
    TriggerEvent('showNotify', 'Vous avez ~g~rentré~w~ votre ~b~ambulance~w~.')
end)

RegisterNetEvent('ems:vehicleIsDestroyed')
AddEventHandler('ems:vehicleIsDestroyed', function()
    RemoveBlip(activeVehicleBlip)
    activeVehicle = false
    TriggerEvent('showNotify', "~r~Votre ambulance a été détruite !")
end)

RegisterNetEvent('ems:swapLockEMSVehicle')
AddEventHandler('ems:swapLockEMSVehicle', function()
    if activeVehicle ~= false then
        local lockRange = 15.0
        local playerPos = GetEntityCoords(LocalPed(), true)
        local activeVehiclePos = GetEntityCoords(activeVehicle, true)
        if (Vdist(playerPos.x, playerPos.y, playerPos.z, activeVehiclePos.x, activeVehiclePos.y, activeVehiclePos.z) < lockRange) then
            local locked = GetVehicleDoorLockStatus(activeVehicle)
            if (locked == 1 or locked == 0) then
                SetVehicleDoorsLocked(activeVehicle, 2)
                TriggerEvent('showNotify', "Votre ~b~ambulance~w~ est ~g~verrouillée~w~.")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'lock', 1.0)
            else
                SetVehicleDoorsLocked(activeVehicle, 1)
                TriggerEvent('showNotify', "Votre ~b~ambulance~w~ est ~y~déverrouillée~w~.")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 1.0)
            end

        else
            TriggerEvent('showNotify', "Votre ~b~ambulance~w~ est ~y~trop éloigné~w~ de vous.")
        end
    else
        TriggerEvent('showNotify', "Votre ~b~ambulance~w~ est au ~y~garage~w~ !")
    end
end)


--[[
AddEventHandler('onClientResourceStart', function(name)
	if name == "emergency" then
		TriggerServerEvent('ems:checkIsEMS')
	end
end)
]]--

-- FUNCTIONS --

function SetVehicleBlip(activeVehicle, id, text, color)
    local Blip = SetBlipSprite(AddBlipForEntity(activeVehicle), id)
    SetBlipColour(Blip, color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(Blip)
    return Blip
end

function ResetBlips(blips)
    for _, blip in pairs(blips) do
        RemoveBlip(blip)
    end
    medicServiceBlips = {}
end

function DisplayBlip(position, text, color)
    local blip = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blip, 61)
    SetBlipAsShortRange(blip, true)
    SetBlipColour(blip, color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
    return blip
end

function GetService()
    local playerPed = GetPlayerPed(-1)

    if isInService then
        SendNotification(txt[lang]['stopService'])
        TriggerServerEvent("mm:otherspawn")
        TriggerServerEvent('es_em:sv_setService', false)
        TriggerServerEvent("jobssystem:jobs", defaultJobId)
        isInService = false
    else
        SendNotification(txt[lang]['startService'])
        TriggerServerEvent("jobssystem:jobs", requiredJobId)
        TriggerServerEvent('es_em:sv_setService', true)
        if (GetEntityModel(playerPed) == GetHashKey("mp_m_freemode_01")) then
            SetPedComponentVariation(playerPed, 11, 13, 3, 2)
            SetPedComponentVariation(playerPed, 8, 15, 0, 2)
            SetPedComponentVariation(playerPed, 4, 9, 3, 2)
            SetPedComponentVariation(playerPed, 3, 92, 0, 2)
            SetPedComponentVariation(playerPed, 6, 25, 0, 2)
        elseif (GetEntityModel(playerPed) == GetHashKey("mp_f_freemode_01")) then
            SetPedComponentVariation(playerPed, 11, 9, 2, 2)
            SetPedComponentVariation(playerPed, 8, 15, 0, 2)
            SetPedComponentVariation(playerPed, 4, 3, 12, 2)
            SetPedComponentVariation(playerPed, 3, 93, 0, 2)
            SetPedComponentVariation(playerPed, 6, 29, 1, 2)
        end
        isInService = true
    end
end

-- DISPLAY FUNCTIONS --

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function SendNotification(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(false, false)
end

function enableMedicsBlips()

    for _, existingBlip in pairs(blipsMedics) do
        RemoveBlip(existingBlip)
    end
    blipsMedics = {}

    local localIdMedics = {}
    for id = 0, 32 do
        if (NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= GetPlayerPed(-1)) then
            for i, c in pairs(allServiceMedics) do
                if (i == GetPlayerServerId(id)) then
                    localIdMedics[id] = c
                    break
                end
            end
        end
    end

    for id, _ in pairs(localIdMedics) do
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

            table.insert(blipsMedics, blip)
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

            table.insert(blipsMedics, blip)
        end
    end
end

function switchJobWeapons()
    local playerPed = GetPlayerPed(-1)
    if isInService then
        RemoveAllPedWeapons(playerPed)
        Citizen.Wait(1)
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_FLASHLIGHT"), true, false)
        GiveWeaponToPed(playerPed, GetHashKey("WEAPON_STUNGUN"), true, false)
    else
        RemoveAllPedWeapons(playerPed)
        TriggerServerEvent("weaponshop:GiveWeaponsToSelf")
        Citizen.Wait(1)
    end
end