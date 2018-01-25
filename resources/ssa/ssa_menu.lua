-----------------------------------------------------------------------------------------------------------------
----------------------------------------------------- COPS MENU---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local MenuSecretService = {
    opened = false,
    title = "Services Secrets",
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
                { name = "Citoyen", description = "" },
                { name = "Véhicule", description = "" },
                { name = "Tenue", description = "" },
                --	{name = "Call for backup(SOON)", description = ""},
                --	{name = "Radar Speed Detector(SOON)", description = ""},
            }
        },
        ["Citoyen"] = {
            title = "CITOYEN",
            name = "Citoyen",
            buttons = {
                --	{name = "ID Card(SOON)", description = ''},
                { name = "Inspecter un citoyen", description = '' },
                { name = "Vérifier le permis de conduire", description = '' },
                { name = "Saisir les objets illégaux", description = '' },
                { name = "Saisir les armes illégales", description = '' },
                { name = "Menotter ou démenotter", description = '' },
                { name = "Installer dans le véhicule", description = '' },
                { name = "Sortir du véhicule", description = '' },
                { name = "Réanimer (Urgence)", description = '' }
            }
        },
        ["Véhicule"] = {
            title = "VEHICULE",
            name = "Véhicule",
            buttons = {
                { name = "Verrouiller votre véhicule", description = '' },
                { name = "Contrôle de l\'immatriculation", description = '' },
                { name = "Crocheter", description = '' }
            }
        },
        ["Tenue"] = {
            title = "TENUE",
            name = "Tenue",
            buttons = {
                { name = "Retirer Casque", description = '' },
                { name = "Mettre Casque de combat", description = '' },
                { name = "Mettre Casque de moto", description = '' }
            }
        }
    }
}
-------------------------------------------------
---------------- CONFIG SELECTION----------------
-------------------------------------------------
function ButtonSelectedSSA(button)
    local ped = GetPlayerPed(-1)
    local this = MenuSecretService.currentmenu
    local btn = button.name
    if this == "main" then
        if btn == "Citoyen" then
            OpenMenuSecretService('Citoyen')
        elseif btn == "Véhicule" then
            OpenMenuSecretService('Véhicule')
        elseif btn == "Tenue" then
            OpenMenuSecretService('Tenue')
        end
    elseif this == "Citoyen" then
        if btn == "Inspecter un citoyen" then
            Check()
        elseif btn == "Saisir les objets illégaux" then
            DropIllegalItems()
        elseif btn == "Saisir les armes illégales" then
            DropIllegalWeapons()
        elseif btn == "Vérifier le permis de conduire" then
            CheckDrivingLicence()
        elseif btn == "Menotter ou démenotter" then
            Cuffed()
        elseif btn == "Installer dans le véhicule" then
            PutInVehicle()
        elseif btn == "Sortir du véhicule" then
            UnseatVehicle()
        elseif btn == "Réanimer (Urgence)" then
            RescueCitizen()
        end
    elseif this == "Véhicule" then
        if btn == "Crocheter" then
            Crocheter()
        elseif btn == "Contrôle de l\'immatriculation" then
            CheckPlate()
        elseif btn == "Verrouiller votre véhicule" then
            SwapLockActiveVehicle()
        end
    elseif this == "Tenue" then
        if btn == "Retirer Casque" then
            RemoveHelmet()
        elseif btn == "Mettre Casque de combat" then
            PutCombatHelmet()
        elseif btn == "Mettre Casque de moto" then
            PutMotorbikeHelmet()
        end
    end
end

-------------------------------------------------
------------ FONCTION INTERACTION TENUE---------
-------------------------------------------------
function RemoveHelmet()
    ClearPedProp(GetPlayerPed(-1), 0)
end

function PutCombatHelmet()
    SetPedPropIndex(GetPlayerPed(-1), 0, 39, 0, 1)
end

function PutMotorbikeHelmet()
    SetPedPropIndex(GetPlayerPed(-1), 0, 50, 0, 1)
end

-------------------------------------------------
------------ FONCTION INTERACTION Citizen---------
-------------------------------------------------
function Check()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3) then
        TriggerServerEvent("secret_service:targetCheckInventory", GetPlayerServerId(t))
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function DropIllegalItems()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3) then
        TriggerServerEvent("secret_service:targetDropIllegalItems", GetPlayerServerId(t))
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function DropIllegalWeapons()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3) then
        TriggerServerEvent("secret_service:targetDropIllegalWeapons", GetPlayerServerId(t))
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function CheckDrivingLicence()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3) then
        TriggerServerEvent("licences:checkPlayerLicence", GetPlayerServerId(t))
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function Cuffed()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3.0) then
        TriggerServerEvent("secret_service:cuffGranted", GetPlayerServerId(t))
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function PutInVehicle()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3.0) then
        local v = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        TriggerServerEvent("secret_service:forceEnterAsk", GetPlayerServerId(t), v)
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function UnseatVehicle()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3.0) then
        local v = GetVehiclePedIsIn(GetPlayerPed(t), true)
        if IsEntityAVehicle(v) then
            TriggerServerEvent("secret_service:confirmUnseat", GetPlayerServerId(t))
        else
            TriggerEvent('showNotify', "~r~La cible n\'est pas dans un véhicule !")
        end
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function RescueCitizen()
    TriggerEvent('ems:findDeadPlayers')
end

-------------------------------------------------
------------ FONCTION INTERACTION VEHICLE---------
-------------------------------------------------
function SwapLockActiveVehicle()
    Citizen.CreateThread(function()
        TriggerEvent('secret_service:swapLocksecretvehicle')
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

function CheckPlate()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
    if (DoesEntityExist(vehicleHandle)) then
        TriggerServerEvent("secret_service:checkingPlate", GetVehicleNumberPlateText(vehicleHandle))
    else
        TriggerEvent('showNotify', "~r~Aucun véhicule près de vous !")
    end
end

-------------------------------------------------
---------------- CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenMenuSecretService(menu)
    MenuSecretService.lastmenu = MenuSecretService.currentmenu
    if menu == "Animations" then
        MenuSecretService.lastmenu = "main"
    elseif menu == "Citoyen" then
        MenuSecretService.lastmenu = "main"
    elseif menu == "Véhicule" then
        MenuSecretService.lastmenu = "main"
    elseif menu == "Tenue" then
        MenuSecretService.lastmenu = "main"
    elseif menu == "Amendes" then
        MenuSecretService.lastmenu = "main"
    end
    MenuSecretService.menu.from = 1
    MenuSecretService.menu.to = 10
    MenuSecretService.selectedbutton = 0
    MenuSecretService.currentmenu = menu
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
    local menu = MenuSecretService.menu
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
    local menu = MenuSecretService.menu
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
    local menu = MenuSecretService.menu
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
    local menu = MenuSecretService.menu
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

------------------------------------------ F-------
---------------- CONFIG BACK MENU-----------------
-------------------------------------------------
function BackMenuSecretService()
    if MenuSecretService.currentmenu == "Animations" or
            MenuSecretService.currentmenu == "Citoyen" or
            MenuSecretService.currentmenu == "Véhicule" or
            MenuSecretService.currentmenu == "Tenue" or
            MenuSecretService.currentmenu == "Amendes" then
        OpenMenuSecretService(MenuSecretService.lastmenu)
    else
        CloseMenuSecretService()
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
function OpenSSAMenu()
    MenuSecretService.currentmenu = "main"
    MenuSecretService.opened = true
    MenuSecretService.selectedbutton = 0
end

-------------------------------------------------
---------------- FONCTION CLOSE-------------------
-------------------------------------------------
function CloseMenuSecretService()
    MenuSecretService.opened = false
    MenuSecretService.menu.from = 1
    MenuSecretService.menu.to = 10
end

-------------------------------------------------
---------------- FONCTION OPEN MENU---------------
------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (isSecretAgent) then
            if MenuSecretService.opened then
                local ped = LocalPed()
                local menu = MenuSecretService.menu[MenuSecretService.currentmenu]
                drawTxt(MenuSecretService.title, 1, 1, MenuSecretService.menu.x, MenuSecretService.menu.y, 1.0, 255, 255, 255, 255)
                drawMenuTitle(menu.title, MenuSecretService.menu.x, MenuSecretService.menu.y + 0.08)
                drawTxt(MenuSecretService.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, MenuSecretService.menu.x + MenuSecretService.menu.width / 2 - 0.0385, MenuSecretService.menu.y + 0.067, 0.4, 255, 255, 255, 255)
                local y = MenuSecretService.menu.y + 0.12
                buttoncount = tablelength(menu.buttons)
                local selected = false

                for i, button in pairs(menu.buttons) do
                    if i >= MenuSecretService.menu.from and i <= MenuSecretService.menu.to then

                        if i == MenuSecretService.selectedbutton then
                            selected = true
                        else
                            selected = false
                        end
                        drawMenuButton(button, MenuSecretService.menu.x, y, selected)
                        if button.distance ~= nil then
                            drawMenuRight(button.distance .. "m", MenuSecretService.menu.x, y, selected)
                        end
                        y = y + 0.04
                        if selected and IsControlJustPressed(1, 201) then
                            ButtonSelectedSSA(button)
                        end
                    end
                end
                if IsControlJustPressed(1, 177) then
                    BackMenuSecretService()
                end
                if IsControlJustPressed(1, 188) then
                    if MenuSecretService.selectedbutton > 1 then
                        MenuSecretService.selectedbutton = MenuSecretService.selectedbutton - 1
                        if buttoncount > 10 and MenuSecretService.selectedbutton < MenuSecretService.menu.from then
                            MenuSecretService.menu.from = MenuSecretService.menu.from - 1
                            MenuSecretService.menu.to = MenuSecretService.menu.to - 1
                        end
                    end
                end
                if IsControlJustPressed(1, 187) then
                    if MenuSecretService.selectedbutton < buttoncount then
                        MenuSecretService.selectedbutton = MenuSecretService.selectedbutton + 1
                        if buttoncount > 10 and MenuSecretService.selectedbutton > MenuSecretService.menu.to then
                            MenuSecretService.menu.to = MenuSecretService.menu.to + 1
                            MenuSecretService.menu.from = MenuSecretService.menu.from + 1
                        end
                    end
                end
                if IsControlJustPressed(1, 166) then
                    CloseMenuSecretService()
                end
            else
                if IsControlJustPressed(1, 166) then
                    OpenSSAMenu()
                end
            end
        end
    end
end)
