-----------------------------------------------------------------------------------------------------------------
----------------------------------------------------- MECHANIC MENU---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local menuMechanic = {
    opened = false,
    title = "Menu Dépannage",
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
                { name = "Animations", description = "" },
            }
        },
        ["Actions"] = {
            title = "ACTIONS",
            name = "Actions",
            buttons = {
                { name = "Diagnostiquer un véhicule", description = '' },
                { name = "Préparer le remorquage", description = '' },
            }
        },
        ["Animations"] = {
            title = "ANIMATIONS",
            name = "Animations",
            buttons = {
                { name = "Lustrer/Nettoyer", description = '' },
                { name = "Souder", description = '' },
                { name = "Réparer couché", description = '' },
                { name = "Arrêter l'animation", description = '' },
            }
        },
        ["Véhicule"] = {
            title = "VEHICULE",
            name = "Véhicule",
            buttons = {
                { name = "Verrouiller votre véhicule", description = '' },
                --{ name = "Crochet", description = '' },
            }
        }
    }
}

-------------------------------------------------
---------------- CONFIG SELECTION----------------
-------------------------------------------------
function ButtonSelectedMechanic(button)
    local ped = GetPlayerPed(-1)
    local this = menuMechanic.currentmenu
    local btn = button.name
    if this == "main" then
        if btn == "Animations" then
            OpenMenuMechanic('Animations')
        elseif btn == "Actions" then
            OpenMenuMechanic('Actions')
        elseif btn == "Véhicule" then
            OpenMenuMechanic('Véhicule')
        end
    elseif this == "Animations" then
        if btn == "Lustrer/Nettoyer" then
            TriggerEvent("anim:emote", "WORLD_HUMAN_MAID_CLEAN")
        elseif btn == "Souder" then
            TriggerEvent("anim:emote", "WORLD_HUMAN_WELDING")
        elseif btn == "Réparer couché" then
            TriggerEvent("anim:emote", "WORLD_HUMAN_VEHICLE_MECHANIC")
        elseif btn == "Arrêter l'animation" then
            TriggerEvent("anim:clear")
        end
    elseif this == "Véhicule" then
        if btn == "Verrouiller votre véhicule" then
            SwapLockActiveVehicle()
        --elseif btn == "Crochet" then
            --Crocheter()
        end
    elseif this == "Actions" then
        if btn == "Diagnostiquer un véhicule" then
            TriggerEvent('mechanic:checkClosestCar')
        elseif btn == "Préparer le remorquage" then
            TriggerEvent('mechanic:prepareClosestCar')
        end
    end
end

-------------------------------------------------
------------ FONCTION INTERACTION VEHICLE---------
-------------------------------------------------
function SwapLockActiveVehicle()
    Citizen.CreateThread(function()
        TriggerEvent('mechanic:swapLockMechanicVehicle')
    end)
end

function Crocheter()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
    if (DoesEntityExist(vehicleHandle)) then
        TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_WELDING", 0, true)
        Citizen.Wait(5000)
        SetVehicleDoorsLocked(vehicleHandle, 1)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        TriggerEvent('showNotify', "Véhicule ~g~ouvert~w~.")
    else
        TriggerEvent('showNotify', "~r~Aucun véhicule près de vous !")
    end
end

-------------------------------------------------
---------------- CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenMenuMechanic(menu)
    menuMechanic.lastmenu = menuMechanic.currentmenu
    if menu == "Animations" then
        menuMechanic.lastmenu = "main"
    elseif menu == "Véhicule" then
        menuMechanic.lastmenu = "main"
    elseif menu == "Actions" then
        menuMechanic.lastmenu = "main"
    end
    menuMechanic.menu.from = 1
    menuMechanic.menu.to = 10
    menuMechanic.selectedbutton = 0
    menuMechanic.currentmenu = menu
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
    local menu = menuMechanic.menu
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
    local menu = menuMechanic.menu
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
    local menu = menuMechanic.menu
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
    local menu = menuMechanic.menu
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
function BackMenuMechanic()
    if menuMechanic.currentmenu == "Animations" or menuMechanic.currentmenu == "Véhicule" or menuMechanic.currentmenu == "Actions" then
        OpenMenuMechanic(menuMechanic.lastmenu)
    else
        CloseMenuMechanic()
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
function OpenMechanicMenu()
    menuMechanic.currentmenu = "main"
    menuMechanic.opened = true
    menuMechanic.selectedbutton = 0
end

-------------------------------------------------
---------------- FONCTION CLOSE-------------------
-------------------------------------------------
function CloseMenuMechanic()
    menuMechanic.opened = false
    menuMechanic.menu.from = 1
    menuMechanic.menu.to = 10
end

-------------------------------------------------
---------------- FONCTION OPEN MENU---------------
------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (isMechanic) then
            if (isInService) then
                if menuMechanic.opened then
                    local ped = LocalPed()
                    local menu = menuMechanic.menu[menuMechanic.currentmenu]
                    drawTxt(menuMechanic.title, 1, 1, menuMechanic.menu.x, menuMechanic.menu.y, 1.0, 255, 255, 255, 255)
                    drawMenuTitle(menu.title, menuMechanic.menu.x, menuMechanic.menu.y + 0.08)
                    drawTxt(menuMechanic.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, menuMechanic.menu.x + menuMechanic.menu.width / 2 - 0.0385, menuMechanic.menu.y + 0.067, 0.4, 255, 255, 255, 255)
                    local y = menuMechanic.menu.y + 0.12
                    buttoncount = tablelength(menu.buttons)
                    local selected = false

                    for i, button in pairs(menu.buttons) do
                        if i >= menuMechanic.menu.from and i <= menuMechanic.menu.to then

                            if i == menuMechanic.selectedbutton then
                                selected = true
                            else
                                selected = false
                            end
                            drawMenuButton(button, menuMechanic.menu.x, y, selected)
                            if button.distance ~= nil then
                                drawMenuRight(button.distance .. "m", menuMechanic.menu.x, y, selected)
                            end
                            y = y + 0.04
                            if selected and IsControlJustPressed(1, 201) then
                                ButtonSelectedMechanic(button)
                            end
                        end
                    end
                    if IsControlJustPressed(1, 177) then
                        BackMenuMechanic()
                    end
                    if IsControlJustPressed(1, 188) then
                        if menuMechanic.selectedbutton > 1 then
                            menuMechanic.selectedbutton = menuMechanic.selectedbutton - 1
                            if buttoncount > 10 and menuMechanic.selectedbutton < menuMechanic.menu.from then
                                menuMechanic.menu.from = menuMechanic.menu.from - 1
                                menuMechanic.menu.to = menuMechanic.menu.to - 1
                            end
                        end
                    end
                    if IsControlJustPressed(1, 187) then
                        if menuMechanic.selectedbutton < buttoncount then
                            menuMechanic.selectedbutton = menuMechanic.selectedbutton + 1
                            if buttoncount > 10 and menuMechanic.selectedbutton > menuMechanic.menu.to then
                                menuMechanic.menu.to = menuMechanic.menu.to + 1
                                menuMechanic.menu.from = menuMechanic.menu.from + 1
                            end
                        end
                    end
                    if IsControlJustPressed(1, 166) then
                        CloseMenuMechanic()
                    end
                else
                    if IsControlJustPressed(1, 166) then
                        OpenMechanicMenu()
                    end
                end
            end
        end
    end
end)
