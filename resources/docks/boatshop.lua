--[[Register]]--

RegisterNetEvent('ply_docks:FinishMoneyCheckForBoat')

--[[Local/Global]]--

local boatshop = {
    opened = false,
    title = "Capitainerie",
    currentmenu = "main",
    lastmenu = nil,
    currentpos = nil,
    selectedbutton = 0,
    marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
    menu = {
        x = 0.9,
        y = 0.08,
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
                { name = "Pneumatique", description = "" },
                { name = "Voiles", description = "" },
                { name = "Jetski", description = "" },
                { name = "Submersibles", description = "" },
                { name = "Chalutier", description = "" },
                { name = "Vedette", description = "" },
            }
        },
        ["Pneumatique"] = {
            title = "Pneumatique",
            name = "Pneumatique",
            buttons = {
                { name = "Dinghy", costs = 360000, description = {}, model = "dinghy" },
            }
        },
        ["Voiles"] = {
            title = "Voiles",
            name = "Voiles",
            buttons = {
                { name = "Marquis", costs = 285000, description = {}, model = "marquis" },
            }
        },
        ["Jetski"] = {
            title = "Jetski",
            name = "Jetski",
            buttons = {
                { name = "Seashark", costs = 107000, description = {}, model = "seashark" },
            }
        },
        ["submersibles"] = {
            title = "submersibles",
            name = "submersibles",
            buttons = {
                { name = "Kraken", costs = 450000, description = {}, model = "kraken" },
                { name = "Submersible", costs = 1665000, description = {}, model = "submersible" },
            }
        },
        ["Chalutier"] = {
            title = "Chalutier",
            name = "Chalutier",
            buttons = {
                { name = "Tug", costs = 190000, description = {}, model = "tug" },
            }
        },
        ["Vedette"] = {
            title = "Vedette",
            name = "Vedette",
            buttons = {
                { name = "Jetmax", costs = 750000, description = {}, model = "jetmax" },
                { name = "Speeder", costs = 1100000, description = {}, model = "speeder" },
                { name = "Squalo", costs = 615000, description = {}, model = "squalo" },
                { name = "Suntrap", costs = 182000, description = {}, model = "suntrap" },
                { name = "Toro", costs = 1200000, description = {}, model = "toro" },
                { name = "Tropic", costs = 156000, description = {}, model = "tropic" },
            }
        },
    }
}
local fakeboat = { model = '', car = nil }
local boatshop_locations = {
    {
        entering = { -876.383, -1324.72, 0.6001 },
        inside = { -871.091, -1351.19, -1.000, 190.000 },
        outside = { -871.091, -1351.19, 0.000, 190.000 }
    },
}
local boatshop_blips = {}
local inrangeofboatshop = false
local currentlocation = nil
local boughtboat = false
local boat_price = 0
local backlock = false
local firstspawn = 0

--[[Functions]]--

local function LocalPed()
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

function IsPlayerInRangeOfboatshop()
    return inrangeofboatshop
end

function ShowboatshopBlips(bool)
    if bool and #boatshop_blips == 0 then
        for station, pos in pairs(boatshop_locations) do
            local loc = pos
            pos = pos.entering
            local blip = AddBlipForCoord(pos[1], pos[2], pos[3])
            -- 60 58 137
            SetBlipSprite(blip, 410)
            SetBlipColour(blip, 3)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Capitainerie')
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip, true)
            SetBlipAsMissionCreatorBlip(blip, true)
            table.insert(boatshop_blips, { blip = blip, pos = loc })
        end
        Citizen.CreateThread(function()
            while #boatshop_blips > 0 do
                Citizen.Wait(0)
                local inrange = false
                for i, b in ipairs(boatshop_blips) do
                    DrawMarker(1, b.pos.entering[1], b.pos.entering[2], b.pos.entering[3], 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
                    if IsPlayerWantedLevelGreater(GetPlayerIndex(), 0) == false and boatshop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and GetDistanceBetweenCoords(b.pos.entering[1], b.pos.entering[2], b.pos.entering[3], GetEntityCoords(LocalPed())) < 5 then
                        drawTxt('Appuyer sur ~g~Entrée~s~ pour accéder au menu d\'achat', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        currentlocation = b
                        inrange = true
                    end
                end
                inrangeofboatshop = inrange
            end
        end)
    elseif bool == false and #boatshop_blips > 0 then
        for i, b in ipairs(boatshop_blips) do
            if DoesBlipExist(b.blip) then
                SetBlipAsMissionCreatorBlip(b.blip, false)
                Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
            end
        end
        boatshop_blips = {}
    end
end

function f(n)
    return n + 0.0001
end

function LocalPed()
    return GetPlayerPed(-1)
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

function OpenCreator()
    boughtboat = false
    local ped = LocalPed()
    local pos = currentlocation.pos.inside
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false)
    local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B, pos[1], pos[2], pos[3], Citizen.PointerValueFloat(), 0)
    SetEntityCoords(ped, pos[1], pos[2], g)
    SetEntityHeading(ped, pos[4])
    boatshop.currentmenu = "main"
    boatshop.opened = true
    boatshop.selectedbutton = 0
end

function CloseCreator(name, boat, price)
    Citizen.CreateThread(function()
        local ped = LocalPed()
        if not boughtboat then
            local pos = currentlocation.pos.entering
            SetEntityCoords(ped, pos[1], pos[2], pos[3])
            FreezeEntityPosition(ped, false)
            SetEntityVisible(ped, true)
        else
            local name = name
            local boat = boat
            local price = price
            local veh = GetVehiclePedIsUsing(ped)
            local model = GetEntityModel(veh)
            local colors = table.pack(GetVehicleColours(veh))
            local extra_colors = table.pack(GetVehicleExtraColours(veh))

            local mods = {}
            for i = 0, 24 do
                mods[i] = GetVehicleMod(veh, i)
            end
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
            local pos = currentlocation.pos.outside

            FreezeEntityPosition(ped, false)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            local personalboat = CreateVehicle(model, pos[1], pos[2], pos[3], pos[4], true, false)
            SetModelAsNoLongerNeeded(model)
            for i, mod in pairs(mods) do
                SetVehicleModKit(personalboat, 0)
                SetVehicleMod(personalboat, i, mod)
            end
            SetVehicleOnGroundProperly(personalboat)
            local plate = GetVehicleNumberPlateText(personalboat)
            SetVehicleHasBeenOwnedByPlayer(personalboat, true)
            local id = NetworkGetNetworkIdFromEntity(personalboat)
            SetNetworkIdCanMigrate(id, true)
            Citizen.InvokeNative(0x629BFA74418D6239, Citizen.PointerValueIntInitialized(personalboat))
            SetVehicleColours(personalboat, colors[1], colors[2])
            SetVehicleExtraColours(personalboat, extra_colors[1], extra_colors[2])
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), personalboat, -1)
            SetEntityVisible(ped, true)
            local primarycolor = colors[1]
            local secondarycolor = colors[2]
            local pearlescentcolor = extra_colors[1]
            local wheelcolor = extra_colors[2]
            TriggerServerEvent('ply_docks:BuyForBoat', name, boat, price, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
        end
        boatshop.opened = false
        boatshop.menu.from = 1
        boatshop.menu.to = 10
    end)
end

function drawMenuButton(button, x, y, selected)
    local menu = boatshop.menu
    SetTextFont(menu.font)
    SetTextProportional(0)
    SetTextScale(menu.scale, menu.scale)
    if selected then
        SetTextColour(0, 0, 0, 255)
    else
        SetTextColour(255, 255, 255, 255)
    end
    SetTextCentre(0)
    SetTextEntry("STRING")
    AddTextComponentString(button.name)
    if selected then
        DrawRect(x, y, menu.width, menu.height, 255, 255, 255, 255)
    else
        DrawRect(x, y, menu.width, menu.height, 0, 0, 0, 150)
    end
    DrawText(x - menu.width / 2 + 0.005, y - menu.height / 2 + 0.0028)
end

function drawMenuInfo(text)
    local menu = boatshop.menu
    SetTextFont(menu.font)
    SetTextProportional(0)
    SetTextScale(0.45, 0.45)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawRect(0.675, 0.95, 0.65, 0.050, 0, 0, 0, 150)
    DrawText(0.365, 0.934)
end

function drawMenuRight(txt, x, y, selected)
    local menu = boatshop.menu
    SetTextFont(menu.font)
    SetTextProportional(0)
    SetTextScale(menu.scale, menu.scale)
    SetTextRightJustify(1)
    if selected then
        SetTextColour(0, 0, 0, 255)
    else
        SetTextColour(255, 255, 255, 255)
    end
    SetTextCentre(0)
    SetTextEntry("STRING")
    AddTextComponentString(txt)
    DrawText(x + menu.width / 2 - 0.03, y - menu.height / 2 + 0.0028)
end

function drawMenuTitle(txt, x, y)
    local menu = boatshop.menu
    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(txt)
    DrawRect(x, y, menu.width, menu.height, 0, 0, 0, 150)
    DrawText(x - menu.width / 2 + 0.005, y - menu.height / 2 + 0.0028)
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function DoesPlayerHaveVehicle(model, button, y, selected)
    local t = false
    if t then
        drawMenuRight("Acheté", boatshop.menu.x, y, selected)
    else
        drawMenuRight(button.costs .. "$", boatshop.menu.x, y, selected)
    end
end

function round(num, idp)
    if idp and idp > 0 then
        local mult = 10 ^ idp
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

function ButtonSelected(button)
    local ped = GetPlayerPed(-1)
    local this = boatshop.currentmenu
    local btn = button.name
    if this == "main" then
        if btn == "Pneumatique" then
            OpenMenu('Pneumatique')
        elseif btn == "Voiles" then
            OpenMenu('Voiles')
        elseif btn == "Jetski" then
            OpenMenu('Jetski')
            --elseif btn == "Submersibles" then
            --	OpenMenu('Submersibles')
        elseif btn == "Chalutier" then
            OpenMenu('Chalutier')
        elseif btn == "Vedette" then
            OpenMenu('Vedette')
        end
        --elseif this == "Pneumatique" or this == "Voiles" or this == "Jetski" or this == "submersibles" or this == "Chalutier" then
    elseif this == "Pneumatique" or this == "Voiles" or this == "Jetski" or this == "Chalutier" or this == "Vedette" then
        TriggerServerEvent('ply_docks:CheckMoneyForBoat', button.name, button.model, button.costs)
    end
end

function OpenMenu(menu)
    fakeboat = { model = '', car = nil }
    boatshop.lastmenu = boatshop.currentmenu
    if menu == "Pneumatique" then
        boatshop.lastmenu = "main"
    elseif menu == "Voiles" then
        boatshop.lastmenu = "main"
    elseif menu == "Jetski" then
        boatshop.lastmenu = "main"
        --elseif menu == "submersibles"  then
        --	boatshop.lastmenu = "main"
    elseif menu == "Chalutier" then
        boatshop.lastmenu = "main"
    elseif menu == "Vedette" then
        boatshop.lastmenu = "main"
    end
    boatshop.menu.from = 1
    boatshop.menu.to = 10
    boatshop.selectedbutton = 0
    boatshop.currentmenu = menu
end

function Back()
    if backlock then
        return
    end
    backlock = true
    if boatshop.currentmenu == "main" then
        CloseCreator()
        --elseif boatshop.currentmenu == "Pneumatique" or boatshop.currentmenu == "Voiles" or boatshop.currentmenu == "Jetski" or boatshop.currentmenu == "submersibles" or boatshop.currentmenu == "Chalutier" then
    elseif boatshop.currentmenu == "Pneumatique" or boatshop.currentmenu == "Voiles" or boatshop.currentmenu == "Jetski" or boatshop.currentmenu == "Chalutier" or boatshop.currentmenu == "Vedette" then
        if DoesEntityExist(fakeboat.car) then
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakeboat.car))
        end
        fakeboat = { model = '', car = nil }
        OpenMenu(boatshop.lastmenu)
    else
        OpenMenu(boatshop.lastmenu)
    end
end

function stringstarts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

--[[Citizen]]--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 201) and IsPlayerInRangeOfboatshop() then
            if boatshop.opened then
                CloseCreator()
            else
                OpenCreator()
            end
        end
        if boatshop.opened then
            local ped = LocalPed()
            local menu = boatshop.menu[boatshop.currentmenu]
            drawTxt(boatshop.title, 1, 1, boatshop.menu.x, boatshop.menu.y, 1.0, 255, 255, 255, 255)
            drawMenuTitle(menu.title, boatshop.menu.x, boatshop.menu.y + 0.08)
            drawTxt(boatshop.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, boatshop.menu.x + boatshop.menu.width / 2 - 0.0385, boatshop.menu.y + 0.067, 0.4, 255, 255, 255, 255)
            local y = boatshop.menu.y + 0.12
            buttoncount = tablelength(menu.buttons)
            local selected = false

            for i, button in pairs(menu.buttons) do
                if i >= boatshop.menu.from and i <= boatshop.menu.to then

                    if i == boatshop.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button, boatshop.menu.x, y, selected)
                    if button.costs ~= nil then
                        --if boatshop.currentmenu == "Pneumatique" or boatshop.currentmenu == "Voiles" or boatshop.currentmenu == "Jetski" or boatshop.currentmenu == "submersibles" or boatshop.currentmenu == "Chalutier" then
                        if boatshop.currentmenu == "Pneumatique" or boatshop.currentmenu == "Voiles" or boatshop.currentmenu == "Jetski" or boatshop.currentmenu == "Chalutier" or boatshop.currentmenu == "Vedette" then
                            DoesPlayerHaveVehicle(button.model, button, y, selected)
                        else
                            drawMenuRight(button.costs .. "$", boatshop.menu.x, y, selected)
                        end
                    end
                    y = y + 0.04
                    --if boatshop.currentmenu == "Pneumatique" or boatshop.currentmenu == "Voiles" or boatshop.currentmenu == "Jetski" or boatshop.currentmenu == "submersibles" or boatshop.currentmenu == "Chalutier" then
                    if boatshop.currentmenu == "Pneumatique" or boatshop.currentmenu == "Voiles" or boatshop.currentmenu == "Jetski" or boatshop.currentmenu == "Chalutier" or boatshop.currentmenu == "Vedette" then
                        if selected then
                            if fakeboat.model ~= button.model then
                                if DoesEntityExist(fakeboat.car) then
                                    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakeboat.car))
                                end
                                local pos = currentlocation.pos.inside
                                local hash = GetHashKey(button.model)
                                RequestModel(hash)
                                while not HasModelLoaded(hash) do
                                    Citizen.Wait(0)
                                    drawTxt("~b~Chargement...", 0, 1, 0.5, 0.5, 1.5, 255, 255, 255, 255)
                                end
                                local veh = CreateVehicle(hash, pos[1], pos[2], pos[3], pos[4], false, false)
                                while not DoesEntityExist(veh) do
                                    Citizen.Wait(0)
                                    drawTxt("~b~Chargement...", 0, 1, 0.5, 0.5, 1.5, 255, 255, 255, 255)
                                end
                                FreezeEntityPosition(veh, true)
                                SetEntityInvincible(veh, true)
                                SetVehicleDoorsLocked(veh, 4)
                                --SetEntityCollision(veh,false,false)
                                TaskWarpPedIntoVehicle(LocalPed(), veh, -1)
                                for i = 0, 24 do
                                    SetVehicleModKit(veh, 0)
                                    RemoveVehicleMod(veh, i)
                                end
                                fakeboat = { model = button.model, car = veh }
                            end
                        end
                    end
                    if selected and IsControlJustPressed(1, 201) then
                        ButtonSelected(button)
                    end
                end
            end
        end
        if boatshop.opened then
            if IsControlJustPressed(1, 202) then
                Back()
            end
            if IsControlJustReleased(1, 202) then
                backlock = false
            end
            if IsControlJustPressed(1, 188) then
                if boatshop.selectedbutton > 1 then
                    boatshop.selectedbutton = boatshop.selectedbutton - 1
                    if buttoncount > 10 and boatshop.selectedbutton < boatshop.menu.from then
                        boatshop.menu.from = boatshop.menu.from - 1
                        boatshop.menu.to = boatshop.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1, 187) then
                if boatshop.selectedbutton < buttoncount then
                    boatshop.selectedbutton = boatshop.selectedbutton + 1
                    if buttoncount > 10 and boatshop.selectedbutton > boatshop.menu.to then
                        boatshop.menu.to = boatshop.menu.to + 1
                        boatshop.menu.from = boatshop.menu.from + 1
                    end
                end
            end
        end
    end
end)

--[[Events]]--

AddEventHandler('ply_docks:FinishMoneyCheckForBoat', function(name, boat, price)
    local name = name
    local boat = boat
    local price = price
    boughtboat = true
    CloseCreator(name, boat, price)
end)

AddEventHandler('playerSpawned', function(spawn)
    if firstspawn == 0 then
        ShowboatshopBlips(true)
        firstspawn = 1
    end
end)