local itemsQuantities = {}

local activeJob = false
local activeVehicle = false
local activeVehicleBlip = false
local currentPlayerJobId = false
local currentBlips = {}

isInService = false

function LocalPed()
    return GetPlayerPed(-1)
end

-- CLIENT THREADS --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

        if (activeVehicle ~= false) then
            if (tonumber(GetVehicleCauseOfDestruction(activeVehicle) ~= 0) or (IsVehicleDriveable(activeVehicle, 0)) == false) then
                TriggerEvent('activities:vehicleIsDestroyed')
            end
        end
    end
end)

RegisterNetEvent('activities:toggleService')
AddEventHandler('activities:toggleService', function(servicePosition)
    local playerPed = GetPlayerPed(-1)
    if not isInService then
        if servicePosition.skin then
            for model, clothes in pairs(servicePosition.skin) do
                if GetEntityModel(playerPed) == GetHashKey(model) then
                    for type, data in pairs(clothes) do
                        if type == "components" then
                            for _, value in pairs(data) do
                                SetPedComponentVariation(playerPed, value[1], value[2], value[3], value[4])
                            end
                        elseif type == "props" then
                            for _, value in pairs(data) do
                                SetPedPropIndex(playerPed, value[1], value[2], value[3], value[4])
                            end
                        end
                    end
                end
            end
        end

        if servicePosition.weapons then
            RemoveAllPedWeapons(playerPed)
            for _, weapon in pairs(servicePosition.weapons) do
                GiveWeaponToPed(playerPed, GetHashKey(weapon), true, false)
            end
        end
        TriggerEvent('showNotify', 'Vous êtes maintenant en ~g~service~w~.')
    else
        RemoveAllPedWeapons(playerPed)
        TriggerServerEvent("weaponshop:GiveWeaponsToSelf")
        TriggerServerEvent("mm:otherspawn")
        TriggerEvent('showNotify', 'Vous avez ~r~quitté~w~ votre service.')
    end

    isInService = not isInService
end)

RegisterNetEvent('activities:displayBlips')
AddEventHandler('activities:displayBlips', function(jobId)

    ResetBlips(currentBlips)

    for k, v in pairs(config.jobs) do
        local requiredJobId = (v.requiredId == nil or v.requiredId == jobId)
        if (config.drawBlipTradeShow == true and v.isLegal == true and requiredJobId) then
            for k, v in pairs(v) do
                if (k == "positions") then
                    for k, p in pairs(v) do
                        local blip = SetBlipTrade(p.blip.id, p.blip.label, p.blip.color, p.x, p.y, p.z)
                        table.insert(currentBlips, blip)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('activities:spawnVehicle')
AddEventHandler('activities:spawnVehicle', function(requiredVehicle, player, job, v, p)
    local hash = GetHashKey(tostring(requiredVehicle.model))
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end

    activeVehicle = CreateVehicle(hash, p.x, p.y, p.z, p.h, true, false)
    activeVehicleBlip = SetVehicleBlip(activeVehicle, requiredVehicle.blip.id, requiredVehicle.blip.label, requiredVehicle.blip.color)
    if requiredVehicle.livery ~= nil then
        SetVehicleLivery(activeVehicle, tonumber(requiredVehicle.livery))
    end
    SetPedIntoVehicle(player, activeVehicle, -1)
    SetVehicleHasBeenOwnedByPlayer(activeVehicle, true)
    SetModelAsNoLongerNeeded(hash)
    local id = NetworkGetNetworkIdFromEntity(activeVehicle)
    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(activeVehicle)
    SetWaypointToNextPosition(job, v, p)
end)

RegisterNetEvent('activities:unspawnVehicle')
AddEventHandler('activities:unspawnVehicle', function()
    RemoveBlip(activeVehicleBlip)
    DeleteVehicle(activeVehicle)
    activeVehicle = false
end)

RegisterNetEvent('activities:vehicleIsDestroyed')
AddEventHandler('activities:vehicleIsDestroyed', function()
    RemoveBlip(activeVehicleBlip)
    activeVehicle = false
    TriggerEvent('showNotify', "~r~Votre véhicule professionnel a été détruit !")
end)

RegisterNetEvent('activities:swapLockActiveVehicle')
AddEventHandler('activities:swapLockActiveVehicle', function()
    if (activeVehicle ~= false) then
        local lockRange = 15.0
        local playerPos = GetEntityCoords(LocalPed(), true)
        local activitiesVehiclePos = GetEntityCoords(activeVehicle, true)
        if (Vdist(playerPos.x, playerPos.y, playerPos.z, activitiesVehiclePos.x, activitiesVehiclePos.y, activitiesVehiclePos.z) < lockRange) then
            local locked = GetVehicleDoorLockStatus(activeVehicle)
            if (locked == 1 or locked == 0) then
                SetVehicleDoorsLocked(activeVehicle, 2)
                TriggerEvent('showNotify', "Votre ~b~véhicule professionnel~w~ est ~g~verrouillée~w~.")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'lock', 1.0)
            else
                SetVehicleDoorsLocked(activeVehicle, 1)
                TriggerEvent('showNotify', "Votre ~b~véhicule professionnel~w~ est ~y~déverrouillée~w~.")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 1.0)
            end
        else
            TriggerEvent('showNotify', "Votre ~b~véhicule~w~ professionnel est ~y~trop éloigné~w~ de vous.")
        end
    else
        TriggerEvent('showNotify', "Votre ~b~véhicule~w~ professionnel est au ~y~garage~w~ !")
    end
end)

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)
        if config.drawMarkerShow == true then

            local playerPos = GetEntityCoords(GetPlayerPed(-1), false)

            for k, j in pairs(config.jobs) do
                local requiredJobId = (j.requiredId == nil or j.requiredId == currentPlayerJobId)
                if requiredJobId == true then
                    for k, v in pairs(j) do
                        if (k == "positions") then
                            for k, p in pairs(v) do
                                if (Vdist(p.x, p.y, p.z, playerPos.x, playerPos.y, playerPos.z) < j.drawMarkerDistance) then
                                    DrawMarker(1, p.x, p.y, p.z - 1, 0, 0, 0, 0, 0, 0, 2.4001, 2.4001, 0.8001, p.marker.r, p.marker.g, p.marker.b, p.marker.a, 0, 0, 0, 0)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)
        local player = GetPlayerPed(-1)
        local playerPos = GetEntityCoords(player)

        for k, job in pairs(config.jobs) do
            local requiredJobId = (job.requiredId == nil or job.requiredId == currentPlayerJobId)
            if requiredJobId == true then
                local marketValue = job.marketValue
                local harvestedItemId = job.harvestedItemId
                local sellableItemId = job.sellableItemId
                local maximumQuantity = job.maximumQuantity
                local actionRequiredDistance = job.actionRequiredDistance

                local requiredVehicle = false
                if (type(job.vehicle) == 'table') then
                    requiredVehicle = job.vehicle
                end

                for k, v in pairs(job) do
                    if (k == "positions") then
                        for k, p in pairs(v) do
                            if (Vdist(p.x, p.y, p.z, playerPos.x, playerPos.y, playerPos.z) < actionRequiredDistance) then

                                if (p.type == "service") then
                                    -- START SERVICE POINT --
                                    if not isInService then
                                        ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour ~g~prendre~w~ votre service.', 0)
                                    else
                                        ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour ~r~quitter~w~ votre service.', 0)
                                    end
                                    if IsControlJustPressed(1, 38) then
                                        TriggerEvent('activities:toggleService', p)
                                    end
                                elseif (p.type == "vehicle") then
                                    -- START VEHICLE POINT --
                                    if activeVehicle ~= false then
                                        ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour ~y~ranger~w~ votre véhicule', 0)
                                    else
                                        ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour ~y~sortir~w~ votre véhicule', 0)
                                    end
                                    if IsControlJustPressed(1, 38) and CanTrigger(job) then
                                        if type(requiredVehicle) == 'table' then
                                            if activeVehicle ~= false then
                                                if IsPedInVehicle(player, activeVehicle, 0) then
                                                    TriggerEvent('activities:unspawnVehicle')
                                                else
                                                    TriggerEvent('showNotify', '~y~Vous avez déjà un véhicule professionnel. Ramenez-le !')
                                                    SetWaypointToVehicle(activeVehicle)
                                                end
                                            else
                                                if not IsAnyVehicleNearPoint(p.x, p.y, p.z, 7.0) then
                                                    TriggerEvent('activities:spawnVehicle', requiredVehicle, player, job, v, p)
                                                else
                                                    TriggerEvent('showNotify', '~r~La zone pour le véhicule est encombrée.')
                                                end
                                            end
                                        else
                                            TriggerEvent('showNotify', '~r~Pas de véhicule disponible.')
                                        end
                                    end
                                    -- END VEHICLE POINT --

                                elseif (p.type == "harvest") then
                                    -- START HARVEST POINT --
                                    ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour démarrer la collecte.', 0)
                                    if IsControlJustPressed(1, 38) and CanTrigger(job) then
                                        if VehicleRequirementsAreMet(player, requiredVehicle, activeVehicle) then
                                            TriggerServerEvent("inventory:getItemQuantity", harvestedItemId)
                                            Citizen.Wait(config.syncDelay)

                                            if itemsQuantities[harvestedItemId] ~= nil and tonumber(itemsQuantities[harvestedItemId]) < maximumQuantity then
                                                local q = itemsQuantities[harvestedItemId]
                                                local d = Vdist(p.x, p.y, p.z, playerPos.x, playerPos.y, playerPos.z)
                                                while (d < actionRequiredDistance and q < maximumQuantity) do
                                                    if VehicleRequirementsAreMet(player, requiredVehicle, activeVehicle) then

                                                        TriggerEvent('showNotify', '~b~Collecte~w~ en cours...')
                                                        TriggerAnimation(p.type, requiredVehicle)
                                                        Wait(p.delay)
                                                        local playerEndPos = GetEntityCoords(GetPlayerPed(-1), false)
                                                        if (Vdist(p.x, p.y, p.z, playerEndPos.x, playerEndPos.y, playerEndPos.z) < actionRequiredDistance) then
                                                            if VehicleRequirementsAreMet(player, requiredVehicle, activeVehicle) then
                                                                TriggerServerEvent("inventory:addItem", harvestedItemId, 1)
                                                            end
                                                        else
                                                            TriggerEvent('showNotify', '~y~Collecte ~r~interrompue~w~. Vous vous êtes trop éloigné.')
                                                        end

                                                        local pp = GetEntityCoords(player)
                                                        d = Vdist(p.x, p.y, p.z, pp.x, pp.y, pp.z)

                                                        TriggerServerEvent("inventory:getItemQuantity", harvestedItemId)
                                                        Citizen.Wait(config.syncDelay)
                                                        q = itemsQuantities[harvestedItemId]
                                                    else
                                                        break
                                                    end
                                                end
                                                if q == maximumQuantity then
                                                    SetWaypointToNextPosition(job, v, p)
                                                    TriggerEvent('showNotify', 'Votre ~b~collecte~w~ est ~g~terminée~w~.')
                                                else
                                                    TriggerEvent('showNotify', '~r~Vous pouvez encore collecter d\'avantage.')
                                                end
                                            else
                                                SetWaypointToNextPosition(job, v, p)
                                                TriggerEvent('showNotify', 'Vous ne pouvez pas ~b~collecter~w~ plus. (~y~' .. maximumQuantity .. '~w~ max.)')
                                            end
                                        end
                                    end
                                    -- END HARVEST POINT --

                                elseif (p.type == "transform") then
                                    -- START TRANSFORM POINT --
                                    ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour commencer le traitement.', 0)
                                    if IsControlJustPressed(1, 38) and CanTrigger(job) then
                                        if VehicleRequirementsAreMet(player, requiredVehicle, activeVehicle) then
                                            TriggerServerEvent("inventory:getItemQuantity", harvestedItemId)
                                            TriggerServerEvent("inventory:getItemQuantity", sellableItemId)
                                            Citizen.Wait(config.syncDelay)
                                            if itemsQuantities[sellableItemId] ~= nil and tonumber(itemsQuantities[sellableItemId]) < maximumQuantity then
                                                if itemsQuantities[harvestedItemId] ~= nil and tonumber(itemsQuantities[harvestedItemId]) > 0 then
                                                    local q = itemsQuantities[harvestedItemId]
                                                    local m = itemsQuantities[sellableItemId]
                                                    local d = Vdist(p.x, p.y, p.z, playerPos.x, playerPos.y, playerPos.z)
                                                    while (d < actionRequiredDistance and q > 0 and m < maximumQuantity) do
                                                        if VehicleRequirementsAreMet(player, requiredVehicle, activeVehicle) then
                                                            TriggerEvent('showNotify', '~b~Traitement~w~ en cours...')
                                                            TriggerAnimation(p.type, requiredVehicle)
                                                            Wait(p.delay)
                                                            local playerEndPos = GetEntityCoords(GetPlayerPed(-1), false)
                                                            if (Vdist(p.x, p.y, p.z, playerEndPos.x, playerEndPos.y, playerEndPos.z) < actionRequiredDistance) then
                                                                if VehicleRequirementsAreMet(player, requiredVehicle, activeVehicle) then
                                                                    TriggerServerEvent("inventory:removeItem", harvestedItemId, 1)
                                                                    TriggerServerEvent("inventory:addItem", sellableItemId, 1)
                                                                end
                                                            else
                                                                TriggerEvent('showNotify', '~y~Traitement ~r~interrompu~w~. Vous vous êtes trop éloigné.')
                                                            end

                                                            local pp = GetEntityCoords(player)
                                                            d = Vdist(p.x, p.y, p.z, pp.x, pp.y, pp.z)

                                                            TriggerServerEvent("inventory:getItemQuantity", harvestedItemId)
                                                            TriggerServerEvent("inventory:getItemQuantity", sellableItemId)
                                                            Citizen.Wait(config.syncDelay)
                                                            q = itemsQuantities[harvestedItemId]
                                                            m = itemsQuantities[sellableItemId]
                                                        else
                                                            break
                                                        end
                                                    end
                                                    if q <= 0 then
                                                        SetWaypointToNextPosition(job, v, p)
                                                        TriggerEvent('showNotify', 'Votre ~b~traitement~w~ est ~g~terminé~w~.')
                                                    elseif m >= maximumQuantity then
                                                        TriggerEvent('showNotify', 'Vous ne pouvez pas ~b~transformer~w~ plus. (~y~' .. maximumQuantity .. '~w~ max.)')
                                                    else
                                                        TriggerEvent('showNotify', '~r~Vous pouvez encore traiter d\'avantage.')
                                                    end
                                                else
                                                    TriggerEvent('showNotify', '~r~Vous n\'avez rien à traiter ici.')
                                                end
                                            else
                                                SetWaypointToNextPosition(job, v, p)
                                                TriggerEvent('showNotify', 'Vous ne pouvez pas ~b~transformer~w~ plus. (~y~' .. maximumQuantity .. '~w~ max.)')
                                            end
                                        end
                                    end
                                    -- END TRANSFORM POINT --

                                elseif (p.type == "sell") and CanTrigger(job, isInService) then
                                    -- START SELLING POINT --
                                    ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour vendre votre marchandise', 0)
                                    if IsControlJustPressed(1, 38) then
                                        if VehicleRequirementsAreMet(player, requiredVehicle, activeVehicle) then

                                            TriggerServerEvent("inventory:getItemQuantity", sellableItemId)
                                            Citizen.Wait(config.syncDelay)

                                            if itemsQuantities[sellableItemId] ~= nil and tonumber(itemsQuantities[sellableItemId]) > 0 then
                                                TriggerEvent('showNotify', '~b~Vente~w~ en cours...')
                                                TriggerAnimation(p.type, requiredVehicle)
                                                Wait(p.delay)
                                                local playerEndPos = GetEntityCoords(GetPlayerPed(-1), false)
                                                if (Vdist(p.x, p.y, p.z, playerEndPos.x, playerEndPos.y, playerEndPos.z) < actionRequiredDistance) then
                                                    if VehicleRequirementsAreMet(player, requiredVehicle, activeVehicle) then
                                                        TriggerServerEvent("inventory:sell", sellableItemId, itemsQuantities[sellableItemId], marketValue)
                                                    end
                                                else
                                                    TriggerEvent('showNotify', '~y~Vente ~r~interrompue~w~. Vous vous êtes trop éloigné.')
                                                end
                                            else
                                                TriggerEvent('showNotify', '~r~Vous n\'avez rien à vendre.')
                                                SetWaypointToNextPosition(job, v, p)
                                            end
                                        end
                                    end
                                    -- END SELLING POINT --
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- UTILITY FUNCTIONS --

function SetWaypointToNextPosition(job, positions, current)
    if (job.navigation == true and job.isLegal == true and current.nextRoute ~= null) then
        local nextPosition = positions[tostring(current.nextRoute)]
        if type(nextPosition) == "table" then
            SetNewWaypoint(nextPosition.x, nextPosition.y)
        end
    end
end

function VehicleRequirementsAreMet(player, requiredVehicle, activeVehicle)
    if type(requiredVehicle) == 'table' then
        if activeVehicle ~= false then
            if IsPedInVehicle(player, activeVehicle, 0) then
                return true
            else
                SetWaypointToVehicle(activeVehicle)
                TriggerEvent('showNotify', '~y~Récupérez votre véhicule professionnel !')
                return false
            end
        else
            TriggerEvent('showNotify', '~r~Vous devez récupérer le véhicule nécessaire.')
            return false
        end
    elseif IsPedInAnyVehicle(player) then
        TriggerEvent('showNotify', '~r~Vous ne pouvez pas faire ça dans un véhicule.')
        return false
    end
    return true
end

-- START BLIPS FUNCTIONS --

function ResetBlips(blips)
    for _, blip in pairs(currentBlips) do
        RemoveBlip(blip)
    end
    currentBlips = {}
end

function SetVehicleBlip(activeVehicle, id, text, color)
    local Blip = SetBlipSprite(AddBlipForEntity(activeVehicle), id)
    SetBlipColour(Blip, color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(Blip)
    return Blip
end

function SetBlipTrade(id, text, color, x, y, z)
    local Blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(Blip, id)
    SetBlipColour(Blip, color)
    SetBlipAsShortRange(Blip, true)
    SetBlipAsShortRange(p0, p1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(Blip)
    return Blip
end

-- END BLIPS FUNCTIONS --

function SetWaypointToVehicle(v)
    local c = GetEntityCoords(v, true)
    SetNewWaypoint(c.x, c.y)
end

function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function ShowAboveRadarMessage(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0, 1)
end

function TriggerAnimation(t, requiredVehicle)
    if (requiredVehicle == false) then
        local a = config.animations[tostring(t)]
        if a ~= nil then
            TriggerEvent("anim:play", a.dictionary, a.animation)
        end
    end
end

function CanTrigger(job)
    if job.requireService and not isInService then
        TriggerEvent('showNotify', '~r~Vous devez être en service !')
        return false
    end
    return true
end

-- CLIENT EVENTS --

RegisterNetEvent("player:getItemQuantity")
AddEventHandler("player:getItemQuantity", function(item_id, quantity)
    itemsQuantities[item_id] = quantity
end)

-- UI EVENTS --

RegisterNetEvent('showNotify')
AddEventHandler('showNotify', function(notify)
    ShowAboveRadarMessage(notify)
end)

RegisterNetEvent('jobssystem:updateClientJob')
AddEventHandler('jobssystem:updateClientJob', function(jobId)
    isInService = false
    currentPlayerJobId = jobId
    TriggerEvent('activities:displayBlips', jobId)
end)

--[[
AddEventHandler('onClientMapStart', function()
  TriggerServerEvent('jobssystem:getPlayerJobId')
end)
AddEventHandler('onClientResourceStart', function()
    TriggerServerEvent('jobssystem:getPlayerJobId')
end)
]]--
