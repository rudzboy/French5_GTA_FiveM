--[[Register]]--

RegisterNetEvent("ply_docks:getBoat")
RegisterNetEvent('ply_docks:SpawnBoat')
RegisterNetEvent('ply_docks:StoreBoat')
RegisterNetEvent('ply_docks:BuyTrue')
RegisterNetEvent('ply_docks:BuyFalse')
RegisterNetEvent('ply_docks:StoreBoatTrue')
RegisterNetEvent('ply_docks:StoreBoatFalse')
RegisterNetEvent('ply_docks:SelBoatTrue')
RegisterNetEvent('ply_docks:SelBoatFalse')


--[[Local/Global]]--

BOATS = {}

local vente_location = { -774.553, -1425.26, -0.001 }
local ventenamefr = "Vente de véhicule"
local docks = {
    { name = "Dock", colour = 3, id = 356, x = -951.453, y = -1468.21, z = -0.001, axe = 290.000 },
}

dockSelected = { { x = nil, y = nil, z = nil }, }

--[[Functions]]--

function configLang(lang)
    local lang = lang
    if lang == "FR" then
        lang_string = {
            menu0 = "Rentrer le bateau",
            menu1 = "Marina",
            menu2 = "Sortir un bateau",
            menu3 = "Fermer",
            menu4 = "Bateaux",
            menu5 = "Retour",
            menu6 = "Sortir",
            menu7 = "~g~E~s~ pour ouvrir le menu",
            menu8 = "~g~E~s~ pour vendre le bateau à 50% du prix d\'achat",
            state1 = "Sortit",
            state2 = "Rentré",
            text1 = "~r~Aucun bateau présent.",
            text2 = "~r~La zone est encombrée.",
            text3 = "Ce bateau est ~b~déjà sorti~w~.",
            text4 = "Bateau sorti",
            text5 = "~r~Ce n\'est pas ton bateau",
            text6 = "Bateau rentré",
            text7 = "Bateau ~g~acheté~w~ !",
            text8 = "~r~Fonds insuffisants.",
            text9 = "Bateau vendu"
        }

    elseif lang == "EN" then
        lang_string = {
            menu0 = "Store the boat",
            menu1 = "Marina",
            menu2 = "Get a boat",
            menu3 = "Close",
            menu4 = "Boats",
            menu5 = "Back",
            menu6 = "Get",
            menu7 = "~g~E~s~ to open menu",
            menu8 = "~g~E~s~ to sell the boat at 50% of the purchase price",
            state1 = "Out",
            state2 = "In",
            text1 = "No boat present",
            text2 = "The area is crowded",
            text3 = "This boat is already out",
            text4 = "Boat out",
            text5 = "It's not your boat",
            text6 = "Boat stored",
            text7 = "Boat bought, good wind",
            text8 = "Insufficient funds",
            text9 = "Boat sold"
        }
    end
end



--[[Menu Dock]]--

function MenuDock()
    ped = GetPlayerPed(-1);
    MenuTitle = lang_string.menu1
    ClearMenu()
    Menu.addButton(lang_string.menu0, "RentrerBateau", nil)
    Menu.addButton(lang_string.menu2, "ListeBateau", nil)
    Menu.addButton(lang_string.menu3, "CloseMenu", nil)
end

function RentrerBateau()
    Citizen.CreateThread(function()
        local caissei = GetClosestVehicle(dockSelected.x, dockSelected.y, dockSelected.z, 3.000, 0, 12294)
        SetEntityAsMissionEntity(caissei, true, true)
        local plate = GetVehicleNumberPlateText(caissei)
        if DoesEntityExist(caissei) then
            TriggerServerEvent('ply_docks:CheckForBoat', plate)
        else
            drawNotification(lang_string.text1)
        end
    end)
    CloseMenu()
end

function ListeBateau()
    ped = GetPlayerPed(-1);
    MenuTitle = lang_string.menu4
    ClearMenu()
    for _, value in pairs(BOATS) do
        Menu.addButton(tostring(value.boat_name) .. " : " .. tostring(value.boat_state), "OptionBateau", value.id)
    end
    Menu.addButton(lang_string.menu5, "MenuDock", nil)
end

function OptionBateau(boatID)
    local boatID = boatID
    MenuTitle = "Options"
    ClearMenu()
    Menu.addButton(lang_string.menu6, "SortirBateau", boatID)
    Menu.addButton(lang_string.menu5, "ListeVBateau", nil)
end

function SortirBateau(boatID)
    local boatID = boatID
    TriggerServerEvent('ply_docks:CheckForSpawnBoat', boatID)
    CloseMenu()
end


--- Generic Fonction
function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function CloseMenu()
    Menu.hidden = true
    TriggerServerEvent("ply_docks:CheckDockForBoat")
end

function LocalPed()
    return GetPlayerPed(-1)
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

--dock
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, dock in pairs(docks) do
            DrawMarker(1, dock.x, dock.y, dock.z, 0, 0, 0, 0, 0, 0, 5.001, 5.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
            if GetDistanceBetweenCoords(dock.x, dock.y, dock.z, GetEntityCoords(LocalPed())) < 10 and IsPedInAnyVehicle(LocalPed(), true) == false then
                drawTxt(lang_string.menu7, 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                if IsControlJustPressed(1, 86) then
                    dockSelected.x = dock.x
                    dockSelected.y = dock.y
                    dockSelected.z = dock.z
                    dockSelected.axe = dock.axe
                    MenuDock()
                    Menu.hidden = not Menu.hidden
                end
                Menu.renderGUI()
            end
        end
    end
end)

--closmenurange
Citizen.CreateThread(function()
    while true do
        local near = false
        Citizen.Wait(0)
        for _, dock in pairs(docks) do
            if (GetDistanceBetweenCoords(dock.x, dock.y, dock.z, GetEntityCoords(LocalPed())) < 10 and near ~= true) then
                near = true
            end
        end
        if near == false then
            Menu.hidden = true;
        end
    end
end)

--blips
Citizen.CreateThread(function()
    for _, item in pairs(docks) do
        item.blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(item.blip, item.id)
        SetBlipAsShortRange(item.blip, true)
        SetBlipColour(item.blip, item.colour)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.name)
        EndTextCommandSetBlipName(item.blip)
    end
end)


--vente
Citizen.CreateThread(function()
    local pos = vente_location
    local blip = AddBlipForCoord(pos[1], pos[2], pos[3])
    SetBlipSprite(blip, 207)
    SetBlipColour(blip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(ventenamefr)
    EndTextCommandSetBlipName(blip)
    SetBlipAsShortRange(blip, true)
    SetBlipAsMissionCreatorBlip(blip, true)
    while true do
        Wait(0)
        DrawMarker(1, vente_location[1], vente_location[2], vente_location[3], 0, 0, 0, 0, 0, 0, 5.001, 5.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
        if GetDistanceBetweenCoords(vente_location[1], vente_location[2], vente_location[3], GetEntityCoords(LocalPed())) < 10 and IsPedInAnyVehicle(LocalPed(), true) == false then
            drawTxt(lang_string.menu8, 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
            if IsControlJustPressed(1, 86) then
                local caissei = GetClosestVehicle(vente_location[1], vente_location[2], vente_location[3], 10.000, 0, 12294)
                SetEntityAsMissionEntity(caissei, true, true)
                local platecaissei = GetVehicleNumberPlateText(caissei)
                if DoesEntityExist(caissei) then
                    TriggerServerEvent('ply_docks:CheckForSelBoat', platecaissei)
                else
                    drawNotification(lang_string.text1)
                end
            end
        end
    end
end)



--[[Events]]--

AddEventHandler("ply_docks:getBoat", function(THEBOATS)
    BOATS = {}
    BOATS = THEBOATS
end)

AddEventHandler("playerSpawned", function()
    local lang = "FR"
    TriggerServerEvent("ply_docks:CheckDockForBoat")
    TriggerServerEvent("ply_docks:Lang", lang)
    configLang(lang)
end)

AddEventHandler('ply_docks:SpawnBoat', function(boat, plate, state, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
    local boat = boat
    local car = GetHashKey(boat)
    local plate = plate
    local state = state
    local primarycolor = tonumber(primarycolor)
    local secondarycolor = tonumber(secondarycolor)
    local pearlescentcolor = tonumber(pearlescentcolor)
    local wheelcolor = tonumber(wheelcolor)
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        local caisseo = GetClosestVehicle(dockSelected.x, dockSelected.y, dockSelected.z, 10.000, 0, 12294)
        if DoesEntityExist(caisseo) then
            drawNotification(lang_string.text2)
        else
            if state == lang_string.state1 then
                drawNotification(lang_string.text3)
            else
                local mods = {}
                for i = 0, 24 do
                    mods[i] = GetVehicleMod(veh, i)
                end
                RequestModel(car)
                while not HasModelLoaded(car) do
                    Citizen.Wait(0)
                end
                local veh = CreateVehicle(car, dockSelected.x, dockSelected.y, dockSelected.z, dockSelected.axe, true, false)
                for i, mod in pairs(mods) do
                    SetVehicleModKit(personalvehicle, 0)
                    SetVehicleMod(personalvehicle, i, mod)
                end
                SetVehicleNumberPlateText(veh, plate)
                SetVehicleOnGroundProperly(veh)
                SetVehicleHasBeenOwnedByPlayer(veh, true)
                local id = NetworkGetNetworkIdFromEntity(veh)
                SetNetworkIdCanMigrate(id, true)
                SetVehicleColours(veh, primarycolor, secondarycolor)
                SetVehicleExtraColours(veh, pearlescentcolor, wheelcolor)
                SetEntityInvincible(veh, false)
                drawNotification(lang_string.text4)
                TriggerServerEvent('ply_docks:SetBoatOut', boat, plate)
                TriggerServerEvent("ply_docks:CheckDockForBoat")
            end
        end
    end)
end)

AddEventHandler('ply_docks:StoreBoatTrue', function()
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        local caissei = GetClosestVehicle(dockSelected.x, dockSelected.y, dockSelected.z, 10.000, 0, 12294)
        SetEntityAsMissionEntity(caissei, true, true)
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
        drawNotification(lang_string.text6)
        TriggerServerEvent("ply_docks:CheckDockForBoat")
    end)
end)

AddEventHandler('ply_docks:StoreBoatFalse', function()
    drawNotification(lang_string.text5)
end)

AddEventHandler('ply_docks:SelBoatTrue', function()
    Citizen.CreateThread(function()
        Citizen.Wait(0)
        local caissei = GetClosestVehicle(vente_location[1], vente_location[2], vente_location[3], 10.000, 0, 12294)
        SetEntityAsMissionEntity(caissei, true, true)
        Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(caissei))
        drawNotification(lang_string.text9)
        TriggerServerEvent("ply_docks:CheckDockForBoat")
    end)
end)

AddEventHandler('ply_docks:SelBoatFalse', function()
    drawNotification(lang_string.text5)
end)

AddEventHandler('ply_docks:BuyTrue', function()
    drawNotification(lang_string.text7)
    TriggerServerEvent("ply_docks:CheckDockForBoat")
end)

AddEventHandler('ply_docks:BuyFalse', function()
    drawNotification(lang_string.text8)
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
