--[[Register]]--

RegisterNetEvent("ply_garages:getVehicles")
RegisterNetEvent('ply_garages:SpawnVehicle')
RegisterNetEvent('ply_garages:StoreVehicleTrue')
RegisterNetEvent('ply_garages:StoreVehicleFalse')
RegisterNetEvent('ply_garages:SelVehicleTrue')
RegisterNetEvent('ply_garages:SelVehicleFalse')
RegisterNetEvent('ply_garages:BuyTrue')
RegisterNetEvent('ply_garages:BuyFalse')
RegisterNetEvent('ply_garages:UpdateDone')

--[[Local/Global]]--

VEHICLES = {}
local vente_location = { -45.228, -1083.123, 25.816 }
local ventenamefr = "Vente de véhicule"
local ventenameen = "Sell"
local inrangeofgarage = false

local personalVehicle = false
local personalVehicleBlip = false

-- vehicule states --
local state_in = "Rentré"
local state_out = "Sortit"
local state_pound = "Fourriere"

local garages = {
    { name = "Garage", colour = 3, id = 50, x = 215.124, y = -791.377, z = 29.646, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = -334.685, y = 289.773, z = 84.705, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = -55.272, y = -1838.71, z = 25.442, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = 126.434, y = 6610.04, z = 30.750, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = -977.63, y = -2703.16, z = 12.8562, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = -198.383, y = 6215.49, z = 30.4893, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = 477.482, y = -1093.8, z = 28.2009, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = 1776.61, y = 3343.71, z = 39.8327, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = -1183.87, y = -1479.26, z = 3.3797, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = -228.007, y = -1170.7, z = 21.8887, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = -796.301, y = 321.986, z = 84.7004, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = 1121.88, y = -1617.65, z = 33.69, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = 1689.0, y = 4766.954, z = 41.92, a = 85.0 },
    { name = "Garage", colour = 3, id = 50, x = -389.83, y = -458.408, z = 29.9259, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = -1380.594, y = -652.664, z = 27.685, a = 302.071 }, --Garage Bahamma mamma
    { name = "Garage", colour = 3, id = 50, x = 781.044, y = -2968.7, z = 4.801, a = 0.0 },
    { name = "Garage", colour = 3, id = 50, x = 221.307, y = -1523.57, z = 28.147, a = 0.0 }, -- Close to begining of driving licence
    { name = "Garage", colour = 3, id = 50, x = 965.576, y = -119.594, z = 73.42, a = 236.32 }, --Garage lost
}

local car_pounds = {
    { name = "Fourrière", colour = 51, id = 50, x = 823.146, y = -1370.13, z = 25.1362, a = 0.0 }, -- LSPD Car Pound - East Los Santos
    { name = "Fourrière", colour = 51, id = 50, x = -611.627, y = -1605.4, z = 25.7507, a = 0.0 }, -- Roger Scraps - West Los Santos
    { name = "Fourrière", colour = 51, id = 50, x = -475.32, y = 6022.67, z = 30.3405, a = 0.0 }, -- LSPD Paleto Bay - Far North West
    { name = "Fourrière", colour = 51, id = 50, x = 1869.57, y = 3694.99, z = 32.5571, a = 0.0 } -- LSPD Paleto Bay - Far North West
}

garageSelected = { { x = nil, y = nil, z = nil }, }

--[[Functions]]--

function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, state, 0, -1)
end


function SetVehicleBlip(activeVehicle, id, text, color)
    local Blip = SetBlipSprite(AddBlipForEntity(activeVehicle), id)
    SetBlipColour(Blip, color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(Blip)
    return Blip
end


function configLang(lang)
    local lang = lang
    if lang == "FR" then
        lang_string = {
            menu1 = "Rentrer le véhicule",
            menu2 = "Sortir un véhicule",
            menu3 = "Fermer",
            menu4 = "Vehicules",
            menu5 = "Options",
            menu6 = "Sortir",
            menu7 = "Retour",
            menu8 = "Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le ~b~garage~w~.",
            menu9 = "Vente",
            menu10 = "~g~E~s~ pour vendre le véhicule à 50% du prix d\'achat",
            menu11 = "Mettre à jour le véhicule",
            menu12 = "Appuyez sur ~INPUT_CONTEXT~ pour accéder à la ~b~fourrière~w~.",
            menu13 = "Récupérer un véhicule",
            state1 = "Sortit",
            state2 = "Rentré",
            state3 = "Fourriere",
            text1 = "La zone est encombrée",
            text2 = "~r~Ce véhicule n\'est pas dans le garage.",
            text3 = "Véhicule sorti",
            text4 = "~r~Ce n'est pas votre véhicule.",
            text5 = "Véhicule rentré",
            text6 = "Aucun véhicule présent",
            text7 = "Véhicule ~g~vendu~w~.",
            text8 = "Véhicule acheté, bonne route",
            text9 = "~r~Fonds insuffisants.",
            text10 = "Véhicule ~g~mis à jour~w~.",
            text11 = "Véhicule ~r~trop endommagé~w~ pour être rangé. Contactez un ~y~dépanneur~w~."
        }
    end
end

function MenuGarage()
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton(lang_string.menu1, "RentrerVehicule", nil)
    Menu.addButton(lang_string.menu2, "ListeVehicule", nil)
    Menu.addButton(lang_string.menu11, "UpdateVehicule", nil)
    Menu.addButton(lang_string.menu3, "CloseMenu", nil)
end

function MenuCarPound()
    MenuTitle = "Fourrière"
    ClearMenu()
    Menu.addButton(lang_string.menu2, "ListePoundVehicule", nil)
    Menu.addButton(lang_string.menu3, "CloseMenu", nil)
end

function RentrerVehicule()
    Citizen.CreateThread(function()
        local caissei = GetClosestVehicle(garageSelected.x, garageSelected.y, garageSelected.z, 3.000, 0, 70)
        SetEntityAsMissionEntity(caissei, true, true)
        local plate = GetVehicleNumberPlateText(caissei)
        if DoesEntityExist(caissei) then
            local vehicleHealthThreshold = 75.0
            if (GetVehicleHealthRatio(caissei) >= vehicleHealthThreshold) then
                TriggerServerEvent('ply_garages:CheckForVeh', plate)
            else
                drawNotification(lang_string.text11)
            end
        else
            drawNotification(lang_string.text6)
        end
    end)
    CloseMenu()
end

function ListePoundVehicule()
    MenuTitle = lang_string.menu4
    ClearMenu()
    for ind, value in pairs(VEHICLES) do
        if value.vehicle_state == state_pound then
            local recoverPrice = math.floor(tonumber(value.vehicle_price) / 200) -- 0.5% of the vehicle's cost --
            Menu.addButton(tostring(value.vehicle_name) .. " (" .. recoverPrice .. "$)", "RecoverVehiculeFromPound", { id = value.id, price = recoverPrice })
        end
    end
    Menu.addButton(lang_string.menu7, "MenuCarPound", nil)
end

function ListeVehicule()
    MenuTitle = lang_string.menu4
    ClearMenu()

    for ind, value in pairs(VEHICLES) do
        if value.vehicle_state == state_in then
            Menu.addButton(tostring(value.vehicle_name), "SortirVehicule", value.id)
        else
            Menu.addButton(tostring(value.vehicle_name) .. " (X)", "SortirVehicule", false)
        end
    end
    Menu.addButton(lang_string.menu7, "MenuGarage", nil)
end

function SortirVehicule(vehID)
    if vehID ~= false then
        TriggerServerEvent('ply_garages:CheckForSpawnVeh', vehID)
    else
        drawNotification(lang_string.text2)
    end
    CloseMenu()
end

function RecoverVehiculeFromPound(data)
    TriggerServerEvent('ply_garages:CheckForPoundVeh', data.id, data.price)
    CloseMenu()
end

function UpdateVehicule()
    Citizen.CreateThread(function()
        local veh = GetClosestVehicle(garageSelected.x, garageSelected.y, garageSelected.z, 3.000, 0, 70)
        SetEntityAsMissionEntity(veh, true, true)
        if DoesEntityExist(veh) then

            local colors = table.pack(GetVehicleColours(veh))
            local extra_colors = table.pack(GetVehicleExtraColours(veh))
            local neoncolor = table.pack(GetVehicleNeonLightsColour(veh))
            local mods = table.pack(GetVehicleMod(veh))
            local smokecolor = table.pack(GetVehicleTyreSmokeColor(veh))

            local plate = GetVehicleNumberPlateText(veh) -- Licence ID
            local plateindex = GetVehicleNumberPlateTextIndex(veh) --
            local primarycolor = colors[1] -- 1rst colour
            local secondarycolor = colors[2] -- 2nd colour
            local pearlescentcolor = extra_colors[1] -- colour type
            local wheelcolor = extra_colors[2] -- wheel colour
            local neoncolor1 = neoncolor[1] -- neon colour 1
            local neoncolor2 = neoncolor[2] -- neon colour 2
            local neoncolor3 = neoncolor[3] -- neon colour 3
            local windowtint = GetVehicleWindowTint(veh) -- Tinted Windows
            local wheeltype = GetVehicleWheelType(veh) -- Wheel Type
            local smokecolor1 = smokecolor[1]
            local smokecolor2 = smokecolor[2]
            local smokecolor3 = smokecolor[3]
            local mods0 = GetVehicleMod(veh, 0)
            local mods1 = GetVehicleMod(veh, 1)
            local mods2 = GetVehicleMod(veh, 2)
            local mods3 = GetVehicleMod(veh, 3)
            local mods4 = GetVehicleMod(veh, 4)
            local mods5 = GetVehicleMod(veh, 5)
            local mods6 = GetVehicleMod(veh, 6)
            local mods7 = GetVehicleMod(veh, 7)
            local mods8 = GetVehicleMod(veh, 8)
            local mods9 = GetVehicleMod(veh, 9)
            local mods10 = GetVehicleMod(veh, 10)
            local mods11 = GetVehicleMod(veh, 11)
            local mods12 = GetVehicleMod(veh, 12)
            local mods13 = GetVehicleMod(veh, 13)
            local mods14 = GetVehicleMod(veh, 14)
            local mods15 = GetVehicleMod(veh, 15)
            local mods16 = GetVehicleMod(veh, 16)
            local mods23 = GetVehicleMod(veh, 23)
            local mods24 = GetVehicleMod(veh, 24)

            if IsToggleModOn(veh, 18) then
                turbo = "on"
            else
                turbo = "off"
            end
            if IsToggleModOn(veh, 20) then
                tiresmoke = "on"
            else
                tiresmoke = "off"
            end
            if IsToggleModOn(veh, 22) then
                xenon = "on"
            else
                xenon = "off"
            end
            if IsVehicleNeonLightEnabled(veh, 0) then
                neon0 = "on"
            else
                neon0 = "off"
            end
            if IsVehicleNeonLightEnabled(veh, 1) then
                neon1 = "on"
            else
                neon1 = "off"
            end
            if IsVehicleNeonLightEnabled(veh, 2) then
                neon2 = "on"
            else
                neon2 = "off"
            end
            if IsVehicleNeonLightEnabled(veh, 3) then
                neon3 = "on"
            else
                neon3 = "off"
            end
            if GetVehicleTyresCanBurst(veh) then
                bulletproof = "off"
            else
                bulletproof = "on"
            end
            if GetVehicleModVariation(veh, 23) then
                variation = "on"
            else
                variation = "off"
            end

            TriggerServerEvent('ply_garages:UpdateVeh', plate, plateindex, primarycolor, secondarycolor, pearlescentcolor, wheelcolor, neoncolor1, neoncolor2, neoncolor3, windowtint, wheeltype, mods0, mods1, mods2, mods3, mods4, mods5, mods6, mods7, mods8, mods9, mods10, mods11, mods12, mods13, mods14, mods15, mods16, turbo, tiresmoke, xenon, mods23, mods24, neon0, neon1, neon2, neon3, bulletproof, smokecolor1, smokecolor2, smokecolor3, variation)
        else
            drawNotification(lang_string.text6)
        end
    end)
    CloseMenu()
end

function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function GetVehicleHealthRatio(vehicle)
    local vehiclehealth = GetEntityHealth(vehicle) - 100
    local maxhealth = GetEntityMaxHealth(vehicle) - 100
    return (vehiclehealth / maxhealth) * 100
end

function CloseMenu()
    Menu.hidden = true
    TriggerServerEvent("ply_garages:CheckGarageForVeh")
end

function LocalPed()
    return GetPlayerPed(-1)
end

function IsPlayerInRangeOfGarage()
    return inrangeofgarage
end

function Chat(debugg)
    TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
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

--[[Citizen]]--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, garage in pairs(garages) do
            DrawMarker(1, garage.x, garage.y, garage.z, 0, 0, 0, 0, 0, 0, 3.001, 3.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
            if GetDistanceBetweenCoords(garage.x, garage.y, garage.z, GetEntityCoords(LocalPed())) < 3 and IsPedInAnyVehicle(LocalPed(), true) == false then
                ShowInfo(lang_string.menu8, 0)
                if IsControlJustPressed(1, 86) then
                    garageSelected.x = garage.x
                    garageSelected.y = garage.y
                    garageSelected.z = garage.z
                    garageSelected.a = garage.a
                    MenuGarage()
                    Menu.hidden = not Menu.hidden
                end
                Menu.renderGUI()
            end
        end

        for _, pound in pairs(car_pounds) do
            DrawMarker(1, pound.x, pound.y, pound.z, 0, 0, 0, 0, 0, 0, 3.001, 3.0001, 0.5001, 207, 83, 0, 200, 0, 0, 0, 0)
            if GetDistanceBetweenCoords(pound.x, pound.y, pound.z, GetEntityCoords(LocalPed())) < 3 and IsPedInAnyVehicle(LocalPed(), true) == false then
                ShowInfo(lang_string.menu12, 0)
                if IsControlJustPressed(1, 86) then
                    garageSelected.x = pound.x
                    garageSelected.y = pound.y
                    garageSelected.z = pound.z
                    garageSelected.a = pound.a
                    MenuCarPound()
                    Menu.hidden = not Menu.hidden
                end
                Menu.renderGUI()
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local near = false
        Citizen.Wait(0)
        for _, garage in pairs(garages) do
            if (GetDistanceBetweenCoords(garage.x, garage.y, garage.z, GetEntityCoords(LocalPed())) < 3 and near ~= true) then
                near = true
            end
        end
        for _, pound in pairs(car_pounds) do
            if (GetDistanceBetweenCoords(pound.x, pound.y, pound.z, GetEntityCoords(LocalPed())) < 3 and near ~= true) then
                near = true
            end
        end
        if near == false then
            Menu.hidden = true;
        end
    end
end)

Citizen.CreateThread(function()
    for _, item in pairs(garages) do
        item.blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(item.blip, item.id)
        SetBlipAsShortRange(item.blip, true)
        SetBlipScale(item.blip, 0.85)
        SetBlipColour(item.blip, item.colour)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.name)
        EndTextCommandSetBlipName(item.blip)
    end

    for _, item in pairs(car_pounds) do
        item.blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(item.blip, item.id)
        SetBlipAsShortRange(item.blip, true)
        SetBlipScale(item.blip, 0.85)
        SetBlipColour(item.blip, item.colour)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.name)
        EndTextCommandSetBlipName(item.blip)
    end
end)

Citizen.CreateThread(function()
    local loc = vente_location
    pos = vente_location
    local blip = AddBlipForCoord(pos[1], pos[2], pos[3])
    SetBlipSprite(blip, 207)
    SetBlipColour(blip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(ventenamefr)
    EndTextCommandSetBlipName(blip)
    SetBlipAsShortRange(blip, true)
    SetBlipAsMissionCreatorBlip(blip, true)
    checkgarage = 0
    while true do
        Wait(0)
        DrawMarker(1, vente_location[1], vente_location[2], vente_location[3], 0, 0, 0, 0, 0, 0, 3.001, 3.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
        if GetDistanceBetweenCoords(vente_location[1], vente_location[2], vente_location[3], GetEntityCoords(LocalPed())) < 5 and IsPedInAnyVehicle(LocalPed(), true) == false then
            drawTxt(lang_string.menu10, 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
            if IsControlJustPressed(1, 86) then
                local caissei = GetClosestVehicle(vente_location[1], vente_location[2], vente_location[3], 3.000, 0, 70)
                SetEntityAsMissionEntity(caissei, true, true)
                local platecaissei = GetVehicleNumberPlateText(caissei)
                if DoesEntityExist(caissei) then
                    TriggerServerEvent('ply_garages:CheckForSelVeh', platecaissei)
                else
                    drawNotification(lang_string.text6)
                end
            end
        end
    end
end)


--[[Events]]--

AddEventHandler("ply_garages:getVehicles", function(THEVEHICLES)
    VEHICLES = {}
    VEHICLES = THEVEHICLES
end)

AddEventHandler("playerSpawned", function()
    local lang = "FR"
    TriggerServerEvent("ply_garages:CheckGarageForVeh")
    TriggerServerEvent("ply_garages:Lang", lang)
    configLang(lang)
end)
AddEventHandler('ply_garages:SpawnVehicle', function(vehicle, plate, state, primarycolor, secondarycolor, pearlescentcolor, wheelcolor, plateindex, neoncolor1, neoncolor2, neoncolor3, windowtint, wheeltype, mods0, mods1, mods2, mods3, mods4, mods5, mods6, mods7, mods8, mods9, mods10, mods11, mods12, mods13, mods14, mods15, mods16, turbo, tiresmoke, xenon, mods23, mods24, neon0, neon1, neon2, neon3, bulletproof, smokecolor1, smokecolor2, smokecolor3, variation)
    local car = GetHashKey(vehicle)
    local plate = plate
    local state = state
    local primarycolor = tonumber(primarycolor)
    local secondarycolor = tonumber(secondarycolor)
    local pearlescentcolor = pearlescentcolor
    local wheelcolor = wheelcolor

    local plateindex = tonumber(plateindex)
    local neoncolor = { neoncolor1, neoncolor2, neoncolor3 }
    local windowtint = windowtint
    local wheeltype = tonumber(wheeltype)
    local mods0 = tonumber(mods0)
    local mods1 = tonumber(mods1)
    local mods2 = tonumber(mods2)
    local mods3 = tonumber(mods3)
    local mods4 = tonumber(mods4)
    local mods5 = tonumber(mods5)
    local mods6 = tonumber(mods6)
    local mods7 = tonumber(mods7)
    local mods8 = tonumber(mods8)
    local mods9 = tonumber(mods9)
    local mods10 = tonumber(mods10)
    local mods11 = tonumber(mods11)
    local mods12 = tonumber(mods12)
    local mods13 = tonumber(mods13)
    local mods14 = tonumber(mods14)
    local mods15 = tonumber(mods15)
    local mods16 = tonumber(mods16)
    local turbo = turbo
    local tiresmoke = tiresmoke
    local xenon = xenon
    local mods23 = tonumber(mods23)
    local mods24 = tonumber(mods24)
    local neon0 = neon0
    local neon1 = neon1
    local neon2 = neon2
    local neon3 = neon3
    local bulletproof = bulletproof
    local smokecolor1 = smokecolor1
    local smokecolor2 = smokecolor2
    local smokecolor3 = smokecolor3
    local variation = variation
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        local caisseo = GetClosestVehicle(garageSelected.x, garageSelected.y, garageSelected.z, 3.000, 0, 70)
        if DoesEntityExist(caisseo) then
            drawNotification(lang_string.text1)
        else
            if state == lang_string.state1 then
                drawNotification(lang_string.text2)
            else
                local mods = {}
                for i = 0, 24 do
                    mods[i] = GetVehicleMod(veh, i)
                end
                RequestModel(car)
                while not HasModelLoaded(car) do
                    Citizen.Wait(0)
                end
                local veh = CreateVehicle(car, garageSelected.x, garageSelected.y, garageSelected.z, garageSelected.a, true, false)
                SetEntityAsMissionEntity(veh, true, true)
                --      ToggleVehicleMod(car, button.modtype, false)
                SetVehicleNumberPlateText(veh, plate)
                SetVehicleOnGroundProperly(veh)
                SetVehicleHasBeenOwnedByPlayer(veh, true)
                local id = NetworkGetNetworkIdFromEntity(veh)
                SetNetworkIdCanMigrate(id, true)
                SetVehicleColours(veh, primarycolor, secondarycolor)
                SetVehicleExtraColours(veh, tonumber(pearlescentcolor), tonumber(wheelcolor))
                SetVehicleNumberPlateTextIndex(veh, plateindex)
                SetVehicleNeonLightsColour(veh, tonumber(neoncolor[1]), tonumber(neoncolor[2]), tonumber(neoncolor[3]))
                SetVehicleTyreSmokeColor(veh, tonumber(smokecolor1), tonumber(smokecolor2), tonumber(smokecolor3))
                SetVehicleModKit(veh, 0)
                SetVehicleMod(veh, 0, mods0)
                SetVehicleMod(veh, 1, mods1)
                SetVehicleMod(veh, 2, mods2)
                SetVehicleMod(veh, 3, mods3)
                SetVehicleMod(veh, 4, mods4)
                SetVehicleMod(veh, 5, mods5)
                SetVehicleMod(veh, 6, mods6)
                SetVehicleMod(veh, 7, mods7)
                SetVehicleMod(veh, 8, mods8)
                SetVehicleMod(veh, 9, mods9)
                SetVehicleMod(veh, 10, mods10)
                SetVehicleMod(veh, 11, mods11)
                SetVehicleMod(veh, 12, mods12)
                SetVehicleMod(veh, 13, mods13)
                SetVehicleMod(veh, 14, mods14)
                SetVehicleMod(veh, 15, mods15)
                SetVehicleMod(veh, 16, mods16)
                if turbo == "on" then
                    ToggleVehicleMod(veh, 18, true)
                else
                    ToggleVehicleMod(veh, 18, false)
                end
                if tiresmoke == "on" then
                    ToggleVehicleMod(veh, 20, true)
                else
                    ToggleVehicleMod(veh, 20, false)
                end
                if xenon == "on" then
                    ToggleVehicleMod(veh, 22, true)
                else
                    ToggleVehicleMod(veh, 22, false)
                end
                SetVehicleWheelType(veh, tonumber(wheeltype))
                SetVehicleMod(veh, 23, mods23)
                SetVehicleMod(veh, 24, mods24)
                if neon0 == "on" then
                    SetVehicleNeonLightEnabled(veh, 0, true)
                else
                    SetVehicleNeonLightEnabled(veh, 0, false)
                end
                if neon1 == "on" then
                    SetVehicleNeonLightEnabled(veh, 1, true)
                else
                    SetVehicleNeonLightEnabled(veh, 1, false)
                end
                if neon2 == "on" then
                    SetVehicleNeonLightEnabled(veh, 2, true)
                else
                    SetVehicleNeonLightEnabled(veh, 2, false)
                end
                if neon3 == "on" then
                    SetVehicleNeonLightEnabled(veh, 3, true)
                else
                    SetVehicleNeonLightEnabled(veh, 3, false)
                end
                if bulletproof == "on" then
                    SetVehicleTyresCanBurst(veh, false)
                else
                    SetVehicleTyresCanBurst(veh, true)
                end
                --if variation == "on" then
                --  SetVehicleModVariation(veh,23)
                --else
                --  SetVehicleModVariation(veh,23, false)
                --end
                SetVehicleWindowTint(veh, tonumber(windowtint))
                TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                SetEntityInvincible(veh, false)
                drawNotification(lang_string.text3)
                TriggerServerEvent('ply_garages:SetVehOut', vehicle, plate)
                TriggerServerEvent("ply_garages:CheckGarageForVeh")
                TriggerEvent('garages:setPersonalVehicle', veh)
            end
        end
    end)
end)

AddEventHandler('ply_garages:StoreVehicleTrue', function()
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        local caissei = GetClosestVehicle(garageSelected.x, garageSelected.y, garageSelected.z, 3.000, 0, 70)
        SetEntityAsMissionEntity(caissei, true, true)
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
        drawNotification(lang_string.text5)
        RemoveBlip(personalVehicleBlip)
        personalVehicle = false
        TriggerServerEvent("ply_garages:CheckGarageForVeh")
    end)
end)

AddEventHandler('ply_garages:StoreVehicleFalse', function()
    drawNotification(lang_string.text4)
end)

AddEventHandler('ply_garages:SelVehicleTrue', function()
    Citizen.CreateThread(function()
        Citizen.Wait(0)
        local caissei = GetClosestVehicle(vente_location[1], vente_location[2], vente_location[3], 3.000, 0, 70)
        SetEntityAsMissionEntity(caissei, true, true)
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
        drawNotification(lang_string.text7)
        TriggerServerEvent("ply_garages:CheckGarageForVeh")
    end)
end)

AddEventHandler('ply_garages:SelVehicleFalse', function()
    drawNotification(lang_string.text4)
end)

AddEventHandler('ply_garages:BuyTrue', function()
    drawNotification(lang_string.text8)
    TriggerServerEvent("ply_garages:CheckGarageForVeh")
end)

AddEventHandler('ply_garages:BuyFalse', function()
    drawNotification(lang_string.text9)
end)

AddEventHandler('ply_garages:UpdateDone', function()
    drawNotification(lang_string.text10)
end)

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
    if firstspawn == 0 then
        RemoveIpl('v_carshowroom')
        RemoveIpl('shutter_open')
        RemoveIpl('shutter_closed')
        RemoveIpl('shr_int')
        RemoveIpl('csr_inMission')
        RequestIpl('v_carshowroom')
        RequestIpl('shr_int')
        RequestIpl('shutter_closed')
        firstspawn = 1
    end
end)

-- Rudz --
RegisterNetEvent('garages:swapLockPersonalVehicle')
AddEventHandler('garages:swapLockPersonalVehicle', function()
    if personalVehicle ~= false then
        local lockRange = 15.0
        local playerPos = GetEntityCoords(LocalPed(), true)
        local personalVehiclePos = GetEntityCoords(personalVehicle, true)
        if (Vdist(playerPos.x, playerPos.y, playerPos.z, personalVehiclePos.x, personalVehiclePos.y, personalVehiclePos.z) < lockRange) then
            local locked = GetVehicleDoorLockStatus(personalVehicle)
            if (locked == 1 or locked == 0) then
                SetVehicleDoorsLocked(personalVehicle, 2)
                TriggerEvent('showNotify', "Votre ~b~véhicule~w~ est ~g~verrouillée~w~.")
                TriggerEvent('InteractSound_CL:PlayOnOne', 'lock', 1.0)
            else
                SetVehicleDoorsLocked(personalVehicle, 1)
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

RegisterNetEvent('garages:vehicleIsDestroyed')
AddEventHandler('garages:vehicleIsDestroyed', function()
    RemoveBlip(personalVehicleBlip)
    personalVehicle = false
    TriggerEvent('showNotify', "~r~Votre véhicule personnel a été détruit !")
end)

RegisterNetEvent('garages:setPersonalVehicle')
AddEventHandler('garages:setPersonalVehicle', function(vehicle)
    personalVehicle = vehicle
    personalVehicleBlip = SetVehicleBlip(personalVehicle, 225, "Véhicule personnel", 4)
end)

--[[

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if (personalVehicle ~= false) then
      if (tonumber(GetVehicleCauseOfDestruction(personalVehicle) ~= 0) or (IsVehicleDriveable(personalVehicle, 0)) == false) then
        TriggerEvent('garages:vehicleIsDestroyed')
      end
      if not IsVehicleDamaged(personalVehicle) then
        SetVehicleUndriveable(personalVehicle, 0)
      end
    end
  end
end)

]]--