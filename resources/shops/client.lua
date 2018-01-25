-- PNJ-Stores --

local pedshop = {
    { type = 5, hash = 0x18ce57d0, x = -46.313, y = -1757.504, z = 29.421, a = 46.395 },
    { type = 5, hash = 0x18ce57d0, x = 24.376, y = -1345.558, z = 29.421, a = 267.940 },
    { type = 5, hash = 0x18ce57d0, x = 1134.182, y = -982.477, z = 46.416, a = 275.432 },
    { type = 5, hash = 0x18ce57d0, x = 373.015, y = 328.332, z = 103.566, a = 257.309 },
    { type = 5, hash = 0x18ce57d0, x = 2676.389, y = 3280.362, z = 55.241, a = 332.305 },
    { type = 5, hash = 0x18ce57d0, x = 1958.960, y = 3741.979, z = 32.344, a = 303.196 },
    { type = 5, hash = 0x18ce57d0, x = -2966.391, y = 391.324, z = 15.043, a = 88.867 },
    { type = 5, hash = 0x18ce57d0, x = 1698.542, y = 4922.583, z = 42.064, a = 324.021 },
    { type = 5, hash = 0x18ce57d0, x = 1164.565, y = -322.121, z = 69.205, a = 100.492 },
    { type = 5, hash = 0x18ce57d0, x = -1486.530, y = -377.768, z = 40.163, a = 147.669 },
    { type = 5, hash = 0x18ce57d0, x = -1221.568, y = -908.121, z = 12.326, a = 31.739 },
    { type = 5, hash = 0x18ce57d0, x = -706.153, y = -913.464, z = 19.216, a = 82.056 },
    { type = 5, hash = 0x18ce57d0, x = 2556.797, y = 380.873, z = 108.639, a = 357.854 },
    { type = 5, hash = 0x18ce57d0, x = 549.348, y = 2670.728, z = 42.156, a = 102.934 },
    { type = 5, hash = 0x18ce57d0, x = 1392.332, y = 3606.547, z = 3406.547, a = 199.341 },
    { type = 5, hash = 0x18ce57d0, x = 1727.748, y = 6415.631, z = 35.037, a = 246.222 },
    { type = 5, hash = 0x18ce57d0, x = -3039.33, y = 584.131, z = 7.901, a = 25.0 },
    { type = 5, hash = 0x18ce57d0, x = -1819.83, y = 793.918, z = 138.084, a = 120.0 },
}

-------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    -- Load the ped modal (0x18ce57d0)
    RequestModel("mp_m_shopkeep_01")
    while not HasModelLoaded("mp_m_shopkeep_01") do
        Wait(1)
    end
    ----------------------------------------------------------------------------------
    for _, item in pairs(pedshop) do
        pedshop = CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
        SetPedCombatAttributes(pedshop, 46, false)
        SetPedFleeAttributes(pedshop, 0, 0)
        SetPedArmour(pedshop, 500)
        SetPedMaxHealth(pedshop, 500)
        SetPedCanRagdoll(pedshop, true)
        SetPedDiesWhenInjured(pedshop, true)
        SetBlockingOfNonTemporaryEvents(pedshop, false)
    end
end)

-- Stores --

local shops = {
    { ['x'] = 1961.1140136719, ['y'] = 3741.4494628906, ['z'] = 31.34375 },
    { ['x'] = 1392.4129638672, ['y'] = 3604.47265625, ['z'] = 33.980926513672 },
    { ['x'] = 546.98962402344, ['y'] = 2670.3176269531, ['z'] = 41.156539916992 },
    { ['x'] = 2556.2534179688, ['y'] = 382.876953125, ['z'] = 107.62294769287 },
    { ['x'] = -1821.9542236328, ['y'] = 792.40191650391, ['z'] = 137.13920593262 },
    { ['x'] = 128.1410369873, ['y'] = -1286.1120605469, ['z'] = 28.281036376953 },
    { ['x'] = -1223.6690673828, ['y'] = -906.67517089844, ['z'] = 11.326356887817 },
    { ['x'] = -708.19256591797, ['y'] = -914.65264892578, ['z'] = 18.215591430664 },
    { ['x'] = 26.419162750244, ['y'] = -1347.5804443359, ['z'] = 28.497024536133 },
    { ['x'] = 1730.01, ['y'] = 6414.24, ['z'] = 33.8073 },
    { ['x'] = -3039.88, ['y'] = 587.23, ['z'] = 6.90 },
    { ['x'] = -49.413, ['y'] = -1756.264, ['z'] = 28.421 },
    { ['x'] = 375.015, ['y'] = 325.732, ['z'] = 102.566 },
    { ['x'] = 2679.71, ['y'] = 3282.02, ['z'] = 54.241 },
    { ['x'] = -2969.64, ['y'] = 389.824, ['z'] = 14.043 },
    { ['x'] = 1699.342, ['y'] = 4925.443, ['z'] = 41.064 },
    { ['x'] = 1162.165, ['y'] = -323.451, ['z'] = 68.205 },
    { ['x'] = -1487.0, ['y'] = -381.0, ['z'] = 39.163 },
}

-- Menu --

local buttoncount = 0
local requiredMenuDistance = 3.0
local requiredMarkerDistance = 15.0
local backlock = false

local shopmenu = {
    opened = false,
    title = "Épicerie",
    currentmenu = "main",
    lastmenu = nil,
    currentpos = nil,
    selectedbutton = 0,
    marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
    menu = {
        x = 0.88,
        y = 0.17,
        width = 0.2,
        height = 0.04,
        buttons = 10,
        from = 1,
        to = 10,
        scale = 0.4,
        font = 0,
        ["main"] = {
            title = "ARTICLES",
            name = "main",
            buttons = {
                {
                    title = "Eau",
                    name = "Eau",
                    price = 8,
                    id = 1,
                    quantity = 1
                },
                {
                    title = "Hamburger",
                    name = "Hamburger",
                    price = 16,
                    id = 2,
                    quantity = 1
                },
                {
                    title = "Sandwich",
                    name = "Sandwich",
                    price = 12,
                    id = 3,
                    quantity = 1
                },
                {
                    title = "Jus d\'orange",
                    name = "Jus d\'orange",
                    price = 10,
                    id = 26,
                    quantity = 1
                },
                {
                    title = "Cola",
                    name = "Cola",
                    price = 10,
                    id = 27,
                    quantity = 1
                },
                {
                    title = "Vodka",
                    name = "Vodka",
                    price = 30,
                    id = 28,
                    quantity = 1
                },
                {
                    title = "Kit de crochetage",
                    name = "Crochet",
                    price = 455,
                    id = 30,
                    quantity = 1
                }
            }
        }
    }
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for _, item in pairs(shops) do
            local playerToShopDistance = GetDistanceBetweenCoords(item.x, item.y, item.z, GetEntityCoords(GetPlayerPed(-1)))
            if playerToShopDistance < requiredMenuDistance then
                if shopmenu.opened then
                    ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour ~b~fermer~w~ le menu.', 0)
                    if IsControlJustPressed(1, 38) then
                        CloseCreator()
                    end
                else
                    ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour ~b~acheter~w~ des ~y~articles~w~.', 0)
                    if IsControlJustPressed(1, 38) then
                        OpenCreator()
                    end
                end
            end
            if playerToShopDistance < requiredMarkerDistance then
                DrawMarker(1, item.x, item.y, item.z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
            end
        end

        if shopmenu.opened then
            local menu = shopmenu.menu[shopmenu.currentmenu]
            drawTxt(shopmenu.title, 1, 1, shopmenu.menu.x, shopmenu.menu.y, 1.0, 255, 255, 255, 255)
            drawMenuTitle(menu.title, shopmenu.menu.x, shopmenu.menu.y + 0.08)
            drawTxt(shopmenu.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, shopmenu.menu.x + shopmenu.menu.width / 2 - 0.0385, shopmenu.menu.y + 0.067, 0.4, 255, 255, 255, 255)
            local y = shopmenu.menu.y + 0.12
            buttoncount = tablelength(menu.buttons)
            local selected = false

            for i, button in pairs(menu.buttons) do
                if i >= shopmenu.menu.from and i <= shopmenu.menu.to then

                    if i == shopmenu.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button, shopmenu.menu.x, y, selected)
                    drawMenuRight(button.price .. " $", shopmenu.menu.x, y, selected)
                    y = y + 0.04

                    if selected and IsControlJustPressed(1, 201) then
                        ButtonSelected(button)
                    end
                end
            end

            if IsControlJustPressed(1, 202) then
                Back()
            end

            if IsControlJustReleased(1, 202) then
                backlock = false
            end

            if IsControlJustPressed(1, 188) then
                if shopmenu.selectedbutton > 1 then
                    shopmenu.selectedbutton = shopmenu.selectedbutton - 1
                    if buttoncount > 10 and shopmenu.selectedbutton < shopmenu.menu.from then
                        shopmenu.menu.from = shopmenu.menu.from - 1
                        shopmenu.menu.to = shopmenu.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1, 187) then
                if shopmenu.selectedbutton < buttoncount then
                    shopmenu.selectedbutton = shopmenu.selectedbutton + 1
                    if buttoncount > 10 and shopmenu.selectedbutton > shopmenu.menu.to then
                        shopmenu.menu.to = shopmenu.menu.to + 1
                        shopmenu.menu.from = shopmenu.menu.from + 1
                    end
                end
            end

            if not isCloseToShop() then
                CloseCreator()
            end
        end
    end
end)

-- Blips --

Citizen.CreateThread(function()
    for _, item in pairs(shops) do
        local blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(blip, 59)
        SetBlipColour(blip, 36)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Épicerie")
        EndTextCommandSetBlipName(blip)
    end
end)

-- Functions --

function isCloseToShop()
    for _, item in pairs(shops) do
        if GetDistanceBetweenCoords(item.x, item.y, item.z, GetEntityCoords(GetPlayerPed(-1))) < requiredMenuDistance then
            return true
        end
    end
    return false
end

function OpenCreator()
    shopmenu.currentmenu = "main"
    shopmenu.opened = true
    shopmenu.selectedbutton = 0
end

function CloseCreator()
    shopmenu.opened = false
    shopmenu.menu.from = 1
    shopmenu.menu.to = 10
end

function ButtonSelected(button)
    TriggerServerEvent('inventory:buyItem', button.id, button.quantity, button.price)
end

function drawMenuButton(button, x, y, selected)
    local menu = shopmenu.menu
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
    AddTextComponentString(button.title)
    if selected then
        DrawRect(x, y, menu.width, menu.height, 255, 255, 255, 255)
    else
        DrawRect(x, y, menu.width, menu.height, 0, 0, 0, 150)
    end
    DrawText(x - menu.width / 2 + 0.005, y - menu.height / 2 + 0.0028)
end

function OpenMenu(menu)
    shopmenu.lastmenu = shopmenu.currentmenu
    shopmenu.menu.from = 1
    shopmenu.menu.to = 10
    shopmenu.selectedbutton = 0
    shopmenu.currentmenu = menu
end

function Back()
    if backlock then
        return
    end
    backlock = true
    if shopmenu.currentmenu == "main" then
        CloseCreator()
    else
        OpenMenu(shopmenu.lastmenu)
    end
end

function drawMenuInfo(text)
    local menu = shopmenu.menu
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
    local menu = shopmenu.menu
    SetTextFont(menu.font)
    SetTextProportional(0)
    SetTextScale(menu.scale, menu.scale)
    if selected then
        SetTextColour(0, 0, 0, 255)
    else
        SetTextColour(255, 255, 255, 255)
    end
    SetTextCentre(0)
    SetTextRightJustify(1)
    SetTextWrap(0.88, 0.975)
    SetTextEntry("STRING")
    AddTextComponentString(txt)
    DrawText(x + menu.width / 2 - 0.035, y - menu.height / 2 + 0.0028)
end

function drawMenuTitle(txt, x, y)
    local menu = shopmenu.menu
    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(txt)
    DrawRect(x, y, menu.width, menu.height, 0, 0, 0, 150)
    DrawText(x - menu.width / 2 + 0.005, y - menu.height / 2 + 0.0028)
end

function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, state, 0, -1)
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

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end
