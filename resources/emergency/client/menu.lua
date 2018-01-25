-----------------------------------------------------------------------------------------------------------------
----------------------------------------------------- COPS MENU---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local menuEMS = {
    opened = false,
    title = "Menu Secours",
    currentmenu = "main",
    lastmenu = nil,
    currentpos = nil,
    selectedbutton = 0,
    marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
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
                { name = "Actions", description = "" },
                { name = "Véhicule", description = "" },
            }
        },
        ["Actions"] = {
            title = "ACTIONS",
            name = "Actions",
            buttons = {
                { name = "Soigner un citoyen", description = '' },
                { name = "Réanimer un citoyen", description = '' },
            }
        },
        ["Véhicule"] = {
            title = "VEHICULE",
            name = "Véhicule",
            buttons = {
                { name = "Ouvrir / verrouiller le véhicule", description = '' },
            }
        },
    }
}

-------------------------------------------------
---------------- CONFIG SELECTION----------------
-------------------------------------------------
function ButtonSelectedEMS(button)
    local ped = GetPlayerPed(-1)
    local this = menuEMS.currentmenu
    local btn = button.name
    if this == "main" then
        if btn == "Actions" then
            OpenMenuEMS('Actions')
        elseif btn == "Véhicule" then
            OpenMenuEMS('Véhicule')
        end
    elseif this == "Actions" then
        if btn == "Soigner un citoyen" then
            SendNotification('Vous cherchez un citoyen blessé.')
            TriggerEvent('ems:findInjuredPlayers')
        elseif btn == "Réanimer un citoyen" then
            SendNotification('Vous cherchez un citoyen inconscient.')
            TriggerEvent('ems:findDeadPlayers')
        end
    elseif this == "Véhicule" then
        if btn == "Ouvrir / verrouiller le véhicule" then
            SwapLockActiveVehicle()
        end
    end
end

-------------------------------------------------
------------ FONCTION INTERACTION VEHICLE---------
-------------------------------------------------
function SwapLockActiveVehicle()
    Citizen.CreateThread(function()
        TriggerEvent('ems:swapLockEMSVehicle')
    end)
end


-------------------------------------------------
---------------- CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenMenuEMS(menu)
    menuEMS.lastmenu = menuEMS.currentmenu
    if menu == "Actions" then
        menuEMS.lastmenu = "main"
    elseif menu == "Véhicule" then
        menuEMS.lastmenu = "main"
    end
    menuEMS.menu.from = 1
    menuEMS.menu.to = 10
    menuEMS.selectedbutton = 0
    menuEMS.currentmenu = menu
end

-------------------------------------------------
------------------ DRAW NOTIFY--------------------
-------------------------------------------------
function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

--------------------------------------
------------- DISPLAY HELP TEXT--------
--------------------------------------
function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-------------------------------------------------
------------------ DRAW TITLE MENU----------------
-------------------------------------------------
function drawMenuTitle(txt, x, y)
    local menu = menuEMS.menu
    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(txt)
    DrawRect(x, y, menu.width, menu.height, 117, 202, 93, 150)
    DrawText(x - menu.width / 2 + 0.005, y - menu.height / 2 + 0.0028)
end

-------------------------------------------------
------------------ DRAW MENU BOUTON---------------
-------------------------------------------------
function drawMenuButton(button, x, y, selected)
    local menu = menuEMS.menu
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

-------------------------------------------------
------------------ DRAW MENU INFO-----------------
-------------------------------------------------
function drawMenuInfo(text)
    local menu = menuEMS.menu
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

-------------------------------------------------
---------------- DRAW MENU DROIT------------------
-------------------------------------------------
function drawMenuRight(txt, x, y, selected)
    local menu = menuEMS.menu
    SetTextFont(menu.font)
    SetTextProportional(0)
    SetTextScale(menu.scale, menu.scale)
    --SetTextRightJustify(1)
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

-------------------------------------------------
------------------- DRAW TEXT---------------------
-------------------------------------------------
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

-------------------------------------------------
---------------- CONFIG BACK MENU-----------------
-------------------------------------------------
function BackMenuEMS()
    if menuEMS.currentmenu == "Actions"
        or menuEMS.currentmenu == "Véhicule" then
        OpenMenuEMS(menuEMS.lastmenu)
    else
        CloseMenuEMS()
    end
end

-------------------------------------------------
--------------------- FONCTION--------------------
-------------------------------------------------
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
function OpenEMSMenu()
    menuEMS.currentmenu = "main"
    menuEMS.opened = true
    menuEMS.selectedbutton = 0
end

-------------------------------------------------
---------------- FONCTION CLOSE-------------------
-------------------------------------------------
function CloseMenuEMS()
    menuEMS.opened = false
    menuEMS.menu.from = 1
    menuEMS.menu.to = 10
end

-------------------------------------------------
---------------- FONCTION OPEN MENU---------------
------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (isEMS) then
            if (isInService) then
                if menuEMS.opened then
                    local ped = LocalPed()
                    local menu = menuEMS.menu[menuEMS.currentmenu]
                    drawTxt(menuEMS.title, 1, 1, menuEMS.menu.x, menuEMS.menu.y, 1.0, 255, 255, 255, 255)
                    drawMenuTitle(menu.title, menuEMS.menu.x, menuEMS.menu.y + 0.08)
                    drawTxt(menuEMS.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, menuEMS.menu.x + menuEMS.menu.width / 2 - 0.0385, menuEMS.menu.y + 0.067, 0.4, 255, 255, 255, 255)
                    local y = menuEMS.menu.y + 0.12
                    buttoncount = tablelength(menu.buttons)
                    local selected = false

                    for i, button in pairs(menu.buttons) do
                        if i >= menuEMS.menu.from and i <= menuEMS.menu.to then

                            if i == menuEMS.selectedbutton then
                                selected = true
                            else
                                selected = false
                            end
                            drawMenuButton(button, menuEMS.menu.x, y, selected)
                            if button.distance ~= nil then
                                drawMenuRight(button.distance .. "m", menuEMS.menu.x, y, selected)
                            end
                            y = y + 0.04
                            if selected and IsControlJustPressed(1, 201) then
                                ButtonSelectedEMS(button)
                            end
                        end
                    end
                    if IsControlJustPressed(1, 177) then
                        BackMenuEMS()
                    end
                    if IsControlJustPressed(1, 188) then
                        if menuEMS.selectedbutton > 1 then
                            menuEMS.selectedbutton = menuEMS.selectedbutton - 1
                            if buttoncount > 10 and menuEMS.selectedbutton < menuEMS.menu.from then
                                menuEMS.menu.from = menuEMS.menu.from - 1
                                menuEMS.menu.to = menuEMS.menu.to - 1
                            end
                        end
                    end
                    if IsControlJustPressed(1, 187) then
                        if menuEMS.selectedbutton < buttoncount then
                            menuEMS.selectedbutton = menuEMS.selectedbutton + 1
                            if buttoncount > 10 and menuEMS.selectedbutton > menuEMS.menu.to then
                                menuEMS.menu.to = menuEMS.menu.to + 1
                                menuEMS.menu.from = menuEMS.menu.from + 1
                            end
                        end
                    end
                    if IsControlJustPressed(1, 166) then
                        CloseMenuEMS()
                    end
                else
                    if IsControlJustPressed(1, 166) then
                        OpenEMSMenu()
                    end
                end
            end
        end
    end
end)
