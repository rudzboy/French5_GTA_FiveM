-----------------------------------------------------------------------------------------------------------------
----------------------------------------------------- COPS MENU---------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local menupolice = {
    opened = false,
    title = "Menu Police",
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
                { name = "Animations", description = "" },
                { name = "Signalisation", description = "" },
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
                { name = "Retirer le permis de conduire", description = '' },
                { name = "Saisir les objets illégaux", description = '' },
                { name = "Saisir les armes illégales", description = '' },
                { name = "Menotter ou démenotter", description = '' },
                { name = "Installer dans le véhicule", description = '' },
                { name = "Sortir du véhicule", description = '' },
                { name = "Réanimer (Urgence)", description = '' },
                { name = "Amendes", description = '' },
            }
        },
        ["Animations"] = {
            title = "ANIMATIONS",
            name = "Animations",
            buttons = {
                { name = "Posture #1", description = '' },
                { name = "Posture #2", description = '' },
                { name = "Faire la circulation", description = '' },
                { name = "Arrêter l'animation", description = '' },
            }
        },
        ["Amendes"] = {
            title = "AMENDES",
            name = "Amendes",
            buttons = {
                { value = 1000, name = 'État d\'ébriété' },
                { value = 1200, name = 'Infraction routière mineure' },
                { value = 2400, name = 'Infraction routière majeure' },
                { value = 3000, name = 'Comportement dangereux' },
                { value = 4500, name = 'Conduite sans permis' },
                { value = 5000, name = 'Menaces à citoyen' },
                { value = 6000, name = 'Vol de véhicule' },
                { value = 7500, name = 'Refus d\'optempérer' },
                { value = 7500, name = 'Délit de fuite' },
                { value = 8000, name = 'Outrage à agent' },
                { value = 10000, name = 'Possession de drogue' },
                { value = 15000, name = 'Coups et blessures' },
                { value = 18000, name = 'Vol de véhicule de police' },
                { value = 20000, name = 'Braquage' },
                { value = 25000, name = 'Traffic de drogue' },
                { value = 25000, name = 'Tentative de corruption' },
                { value = 35000, name = 'Homicide involontaire' },
                { value = 35000, name = 'Aggression sur agent' },
                { value = 50000, name = 'Braquage de banque' },
                { value = 65000, name = 'Meurtre sur citoyen' },
                { value = 80000, name = 'Meurtre sur agent' },
            }
        },
        ["Signalisation"] = {
            title = "SIGNALISATION",
            name = "Signalisation",
            buttons = {
                { name = "Placer un objet", description = "" },
                { name = "Retirer le dernier objet", description = "" },
                { name = "Retirer tous les objets", description = "" },
            }
        },
        ["Placer un objet"] = {
            title = "OBJETS",
            name = "Placer un objet",
            buttons = {
                {name = 'Cône (petit)', model = "prop_mp_cone_02"},
                {name = 'Cône (grand)', model = "prop_roadcone01a"},
                {name = 'Barrière', model = "prop_mp_barrier_02b"},
                {name = 'Barrière (déviation)', model = "prop_mp_arrow_barrier_01"},
                {name = 'Barrière (travaux)', model = "prop_mp_barrier_02"},
            }
        },
        ["Véhicule"] = {
            title = "VEHICULE",
            name = "Véhicule",
            buttons = {
                { name = "Verrouiller votre véhicule", description = '' },
                { name = "Contrôle de l\'immatriculation", description = '' },
                { name = "Crocheter", description = '' },
            }
        },
        ["Tenue"] = {
            title = "TENUE",
            name = "Tenue",
            buttons = {
                { name = "Mettre/Retirer le casque", description = '' },
                { name = "Mettre/Retirer la cagoule", description = '' },
                { name = "Mettre/Retirer les lunettes", description = '' }
            }
        }
    }
}

local skin = {
    motorbike_helmet = false,
    mask = false,
    sunglasses = false
}

-------------------------------------------------
---------------- CONFIG SELECTION----------------
-------------------------------------------------
function ButtonSelectedPolice(button)
    local ped = GetPlayerPed(-1)
    local this = menupolice.currentmenu
    local btn = button.name
    if this == "main" then
        if btn == "Citoyen" then
            OpenMenuPolice('Citoyen')
        elseif btn == "Véhicule" then
            OpenMenuPolice('Véhicule')
        elseif btn == "Animations" then
            OpenMenuPolice('Animations')
        elseif btn == "Signalisation" then
            OpenMenuPolice('Signalisation')
        elseif btn == "Tenue" then
            OpenMenuPolice('Tenue')
        end
    elseif this == "Citoyen" then
        if btn == "Amendes" then
            OpenMenuPolice('Amendes')
        elseif btn == "Inspecter un citoyen" then
            Check()
        elseif btn == "Saisir les objets illégaux" then
            DropIllegalItems()
        elseif btn == "Saisir les armes illégales" then
            DropIllegalWeapons()
        elseif btn == "Vérifier le permis de conduire" then
            CheckDrivingLicence()
        elseif btn == "Retirer le permis de conduire" then
            CancelDrivingLicence()
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
    elseif this == "Animations" then
        if btn == "Posture #1" then
            TriggerEvent("anim:emote", "WORLD_HUMAN_COP_IDLES")
        elseif btn == "Posture #2" then
            TriggerEvent("anim:emote", "WORLD_HUMAN_GUARD_STAND")
        elseif btn == "Faire la circulation" then
            TriggerEvent("anim:emote", "WORLD_HUMAN_CAR_PARK_ATTENDANT")
        elseif btn == "Arrêter l'animation" then
            TriggerEvent("anim:clear")
        end
    elseif this == "Tenue" then
        if btn == "Mettre/Retirer le casque" then
            ToggleMotorbikeHelmet()
        elseif btn == "Mettre/Retirer la cagoule" then
            ToggleMask()
        elseif btn == "Mettre/Retirer les lunettes" then
            ToggleGlasses()
        end
    elseif this == "Amendes" then
        Fines(button.value, button.name)
    elseif this == "Signalisation" then
        if btn == "Placer un objet" then
            OpenMenuPolice('Placer un objet')
        elseif btn == "Retirer le dernier objet" then
            RemoveLastProp()
        elseif btn == "Retirer tous les objets" then
            RemoveAllProps()
        end
    elseif this == "Placer un objet" then
        SpawnProp(button.model)
    end
end

-------------------------------------------------
----------------- PROPS (OBJECTS)----------------
-------------------------------------------------

function SpawnProp(model)
    TriggerEvent('props:spawnObject', model)
end

function RemoveLastProp()
    TriggerEvent('props:removeLastSpawnedObject')
end

function RemoveAllProps()
    TriggerEvent('props:removeAllSpawnedObjects')
end

-------------------------------------------------
------------ FONCTION INTERACTION TENUE---------
-------------------------------------------------
function ToggleMotorbikeHelmet()
    if skin.motorbike_helmet == false then
        SetPedPropIndex(GetPlayerPed(-1), 0, 50, 0, 1)
    else
        ClearPedProp(GetPlayerPed(-1), 0)
    end
    skin.motorbike_helmet = not skin.motorbike_helmet
end

function ToggleMask()
    if skin.mask == false then
        SetPedComponentVariation(GetPlayerPed(-1), 1, 35, 0, 2)
    else
        SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0, 2)
    end
    skin.mask = not skin.mask
end

function ToggleGlasses()
    if skin.sunglasses == false then
        SetPedPropIndex(GetPlayerPed(-1), 1, 5, 0, 2)
    else
        SetPedPropIndex(GetPlayerPed(-1), 1, 0, 0, 2)
    end
    skin.sunglasses = not skin.sunglasses
end

-------------------------------------------------
------------ FONCTION INTERACTION Citizen---------
-------------------------------------------------
function Check()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:targetCheckInventory", GetPlayerServerId(t))
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function DropIllegalItems()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:targetDropIllegalItems", GetPlayerServerId(t))
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function DropIllegalWeapons()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:targetDropIllegalWeapons", GetPlayerServerId(t))
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

function CancelDrivingLicence()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:cancelDrivingLicence", GetPlayerServerId(t))
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function Cuffed()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3.0) then
        TriggerServerEvent("police:cuffGranted", GetPlayerServerId(t))
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function PutInVehicle()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3.0) then
        local v = GetVehiclePedIsIn(GetPlayerPed(-1), true)
        TriggerServerEvent("police:forceEnterAsk", GetPlayerServerId(t), v)
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function UnseatVehicle()
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3.0) then
        local v = GetVehiclePedIsIn(GetPlayerPed(t), true)
        if IsEntityAVehicle(v) then
            TriggerServerEvent("police:confirmUnseat", GetPlayerServerId(t))
        else
            TriggerEvent('showNotify', "~r~La cible n\'est pas dans un véhicule !")
        end
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function Fines(amount, reason)
    t, distance = GetClosestPlayer()
    if (distance ~= -1 and distance < 3) then
        TriggerServerEvent("police:finesGranted", GetPlayerServerId(t), amount, reason)
        TriggerServerEvent("safes:amendecoffre", amount, reason)
    else
        TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
    end
end

function RescueCitizen()
    TriggerServerEvent('ems:allowEmergencyRescue')
end

-------------------------------------------------
------------ FONCTION INTERACTION VEHICLE---------
-------------------------------------------------
function SwapLockActiveVehicle()
    Citizen.CreateThread(function()
        TriggerEvent('police:swapLockPoliceVehicle')
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
        TriggerServerEvent("police:checkingPlate", GetVehicleNumberPlateText(vehicleHandle))
    else
        TriggerEvent('showNotify', "~r~Aucun véhicule près de vous !")
    end
end

-------------------------------------------------
---------------- CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenMenuPolice(menu)
    menupolice.lastmenu = menupolice.currentmenu
    if menu == "Animations" then
        menupolice.lastmenu = "main"
    elseif menu == "Citoyen" then
        menupolice.lastmenu = "main"
    elseif menu == "Véhicule" then
        menupolice.lastmenu = "main"
    elseif menu == "Signalisation" then
        menupolice.lastmenu = "main"
    elseif menu == "Tenue" then
        menupolice.lastmenu = "main"
    elseif menu == "Amendes" then
        menupolice.lastmenu = "Citoyen"
    elseif menu == "Placer un objet" then
        menupolice.lastmenu = "Signalisation"
    end
    menupolice.menu.from = 1
    menupolice.menu.to = 10
    menupolice.selectedbutton = 0
    menupolice.currentmenu = menu
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
    local menu = menupolice.menu
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
    local menu = menupolice.menu
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
    local menu = menupolice.menu
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
    local menu = menupolice.menu
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
function BackMenuPolice()
    if menupolice.currentmenu == "Animations"
        or menupolice.currentmenu == "Citoyen"
        or menupolice.currentmenu == "Véhicule"
        or menupolice.currentmenu == "Signalisation"
        or menupolice.currentmenu == "Placer un objet"
        or menupolice.currentmenu == "Tenue"
        or menupolice.currentmenu == "Amendes" then
        OpenMenuPolice(menupolice.lastmenu)
    else
        CloseMenuPolice()
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
function OpenPoliceMenu()
    menupolice.currentmenu = "main"
    menupolice.opened = true
    menupolice.selectedbutton = 0
end

-------------------------------------------------
---------------- FONCTION CLOSE-------------------
-------------------------------------------------
function CloseMenuPolice()
    menupolice.opened = false
    menupolice.menu.from = 1
    menupolice.menu.to = 10
end

-------------------------------------------------
---------------- FONCTION OPEN MENU---------------
------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (isCop) then
            if (isInService) then
                if menupolice.opened then
                    local ped = LocalPed()
                    local menu = menupolice.menu[menupolice.currentmenu]
                    drawTxt(menupolice.title, 1, 1, menupolice.menu.x, menupolice.menu.y, 1.0, 255, 255, 255, 255)
                    drawMenuTitle(menu.title, menupolice.menu.x, menupolice.menu.y + 0.08)
                    drawTxt(menupolice.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, menupolice.menu.x + menupolice.menu.width / 2 - 0.0385, menupolice.menu.y + 0.067, 0.4, 255, 255, 255, 255)
                    local y = menupolice.menu.y + 0.12
                    buttoncount = tablelength(menu.buttons)
                    local selected = false

                    for i, button in pairs(menu.buttons) do
                        if i >= menupolice.menu.from and i <= menupolice.menu.to then

                            if i == menupolice.selectedbutton then
                                selected = true
                            else
                                selected = false
                            end
                            drawMenuButton(button, menupolice.menu.x, y, selected)
                            if button.distance ~= nil then
                                drawMenuRight(button.distance .. "m", menupolice.menu.x, y, selected)
                            end
                            y = y + 0.04
                            if selected and IsControlJustPressed(1, 201) then
                                ButtonSelectedPolice(button)
                            end
                        end
                    end
                    if IsControlJustPressed(1, 177) then
                        BackMenuPolice()
                    end
                    if IsControlJustPressed(1, 188) then
                        if menupolice.selectedbutton > 1 then
                            menupolice.selectedbutton = menupolice.selectedbutton - 1
                            if buttoncount > 10 and menupolice.selectedbutton < menupolice.menu.from then
                                menupolice.menu.from = menupolice.menu.from - 1
                                menupolice.menu.to = menupolice.menu.to - 1
                            end
                        end
                    end
                    if IsControlJustPressed(1, 187) then
                        if menupolice.selectedbutton < buttoncount then
                            menupolice.selectedbutton = menupolice.selectedbutton + 1
                            if buttoncount > 10 and menupolice.selectedbutton > menupolice.menu.to then
                                menupolice.menu.to = menupolice.menu.to + 1
                                menupolice.menu.from = menupolice.menu.from + 1
                            end
                        end
                    end
                    if IsControlJustPressed(1, 166) then
                        CloseMenuPolice()
                    end
                else
                    if IsControlJustPressed(1, 166) then
                        OpenPoliceMenu()
                    end
                end
            end
        end
    end
end)
