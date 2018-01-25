-----------------------------------------------------------------------------------------------------------------
----------------------------------------------------- JOB MENU---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local MenuActivities = {
    opened = false,
    title = "Menu Métier",
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
                { name = "Véhicule", description = "" },
            }
        },
        ["Véhicule"] = {
            title = "VEHICULE",
            name = "Véhicule",
            buttons = {
                { name = "Ouvrir / verrouiller le véhicule", description = '' },
            }
        }
    }
}
-------------------------------------------------
---------------- CONFIG SELECTION----------------
-------------------------------------------------
function ButtonSelectedActivities(button)
    local ped = GetPlayerPed(-1)
    local this = MenuActivities.currentmenu
    local btn = button.name
    if this == "main" then
        if btn == "Véhicule" then
            OpenMenuActivities('Véhicule')
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
        TriggerEvent('activities:swapLockActiveVehicle')
    end)
end

-------------------------------------------------
---------------- CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenMenuActivities(menu)
    MenuActivities.lastmenu = MenuActivities.currentmenu
    if menu == "Véhicule" then
        MenuActivities.lastmenu = "main"
    end
    MenuActivities.menu.from = 1
    MenuActivities.menu.to = 10
    MenuActivities.selectedbutton = 0
    MenuActivities.currentmenu = menu
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
    local menu = MenuActivities.menu
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
    local menu = MenuActivities.menu
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
    local menu = MenuActivities.menu
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
    local menu = MenuActivities.menu
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
function BackMenuActivities()
    if MenuActivities.currentmenu == "Véhicule" then
        OpenMenuActivities(MenuActivities.lastmenu)
    else
        CloseMenuActivities()
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
function OpenActivitiesMenu()
    MenuActivities.currentmenu = "main"
    MenuActivities.opened = true
    MenuActivities.selectedbutton = 0
end

-------------------------------------------------
---------------- FONCTION CLOSE-------------------
-------------------------------------------------
function CloseMenuActivities()
    MenuActivities.opened = false
    MenuActivities.menu.from = 1
    MenuActivities.menu.to = 10
end

-------------------------------------------------
---------------- FONCTION OPEN MENU---------------
------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isInService then
            if MenuActivities.opened then
                local menu = MenuActivities.menu[MenuActivities.currentmenu]
                drawTxt(MenuActivities.title, 1, 1, MenuActivities.menu.x, MenuActivities.menu.y, 1.0, 255, 255, 255, 255)
                drawMenuTitle(menu.title, MenuActivities.menu.x, MenuActivities.menu.y + 0.08)
                drawTxt(MenuActivities.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, MenuActivities.menu.x + MenuActivities.menu.width / 2 - 0.0385, MenuActivities.menu.y + 0.067, 0.4, 255, 255, 255, 255)
                local y = MenuActivities.menu.y + 0.12
                buttoncount = tablelength(menu.buttons)
                local selected = false

                for i, button in pairs(menu.buttons) do
                    if i >= MenuActivities.menu.from and i <= MenuActivities.menu.to then

                        if i == MenuActivities.selectedbutton then
                            selected = true
                        else
                            selected = false
                        end
                        drawMenuButton(button, MenuActivities.menu.x, y, selected)
                        if button.distance ~= nil then
                            drawMenuRight(button.distance .. "m", MenuActivities.menu.x, y, selected)
                        end
                        y = y + 0.04
                        if selected and IsControlJustPressed(1, 201) then
                            ButtonSelectedActivities(button)
                        end
                    end
                end
                if IsControlJustPressed(1, 177) then
                    BackMenuActivities()
                end
                if IsControlJustPressed(1, 188) then
                    if MenuActivities.selectedbutton > 1 then
                        MenuActivities.selectedbutton = MenuActivities.selectedbutton - 1
                        if buttoncount > 10 and MenuActivities.selectedbutton < MenuActivities.menu.from then
                            MenuActivities.menu.from = MenuActivities.menu.from - 1
                            MenuActivities.menu.to = MenuActivities.menu.to - 1
                        end
                    end
                end
                if IsControlJustPressed(1, 187) then
                    if MenuActivities.selectedbutton < buttoncount then
                        MenuActivities.selectedbutton = MenuActivities.selectedbutton + 1
                        if buttoncount > 10 and MenuActivities.selectedbutton > MenuActivities.menu.to then
                            MenuActivities.menu.to = MenuActivities.menu.to + 1
                            MenuActivities.menu.from = MenuActivities.menu.from + 1
                        end
                    end
                end
                if IsControlJustPressed(1, 166) then
                    CloseMenuActivities()
                end
            else
                if IsControlJustPressed(1, 166) then
                    OpenActivitiesMenu()
                end
            end
        end
    end
end)
