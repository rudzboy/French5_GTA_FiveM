local secretveh = {
    opened = false,
    title = "Garage SSA",
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
                { name = "SSA Buffalo", costs = 0, description = {}, model = "fbi" },
                { name = "SSA Rancher", costs = 0, description = {}, model = "fbi2" },
                { name = "SSA BF400", costs = 0, description = {}, model = "bf400" },
                { name = "SSA Ruiner 2000", costs = 0, description = {}, model = "ruiner2" },
                { name = "SSA Arm. Cognoscenti", costs = 0, description = {}, model = "cog552" },
                { name = "SSA Arm. Baller", costs = 0, description = {}, model = "baller5" },
                { name = "SSA Arm. Schafter", costs = 0, description = {}, model = "schafter5" },
                { name = "SSA Arm. Kuruma", costs = 0, description = {}, model = "kuruma2" },
                { name = "SSA Gun. Limousine", costs = 0, description = {}, model = "limo2" },
                { name = "SSA Gun. Insurgent", costs = 0, description = {}, model = "insurgent" }
            }
        },
    }
}

local markerPosition = { x = 144.126, y = -712.176, z = 33.1333, h = 220.0 }

local stationGarage = {
    { x = 144.126, y = -712.176, z = 33.1333 }
}

local heliportGarage = { x = 123.62, y = -744.466, z = 262.846 }

local activeSecretServiceVehicle = false
local activeSecretServiceVehicleBlip = false

function LocalPed()
    return GetPlayerPed(-1)
end

RegisterNetEvent('secret_service:spawnVehicle')
AddEventHandler('secret_service:spawnVehicle', function(model, p)
    local hash = GetHashKey(tostring(model))
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Citizen.Wait(0)
    end
    activeSecretServiceVehicle = CreateVehicle(hash, p.x, p.y, p.z, p.h, true, false)
    activeSecretServiceVehicleBlip = SetVehicleBlip(activeSecretServiceVehicle, 56, 'Service secrets : Véhicule', 40)
    SetPedIntoVehicle(LocalPed(), activeSecretServiceVehicle, -1)
    SetVehicleHasBeenOwnedByPlayer(activeSecretServiceVehicle, true)
    SetModelAsNoLongerNeeded(hash)
    local id = NetworkGetNetworkIdFromEntity(activeSecretServiceVehicle)
    SetNetworkIdCanMigrate(id, true)
    SetEntityAsMissionEntity(activeSecretServiceVehicle)

    -- SSA vehicles --> custom options --
    if model == "insurgent" then
        SetVehicleColours(activeSecretServiceVehicle, 147, 11) -- Black colors --
        SetVehicleMod(activeSecretServiceVehicle, 16, 4) -- 100% Armor
        SetVehicleTyresCanBurst(activeSecretServiceVehicle, false) -- Bulletproof Tyres
    else
        SetVehicleModKit(activeSecretServiceVehicle, 0)
        ToggleVehicleMod(activeSecretServiceVehicle, 18, true) -- Turbo
        SetVehicleMod(activeSecretServiceVehicle, 15, 3) -- Race Suspensions
        SetVehicleMod(activeSecretServiceVehicle, 13, 2) -- Race Transmission
        SetVehicleMod(activeSecretServiceVehicle, 12, 2) -- Race Brakes
        SetVehicleMod(activeSecretServiceVehicle, 11, 2) -- Engine Level 4
        if model == "cog552" or model == "baller5" or model == "schafter5" or model == "kuruma2" or model == "limo2" or model == "ruiner2" then
            SetVehicleMod(activeSecretServiceVehicle, 16, 4) -- 100% Armor --
            SetVehicleTyresCanBurst(activeSecretServiceVehicle, false) -- Bulletproof Tyres
            SetVehicleWindowTint(activeSecretServiceVehicle, 1) -- Pure Black Windows
        end
        SetVehicleEnginePowerMultiplier(activeSecretServiceVehicle, 1.5)
    end
end)

RegisterNetEvent('secret_service:unspawnVehicle')
AddEventHandler('secret_service:unspawnVehicle', function()
    if GetEntitySpeed(activeSecretServiceVehicle) < 10.0 then
        RemoveBlip(activeSecretServiceVehicleBlip)
        DeleteVehicle(activeSecretServiceVehicle)
        activeSecretServiceVehicle = false
        TriggerEvent('showNotify', 'Vous avez ~g~ramené~w~ votre ~b~véhicule~w~.')
    else
        TriggerEvent('showNotify', '~r~Impossible de rentrer le véhicule à cette vitesse.')
    end
end)

RegisterNetEvent('secret_service:vehicleIsDestroyed')
AddEventHandler('secret_service:vehicleIsDestroyed', function()
    RemoveBlip(activeSecretServiceVehicleBlip)
    activeSecretServiceVehicle = false
    TriggerEvent('showNotify', "Votre ~b~véhicule~w~ a été ~r~détruit~w~ !")
end)

RegisterNetEvent('secret_service:swapLocksecretvehicle')
AddEventHandler('secret_service:swapLocksecretvehicle', function()
    if activeSecretServiceVehicle ~= false then
        local lockRange = 15.0
        local playerPos = GetEntityCoords(LocalPed(), true)
        local activeVehiclePos = GetEntityCoords(activeSecretServiceVehicle, true)
        if (Vdist(playerPos.x, playerPos.y, playerPos.z, activeVehiclePos.x, activeVehiclePos.y, activeVehiclePos.z) < lockRange) then
            local locked = GetVehicleDoorLockStatus(activeSecretServiceVehicle)
            if (locked == 1 or locked == 0) then
                SetVehicleDoorsLocked(activeSecretServiceVehicle, 2)
                TriggerEvent('showNotify', "Votre ~b~véhicule~w~ est ~g~verrouillée~w~.")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'lock', 1.0)
            else
                SetVehicleDoorsLocked(activeSecretServiceVehicle, 1)
                TriggerEvent('showNotify', "Votre ~b~véhicule~w~ est ~y~déverrouillée~w~.")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'unlock', 1.0)
            end

        else
            TriggerEvent('showNotify', "Votre ~b~véhicule~w~ est ~y~trop éloigné~w~ de vous.")
        end
    else
        TriggerEvent('showNotify', "Votre ~b~véhicule~w~ est au ~y~garage~w~ !")
    end
end)

-------------------------------------------------
---------------- CONFIG SELECTION----------------
-------------------------------------------------
function ButtonSelected(button)
    local ped = GetPlayerPed(-1)
    local this = secretveh.currentmenu
    if this == "main" then
        if not IsAnyVehicleNearPoint(markerPosition.x, markerPosition.y, markerPosition.z, 5.0) then
            TriggerEvent('secret_service:spawnVehicle', button.model, markerPosition)
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
    secretveh.lastmenu = secretveh.currentmenu
    if menu == "main" then
        secretveh.lastmenu = "main"
    end
    secretveh.menu.from = 1
    secretveh.menu.to = 10
    secretveh.selectedbutton = 0
    secretveh.currentmenu = menu
end

-------------------------------------------------
---------------- CONFIG BACK MENU-----------------
-------------------------------------------------
function Back()
    if backlock then
        return
    end
    backlock = true
    if secretveh.currentmenu == "main" then
        CloseVeh()
    else
        OpenMenuVeh(secretveh.lastmenu)
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
    secretveh.currentmenu = "main"
    secretveh.opened = true
    secretveh.selectedbutton = 0
end

-------------------------------------------------
---------------- FONCTION CLOSE-------------------
-------------------------------------------------
function CloseVeh() -- Close Creator
    secretveh.opened = false
    secretveh.menu.from = 1
    secretveh.menu.to = 10
end

-------------------------------------------------
---------------- FONCTION OPEN MENU---------------
-------------------------------------------------
local backlock = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GetDistanceBetweenCoords(markerPosition.x, markerPosition.y, markerPosition.z, GetEntityCoords(GetPlayerPed(-1))) > 5 then
            if secretveh.opened then
                CloseVeh()
            end
        end
        if secretveh.opened then
            local ped = LocalPed()
            local menu = secretveh.menu[secretveh.currentmenu]
            drawTxt(secretveh.title, 1, 1, secretveh.menu.x, secretveh.menu.y, 1.0, 255, 255, 255, 255)
            drawMenuTitle(menu.title, secretveh.menu.x, secretveh.menu.y + 0.08)
            drawTxt(secretveh.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, secretveh.menu.x + secretveh.menu.width / 2 - 0.0385, secretveh.menu.y + 0.067, 0.4, 255, 255, 255, 255)
            local y = secretveh.menu.y + 0.12
            buttoncount = tablelength(menu.buttons)
            local selected = false

            for i, button in pairs(menu.buttons) do
                if i >= secretveh.menu.from and i <= secretveh.menu.to then

                    if i == secretveh.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button, secretveh.menu.x, y, selected)
                    --if button.distance ~= nil then
                    --drawMenuRight(button.distance.."m",secretveh.menu.x,y,selected)
                    --end
                    y = y + 0.04
                    if selected and IsControlJustPressed(1, 201) then
                        ButtonSelected(button)
                    end
                end
            end
        end
        if secretveh.opened then
            if IsControlJustPressed(1, 202) then
                Back()
            end
            if IsControlJustReleased(1, 202) then
                backlock = false
            end
            if IsControlJustPressed(1, 188) then
                if secretveh.selectedbutton > 1 then
                    secretveh.selectedbutton = secretveh.selectedbutton - 1
                    if buttoncount > 10 and secretveh.selectedbutton < secretveh.menu.from then
                        secretveh.menu.from = secretveh.menu.from - 1
                        secretveh.menu.to = secretveh.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1, 187) then
                if secretveh.selectedbutton < buttoncount then
                    secretveh.selectedbutton = secretveh.selectedbutton + 1
                    if buttoncount > 10 and secretveh.selectedbutton > secretveh.menu.to then
                        secretveh.menu.to = secretveh.menu.to + 1
                        secretveh.menu.from = secretveh.menu.from + 1
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (isSecretAgent) then

            -- Ground vehicles garage --
            if isInService then
                if isNearStationGarage() then
                    if activeSecretServiceVehicle ~= false and IsPedInVehicle(LocalPed(), activeSecretServiceVehicle, 0) then
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~y~rentrer~w~ votre ~b~véhicule~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            TriggerEvent('secret_service:unspawnVehicle')
                        end
                    elseif activeSecretServiceVehicle ~= false then
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour connaître la position de votre ~b~véhicule~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            SetWaypointToVehicle(activeSecretServiceVehicle)
                        end
                    else
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour choisir un ~b~véhicule~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            OpenVeh()
                        end
                    end
                else
                    if secretveh.opened == true then
                        CloseVeh()
                    end
                end
                -- Heliport garage --
                if isNearHeliportGarage() then
                    if activeSecretServiceVehicle ~= false and IsPedInVehicle(LocalPed(), activeSecretServiceVehicle, 0) then
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~y~rentrer~w~ votre ~b~hélicoptère~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            TriggerEvent('secret_service:unspawnVehicle')
                        end
                    elseif activeSecretServiceVehicle ~= false then
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour connaître la position de votre ~b~véhicule~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            SetWaypointToVehicle(activeSecretServiceVehicle)
                        end
                    else
                        DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour sortir un ~b~hélicoptère~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        if IsControlJustPressed(1, 51) then
                            TriggerEvent('secret_service:spawnVehicle', "frogger2", heliportGarage)
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
            DrawMarker(1, stationGarage[i].x, stationGarage[i].y, stationGarage[i].z - 1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 60, 60, 60, 255, 0, 0, 2, 0, 0, 0, 0)
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
        DrawMarker(1, heliportGarage.x, heliportGarage.y, heliportGarage.z - 1, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 60, 60, 60, 255, 0, 0, 2, 0, 0, 0, 0)
    end
    if (distance < 2) then
        return true
    else
        return false
    end
end

function SetVehicleBlip(activeSecretServiceVehicle, id, text, color)
    local Blip = SetBlipSprite(AddBlipForEntity(activeSecretServiceVehicle), id)
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
        if (activeSecretServiceVehicle ~= false) then
            SetVehicleEngineTorqueMultiplier(activeSecretServiceVehicle, 1.5)
            if (tonumber(GetVehicleCauseOfDestruction(activeSecretServiceVehicle) ~= 0) or (IsVehicleDriveable(activeSecretServiceVehicle, 0)) == false) then
                TriggerEvent('secret_service:vehicleIsDestroyed')
            end
        end
    end
end)