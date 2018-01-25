local policeveh = {
    opened = false,
    title = "Garage Police",
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
            title = "CATEGORIES",
            name = "main",
            buttons = {
                { name = "Vélo", costs = 0, description = {}, model = "scorcher" },
                { name = "Cruiser", costs = 0, description = {}, model = "police" },
                { name = "Buffalo", costs = 0, description = {}, model = "police2" },
                { name = "Interceptor", costs = 0, description = {}, model = "police3" },
                { name = "Moto", costs = 0, description = {}, model = "policeb" },
                { name = "BF400", costs = 0, description = {}, model = "bf400" },
                { name = "Véhicule banalisé", costs = 0, description = {}, model = "police4" },
                { name = "Transport Van", costs = 0, description = {}, model = "policet" },
                { name = "Transport blindé", costs = 0, description = {}, model = "riot" },
                -- {name = "Rancher", costs = 0, description = {}, model = "policeold1"},
                -- {name = "Esperanto", costs = 0, description = {}, model = "policeold2"},
            }
        },
    }
}

local markerPosition = { x = 452.115, y = -1018.106, z = 28.478, h = 90.0 }

local stationGarage = {
    { x = 452.115966796875, y = -1018.10681152344, z = 28.4786586761475 }
}

local heliportGarage = { x = 449.113, y = -981.084, z = 43.691, h = 0.0 }
local boatGarage = { x = -794.352, y = -1501.18, z = -0.001, h = 120.000 }

local activePoliceVehicle = false
local activePoliceVehicleBlip = false

function LocalPed()
    return GetPlayerPed(-1)
end

RegisterNetEvent('police:spawnVehicle')
AddEventHandler('police:spawnVehicle', function(model, p)
    local hash = GetHashKey(tostring(model))
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    activePoliceVehicle = CreateVehicle(hash, p.x, p.y, p.z, p.h, true, false)
    activePoliceVehicleBlip = SetVehicleBlip(activePoliceVehicle, 56, 'LSPD : Véhicule', 3)
    SetPedIntoVehicle(LocalPed(), activePoliceVehicle, -1)
    SetVehicleHasBeenOwnedByPlayer(activePoliceVehicle, true)
    SetModelAsNoLongerNeeded(hash)
    local id = NetworkGetNetworkIdFromEntity(activePoliceVehicle)
    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(activePoliceVehicle)

    -- Police vehicles --> custom options --
    if model == "scorcher" then
        SetVehicleColours(activePoliceVehicle, 82, 131)
    elseif model == "bf400" then
        SetVehicleColours(activePoliceVehicle, 82, 12)
    elseif model == "polmav" then
        SetVehicleLivery(activePoliceVehicle, 0)
    else
        SetVehicleModKit(activePoliceVehicle, 0)
        -- ToggleVehicleMod(activePoliceVehicle, 18, true) -- Turbo --
        SetVehicleMod(activePoliceVehicle, 15, 3) -- Race Suspensions
        SetVehicleMod(activePoliceVehicle, 13, 2) -- Race Transmission
        SetVehicleMod(activePoliceVehicle, 12, 2) -- Race Brakes
        if model == "police2" or model == "police4" then
            SetVehicleMod(activePoliceVehicle, 11, 2) -- Engine Level 4
        elseif model == "police3" or model == "policeb" then
            SetVehicleMod(activePoliceVehicle, 11, 1) -- Engine Level 3
        elseif model == "police" then
            SetVehicleMod(activePoliceVehicle, 11, 0) -- Engine Level 2
        end
        SetVehicleEnginePowerMultiplier(activePoliceVehicle, 1.5)
    end
end)

RegisterNetEvent('police:unspawnVehicle')
AddEventHandler('police:unspawnVehicle', function()
    if GetEntitySpeed(activePoliceVehicle) < 10.0 then
        RemoveBlip(activePoliceVehicleBlip)
        DeleteVehicle(activePoliceVehicle)
        activePoliceVehicle = false
        TriggerEvent('showNotify', 'Vous avez ~g~ramené~w~ votre ~b~véhicule de police~w~.')
    else
        TriggerEvent('showNotify', '~r~Impossible de rentrer le véhicule à cette vitesse.')
    end
end)

RegisterNetEvent('police:vehicleIsDestroyed')
AddEventHandler('police:vehicleIsDestroyed', function()
    RemoveBlip(activePoliceVehicleBlip)
    activePoliceVehicle = false
    TriggerEvent('showNotify', "Votre ~b~véhicule de police~w~ a été ~r~détruit~w~ !")
end)

RegisterNetEvent('police:swapLockPoliceVehicle')
AddEventHandler('police:swapLockPoliceVehicle', function()
    if activePoliceVehicle ~= false then
        local lockRange = 15.0
        local playerPos = GetEntityCoords(LocalPed(), true)
        local activeVehiclePos = GetEntityCoords(activePoliceVehicle, true)
        if (Vdist(playerPos.x, playerPos.y, playerPos.z, activeVehiclePos.x, activeVehiclePos.y, activeVehiclePos.z) < lockRange) then
            local locked = GetVehicleDoorLockStatus(activePoliceVehicle)
            if (locked == 1 or locked == 0) then
                SetVehicleDoorsLocked(activePoliceVehicle, 2)
                TriggerEvent('showNotify', "Votre ~b~véhicule de police~w~ est ~g~verrouillée~w~.")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'lock', 1.0)
            else
                SetVehicleDoorsLocked(activePoliceVehicle, 1)
                TriggerEvent('showNotify', "Votre ~b~véhicule de police~w~ est ~y~déverrouillée~w~.")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 1.0)
            end

        else
            TriggerEvent('showNotify', "Votre ~b~véhicule de police~w~ est ~y~trop éloigné~w~ de vous.")
        end
    else
        TriggerEvent('showNotify', "Votre ~b~véhicule de police~w~ est au ~y~garage~w~ !")
    end
end)

-------------------------------------------------
---------------- CONFIG SELECTION----------------
-------------------------------------------------
function ButtonSelected(button)
    local ped = GetPlayerPed(-1)
    local this = policeveh.currentmenu
    if this == "main" then
        if not IsAnyVehicleNearPoint(markerPosition.x, markerPosition.y, markerPosition.z, 5.0) then
            TriggerEvent('police:spawnVehicle', button.model, markerPosition)
            CloseVeh()
        else
            TriggerEvent('showNotify', '~r~La zone pour le véhicule est encombrée.')
        end
    end
end

-------------------------------------------------
---------------- CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenMenuVeh(menu)
    policeveh.lastmenu = policeveh.currentmenu
    if menu == "main" then
        policeveh.lastmenu = "main"
    end
    policeveh.menu.from = 1
    policeveh.menu.to = 10
    policeveh.selectedbutton = 0
    policeveh.currentmenu = menu
end

-------------------------------------------------
---------------- CONFIG BACK MENU-----------------
-------------------------------------------------
function Back()
    if backlock then
        return
    end
    backlock = true
    if policeveh.currentmenu == "main" then
        CloseVeh()
    else
        OpenMenuVeh(policeveh.lastmenu)
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
    policeveh.currentmenu = "main"
    policeveh.opened = true
    policeveh.selectedbutton = 0
end

-------------------------------------------------
---------------- FONCTION CLOSE-------------------
-------------------------------------------------
function CloseVeh() -- Close Creator
    policeveh.opened = false
    policeveh.menu.from = 1
    policeveh.menu.to = 10
end

-------------------------------------------------
---------------- FONCTION OPEN MENU---------------
-------------------------------------------------
local backlock = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GetDistanceBetweenCoords(markerPosition.x, markerPosition.y, markerPosition.z, GetEntityCoords(GetPlayerPed(-1))) > 5 then
            if policeveh.opened then
                CloseVeh()
            end
        end
        if policeveh.opened then
            local ped = LocalPed()
            local menu = policeveh.menu[policeveh.currentmenu]
            drawTxt(policeveh.title, 1, 1, policeveh.menu.x, policeveh.menu.y, 1.0, 255, 255, 255, 255)
            drawMenuTitle(menu.title, policeveh.menu.x, policeveh.menu.y + 0.08)
            drawTxt(policeveh.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, policeveh.menu.x + policeveh.menu.width / 2 - 0.0385, policeveh.menu.y + 0.067, 0.4, 255, 255, 255, 255)
            local y = policeveh.menu.y + 0.12
            buttoncount = tablelength(menu.buttons)
            local selected = false

            for i, button in pairs(menu.buttons) do
                if i >= policeveh.menu.from and i <= policeveh.menu.to then

                    if i == policeveh.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button, policeveh.menu.x, y, selected)
                    --if button.distance ~= nil then
                    --drawMenuRight(button.distance.."m",policeveh.menu.x,y,selected)
                    --end
                    y = y + 0.04
                    if selected and IsControlJustPressed(1, 201) then
                        ButtonSelected(button)
                    end
                end
            end
        end
        if policeveh.opened then
            if IsControlJustPressed(1, 202) then
                Back()
            end
            if IsControlJustReleased(1, 202) then
                backlock = false
            end
            if IsControlJustPressed(1, 188) then
                if policeveh.selectedbutton > 1 then
                    policeveh.selectedbutton = policeveh.selectedbutton - 1
                    if buttoncount > 10 and policeveh.selectedbutton < policeveh.menu.from then
                        policeveh.menu.from = policeveh.menu.from - 1
                        policeveh.menu.to = policeveh.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1, 187) then
                if policeveh.selectedbutton < buttoncount then
                    policeveh.selectedbutton = policeveh.selectedbutton + 1
                    if buttoncount > 10 and policeveh.selectedbutton > policeveh.menu.to then
                        policeveh.menu.to = policeveh.menu.to + 1
                        policeveh.menu.from = policeveh.menu.from + 1
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (isCop) then

            -- Ground vehicles garage --
            if isInService then
                if isNearStationGarage() then
                    if activePoliceVehicle ~= false and IsPedInVehicle(LocalPed(), activePoliceVehicle, 0) then
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~y~rentrer~w~ votre ~b~véhicule~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            TriggerEvent('police:unspawnVehicle')
                        end
                    elseif activePoliceVehicle ~= false then
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour connaître la position de votre ~b~véhicule de police~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            SetWaypointToVehicle(activePoliceVehicle)
                        end
                    else
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour choisir un ~b~véhicule de police~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            OpenVeh()
                        end
                    end
                else
                    if policeveh.opened == true then
                        CloseVeh()
                    end
                end
                -- Heliport garage --
                if isNearHeliportGarage() then
                    if activePoliceVehicle ~= false and IsPedInVehicle(LocalPed(), activePoliceVehicle, 0) then
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~y~rentrer~w~ votre ~b~hélicoptère de police~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            TriggerEvent('police:unspawnVehicle')
                        end
                    elseif activePoliceVehicle ~= false then
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour connaître la position de votre ~b~véhicule de police~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            SetWaypointToVehicle(activePoliceVehicle)
                        end
                    else
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour sortir un ~b~hélicoptère de police~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            TriggerEvent('police:spawnVehicle', "polmav", heliportGarage)
                        end
                    end
                end

                -- Boat garage --
                if isNearBoatGarage() then
                    if activePoliceVehicle ~= false and IsPedInVehicle(LocalPed(), activePoliceVehicle, 0) then
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~y~rentrer~w~ votre ~b~bateau de police~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            TriggerEvent('police:unspawnVehicle')
                        end
                    elseif activePoliceVehicle ~= false then
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour connaître la position de votre ~b~bateau de police~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            SetWaypointToVehicle(activePoliceVehicle)
                        end
                    else
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour sortir un ~b~bateau de police~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            TriggerEvent('police:spawnVehicle', "predator", boatGarage)
                        end
                    end
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
            DrawMarker(1, stationGarage[i].x, stationGarage[i].y, stationGarage[i].z - 1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
        end
        if (distance < 2) then
            return true
        else
            return false
        end
    end
end

function isNearHeliportGarage()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    local distance = GetDistanceBetweenCoords(heliportGarage.x, heliportGarage.y, heliportGarage.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if (distance < 30) then
        DrawMarker(1, heliportGarage.x, heliportGarage.y, heliportGarage.z - 1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
    end
    if (distance < 2) then
        return true
    else
        return false
    end
end

function isNearBoatGarage()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    local distance = GetDistanceBetweenCoords(boatGarage.x, boatGarage.y, boatGarage.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if (distance < 30) then
        DrawMarker(1, boatGarage.x, boatGarage.y, boatGarage.z, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 0, 155, 255, 200, 0, 0, 2, 0, 0, 0, 0)
    end
    if (distance < 2) then
        return true
    else
        return false
    end
end

function SetVehicleBlip(activePoliceVehicle, id, text, color)
    local Blip = SetBlipSprite(AddBlipForEntity(activePoliceVehicle), id)
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
        SetVehicleEngineTorqueMultiplier(activePoliceVehicle, 1.5)
        if (activePoliceVehicle ~= false) then
            if (tonumber(GetVehicleCauseOfDestruction(activePoliceVehicle) ~= 0) or (IsVehicleDriveable(activePoliceVehicle, 0)) == false) then
                TriggerEvent('police:vehicleIsDestroyed')
            end
        end
    end
end)