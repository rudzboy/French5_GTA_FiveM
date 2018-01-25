local mechanicveh = {
    opened = false,
    title = "Dépanneuses",
    currentmenu = "main",
    lastmenu = nil,
    currentpos = nil,
    selectedbutton = 0,
    marker = { r = 0, g = 155, b = 255, a = 200, type = 1 }, -- ???
    menu = {
        x = 0.1,
        y = 0.15,
        width = 0.2,
        height = 0.04,
        buttons = 10,
        from = 1,
        to = 10,
        scale = 0.4,
        font = 0,
        ["main"] = {
            title = "INVENTAIRE",
            name = "main",
            buttons = {
                { name = "Dépanneuse compacte", costs = 0, description = {}, model = "towtruck2" },
                { name = "Dépanneuse robuste", costs = 0, description = {}, model = "towtruck" },
                { name = "Camion à plateau", costs = 0, description = {}, model = "flatbed" }
            }
        },
    }
}

local Keys = {
    ["L"] = 182,
    ["H"] = 74
}

local flatbed = GetHashKey('flatbed')
local towtruck = GetHashKey('towtruck')
local towtruck2 = GetHashKey('towtruck2')

local isInService = false

local markerPosition = { x = -183.73, y = -1318.08, z = 31.297, h = 0.0 }
local stationGarage = {
    { x = -183.73, y = -1318.08, z = 31.297 }
}

local activeMechanicVehicle = false
local activeMechanicVehicleBlip = false

function LocalPed()
    return GetPlayerPed(-1)
end

RegisterNetEvent('mechanic:setService')
AddEventHandler('mechanic:setService', function(value)
    isInService = value
end)

RegisterNetEvent('mechanic:spawnVehicle')
AddEventHandler('mechanic:spawnVehicle', function(model, p)
    local hash = GetHashKey(tostring(model))
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    activeMechanicVehicle = CreateVehicle(hash, p.x, p.y, p.z, p.h, true, false)
    SetVehicleFixed(activeMechanicVehicle)
    activeMechanicVehicleBlip = SetVehicleBlip(activeMechanicVehicle, 317, 'Dépanneuse', 51)
    SetPedIntoVehicle(LocalPed(), activeMechanicVehicle, -1)
    SetVehicleHasBeenOwnedByPlayer(activeMechanicVehicle, true)
    SetModelAsNoLongerNeeded(hash)
    local id = NetworkGetNetworkIdFromEntity(activeMechanicVehicle)
    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(activeMechanicVehicle)
end)

RegisterNetEvent('mechanic:unspawnVehicle')
AddEventHandler('mechanic:unspawnVehicle', function()
    RemoveBlip(activeMechanicVehicleBlip)
    DeleteVehicle(activeMechanicVehicle)
    activeMechanicVehicle = false
    TriggerEvent('showNotify', 'Vous avez ~g~ramené~w~ votre ~b~dépanneuse~w~.')
end)

RegisterNetEvent('mechanic:vehicleIsDestroyed')
AddEventHandler('mechanic:vehicleIsDestroyed', function()
    RemoveBlip(activeMechanicVehicleBlip)
    activeMechanicVehicle = false
    TriggerEvent('showNotify', "Votre ~b~dépanneuse~w~ a été ~r~détruite~w~ !")
end)

RegisterNetEvent('mechanic:swapLockMechanicVehicle')
AddEventHandler('mechanic:swapLockMechanicVehicle', function()
    if activeMechanicVehicle ~= false then
        local lockRange = 15.0
        local playerPos = GetEntityCoords(LocalPed(), true)
        local activeVehiclePos = GetEntityCoords(activeMechanicVehicle, true)
        if (Vdist(playerPos.x, playerPos.y, playerPos.z, activeVehiclePos.x, activeVehiclePos.y, activeVehiclePos.z) < lockRange) then
            local locked = GetVehicleDoorLockStatus(activeMechanicVehicle)
            if (locked == 1 or locked == 0) then
                SetVehicleDoorsLocked(activeMechanicVehicle, 2)
                TriggerEvent('showNotify', "Votre ~b~dépanneuse~w~ est ~g~verrouillée~w~.")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'lock', 1.0)
            else
                SetVehicleDoorsLocked(activeMechanicVehicle, 1)
                TriggerEvent('showNotify', "Votre ~b~dépanneuse~w~ est ~y~déverrouillée~w~.")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 1.0)
            end

        else
            TriggerEvent('showNotify', "Votre ~b~dépanneuse~w~ est ~y~trop éloigné~w~ de vous.")
        end
    else
        TriggerEvent('showNotify', "Votre ~b~dépanneuse~w~ est au ~y~garage~w~ !")
    end
end)

-------------------------------------------------
---------------- CONFIG SELECTION----------------
-------------------------------------------------
function ButtonSelected(button)
    local ped = GetPlayerPed(-1)
    local this = mechanicveh.currentmenu
    if this == "main" then
        if not IsAnyVehicleNearPoint(markerPosition.x, markerPosition.y, markerPosition.z, 5.0) then
            TriggerEvent('mechanic:spawnVehicle', button.model, markerPosition)
            CloseVeh()
        else
            TriggerEvent('showNotify', '~r~La zone pour sotir la dépanneuse est encombrée.')
        end
    end
end

-------------------------------------------------
---------------- CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenMenuVeh(menu)
    mechanicveh.lastmenu = mechanicveh.currentmenu
    if menu == "main" then
        mechanicveh.lastmenu = "main"
    end
    mechanicveh.menu.from = 1
    mechanicveh.menu.to = 10
    mechanicveh.selectedbutton = 0
    mechanicveh.currentmenu = menu
end

-------------------------------------------------
---------------- CONFIG BACK MENU-----------------
-------------------------------------------------
function Back()
    if backlock then
        return
    end
    backlock = true
    if mechanicveh.currentmenu == "main" then
        CloseVeh()
    else
        OpenMenuVeh(mechanicveh.lastmenu)
    end
end

-------------------------------------------------
---------------- FONCTION ???????-----------------
-------------------------------------------------
function f(n)
    return n + 0.0001
end

function try(f, catch_f)
    local status, exception = pcall(f)
    if not status then
        catch_f(exception)
    end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function round(num, idp)
    if idp and idp > 0 then
        local mult = 10 ^ idp
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

function stringstarts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

-------------------------------------------------
---------------- FONCTION OPEN--------------------
-------------------------------------------------
function OpenVeh() --OpenCreator
    local ped = LocalPed()
    local pos = { markerPosition.x, markerPosition.y, markerPosition.z }
    mechanicveh.currentmenu = "main"
    mechanicveh.opened = true
    mechanicveh.selectedbutton = 0
end

-------------------------------------------------
---------------- FONCTION CLOSE-------------------
-------------------------------------------------
function CloseVeh() -- Close Creator
    mechanicveh.opened = false
    mechanicveh.menu.from = 1
    mechanicveh.menu.to = 10
end

-------------------------------------------------
---------------- FONCTION OPEN MENU---------------
-------------------------------------------------
local backlock = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GetDistanceBetweenCoords(markerPosition.x, markerPosition.y, markerPosition.z, GetEntityCoords(GetPlayerPed(-1))) > 5 then
            if mechanicveh.opened then
                CloseVeh()
            end
        end
        if mechanicveh.opened then
            local ped = LocalPed()
            local menu = mechanicveh.menu[mechanicveh.currentmenu]
            drawTxt(mechanicveh.title, 1, 1, mechanicveh.menu.x, mechanicveh.menu.y, 1.0, 255, 255, 255, 255)
            drawMenuTitle(menu.title, mechanicveh.menu.x, mechanicveh.menu.y + 0.08)
            drawTxt(mechanicveh.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, mechanicveh.menu.x + mechanicveh.menu.width / 2 - 0.0385, mechanicveh.menu.y + 0.067, 0.4, 255, 255, 255, 255)
            local y = mechanicveh.menu.y + 0.12
            buttoncount = tablelength(menu.buttons)
            local selected = false

            for i, button in pairs(menu.buttons) do
                if i >= mechanicveh.menu.from and i <= mechanicveh.menu.to then

                    if i == mechanicveh.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button, mechanicveh.menu.x, y, selected)
                    --if button.distance ~= nil then
                    --drawMenuRight(button.distance.."m",mechanicveh.menu.x,y,selected)
                    --end
                    y = y + 0.04
                    if selected and IsControlJustPressed(1, 201) then
                        ButtonSelected(button)
                    end
                end
            end
        end
        if mechanicveh.opened then
            if IsControlJustPressed(1, 202) then
                Back()
            end
            if IsControlJustReleased(1, 202) then
                backlock = false
            end
            if IsControlJustPressed(1, 188) then
                if mechanicveh.selectedbutton > 1 then
                    mechanicveh.selectedbutton = mechanicveh.selectedbutton - 1
                    if buttoncount > 10 and mechanicveh.selectedbutton < mechanicveh.menu.from then
                        mechanicveh.menu.from = mechanicveh.menu.from - 1
                        mechanicveh.menu.to = mechanicveh.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1, 187) then
                if mechanicveh.selectedbutton < buttoncount then
                    mechanicveh.selectedbutton = mechanicveh.selectedbutton + 1
                    if buttoncount > 10 and mechanicveh.selectedbutton > mechanicveh.menu.to then
                        mechanicveh.menu.to = mechanicveh.menu.to + 1
                        mechanicveh.menu.from = mechanicveh.menu.from + 1
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (isInService) then
            if (isNearStationGarage()) then
                if activeMechanicVehicle ~= false and IsPedInVehicle(LocalPed(), activeMechanicVehicle, 0) then
                    DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~y~rentrer~w~ votre ~b~dépanneuse~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                    if IsControlJustPressed(1, 51) then
                        TriggerEvent('mechanic:unspawnVehicle')
                    end
                elseif activeMechanicVehicle ~= false then
                    DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour connaître la position de votre ~b~dépanneuse~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                    if IsControlJustPressed(1, 51) then
                        SetWaypointToVehicle(activeMechanicVehicle)
                    end
                else
                    DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour choisir une ~b~dépanneuse~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                    if IsControlJustPressed(1, 51) then
                        OpenVeh()
                    end
                end
            else
                if mechanicveh.opened == true then
                    CloseVeh()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isInService and not IsPedInAnyVehicle(GetPlayerPed(-1), true) then
            if (activeMechanicVehicle ~= false) then
                if IsControlJustReleased(1, Keys["L"]) then
                    TriggerEvent('mechanic:prepareClosestCar')
                end
            end
        end
    end
end)

function isNearStationGarage()
    for i = 1, #stationGarage do
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        local distance = GetDistanceBetweenCoords(stationGarage[i].x, stationGarage[i].y, stationGarage[i].z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if (distance < 30) then
            DrawMarker(1, stationGarage[i].x, stationGarage[i].y, stationGarage[i].z - 1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 223, 109, 20, 120, 0, 0, 2, 0, 0, 0, 0)
        end
        -- print distance..'\n'
        if (distance < 2) then
            return true
        else
            return false
        end
    end
end

function SetVehicleBlip(activeMechanicVehicle, id, text, color)
    local Blip = SetBlipSprite(AddBlipForEntity(activeMechanicVehicle), id)
    SetBlipColour(Blip, color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(Blip)
    return Blip
end

function SetWaypointToVehicle(v)
    local c = GetEntityCoords(v, true)
    SetNewWaypoint(c.x, c.y)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if (activeMechanicVehicle ~= false) then
            if (tonumber(GetVehicleCauseOfDestruction(activeMechanicVehicle) ~= 0) or (IsVehicleDriveable(activeMechanicVehicle, 0)) == false) then
                TriggerEvent('mechanic:vehicleIsDestroyed')
            end
        end
    end
end)

RegisterNetEvent('mechanic:prepareClosestCar')
AddEventHandler('mechanic:prepareClosestCar', function()
    local searchVehicleDistance = 10.0
    local playerPed = GetPlayerPed(-1)
    local pos = GetEntityCoords(playerPed)
    local entityWorld = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, searchVehicleDistance, 0.0)

    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, playerPed, 0)
    local a, b, c, d, closestVehicle = GetRaycastResult(rayHandle)

    if closestVehicle ~= nil and DoesEntityExist(closestVehicle) then
        local closestVehiclePlate = GetVehicleNumberPlateText(closestVehicle)
        if closestVehiclePlate ~= GetVehicleNumberPlateText(activeMechanicVehicle) then
            local closestVehicleModelName = GetDisplayNameFromVehicleModel(GetEntityModel(closestVehicle))
            SendNotification("~b~Véhicule~w~ identifié pour ~y~remorquage~w~.")
            SendNotification("~b~" .. string.lower(closestVehicleModelName):gsub("^%l", string.upper) .. "~w~ : ~y~" .. closestVehiclePlate)

            local id = NetworkGetNetworkIdFromEntity(closestVehicle)
            SetNetworkIdCanMigrate(id, true)
            SetEntityAsMissionEntity(closestVehicle)

            if activeMechanicVehicle ~= false then
                if IsVehicleModel(activeMechanicVehicle, flatbed) or IsVehicleModel(activeMechanicVehicle, towtruck) or IsVehicleModel(activeMechanicVehicle, towtruck2) then
                    local attached = false
                    local closeToTarget = (GetDistanceBetweenCoords(pos, GetEntityCoords(closestVehicle), true) < searchVehicleDistance)
                    local closeToActiveVehicle = (GetDistanceBetweenCoords(pos, GetEntityCoords(activeMechanicVehicle), true) < searchVehicleDistance)
                    while (not attached and closeToTarget and closeToActiveVehicle) do
                        Citizen.Wait(0)
                        DisplayHelpText('Appuyez sur ~y~H~w~ pour charger le véhicule.')
                        if IsControlJustReleased(1, Keys["H"]) then
                            TriggerEvent('mechanic:attachToMechanicVehicle', closestVehicle, searchVehicleDistance)
                            attached = true
                            break
                        end
                    end
                end
            end
        else
            SendNotification("~r~Vous ne pouvez pas remorquer votre propre véhicule professionnel.")
        end
    else
        SendNotification("~r~Aucun véhicule à proximité.")
    end
end)

RegisterNetEvent('mechanic:attachToMechanicVehicle')
AddEventHandler('mechanic:attachToMechanicVehicle', function(closestVehicle, searchVehicleDistance)
    local attachedVehicle = false

    if activeMechanicVehicle ~= false then
        if IsVehicleModel(activeMechanicVehicle, flatbed) then
            AttachEntityToEntity(closestVehicle, activeMechanicVehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, 0, 0, true, false, 20, true)
        else
            -- TowTruck Attach
            AttachVehicleToTowTruck(activeMechanicVehicle, closestVehicle, 0, 0.0, 0.0, 0.0)
        end
        TriggerEvent("showNotify", "Véhicule ~y~attaché~w~.")
        attachedVehicle = closestVehicle
    else
        TriggerEvent("showNotify", "~r~Vous n\'avez pas de véhicule pour ça !")
    end

    while attachedVehicle ~= false and activeMechanicVehicle ~= false do
        Citizen.Wait(1)
        local pos = GetEntityCoords(GetPlayerPed(-1))
        if (GetDistanceBetweenCoords(pos, GetEntityCoords(activeMechanicVehicle), true) < searchVehicleDistance) then
            DisplayHelpText('Appuyez sur ~y~H~w~ pour décharger le véhicule.')
            if IsControlJustReleased(1, Keys["H"]) then
                if IsVehicleModel(activeMechanicVehicle, flatbed) then
                    AttachEntityToEntity(closestVehicle, activeMechanicVehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                    DetachEntity(attachedVehicle, true, true)
                else
                    DetachVehicleFromTowTruck(activeMechanicVehicle, attachedVehicle)
                end
                SetVehicleOnGroundProperly(attachedVehicle)
                TriggerEvent("showNotify", "Véhicule ~y~détâché~w~.")
                attachedVehicle = false
                break
            end
        end
    end
end)
