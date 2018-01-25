-----------------------------------------------------------------------------------------------------------------
---------------------------------------------- Secret Services Locker---------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local secretservicelocker = {
    opened = false,
    title = "Services Secrets",
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
        buttons = 10, --Nombre de bouton
        from = 1,
        to = 10,
        scale = 0.4,
        font = 0,
        ["main"] = {
            title = "CATEGORIES",
            name = "main",
            buttons = {
                { name = "Prendre votre service", description = "" },
                { name = "Quitter votre service", description = "" },
                { name = "Mettre la tenue d\'agent", description = "" },
                { name = "Mettre la tenue de combat", description = "" }
            }
        },
    }
}

local skin = {
    armor = false,
    mask = false,
    sunglasses = false
}

---------------------------------------------------------------------
-- CONFIG SELECTION cf: https://marekkraus.sk/gtav/skins/ -----------
---------------------------------------------------------------------
function ButtonSelectedVest(button)
    local ped = GetPlayerPed(-1)
    local this = secretservicelocker.currentmenu
    local btn = button.name
    if this == "main" then
        if btn == "Prendre votre service" then
            ServiceOn() -- En Service + Uniforme
            drawNotification("Vous êtes en ~g~service~w~. ~b~Équipez-vous~w~ à l\'~y~armurerie~w~.")
            drawNotification("Appuyez sur ~y~F5~w~ pour ouvrir le ~b~menu services secrets~w~.")
            RemoveAllPedWeapons(GetPlayerPed(-1))
        elseif btn == "Quitter votre service" then
            ServiceOff()
            removeUniforme() --Finir Service + Enleve Uniforme
            drawNotification("Vous avez ~r~quitté~w~ votre service.")
        elseif btn == "Mettre la tenue d\'agent" then
            giveAgentWear()
        elseif btn == "Mettre la tenue de combat" then
            giveCombatWear()
        end
    end
end

-------------------------------------------------
------------------ FONCTION UNIFORME--------------
-------------------------------------------------
function giveAgentWear()
    Citizen.CreateThread(function()
        local ped = GetPlayerPed(-1)
        if (GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
            ClearPedProp(ped, 0)
            ClearPedProp(ped, 1)
            ClearPedProp(ped, 2)
            SetPedPropIndex(ped, 2, 0, 0, 2) --Ecouteur Bluetooh
            SetPedPropIndex(ped, 1, 3, 5, 2) --Lunettes
            SetPedComponentVariation(ped, 1, 0, 0, 2) --No mask
            SetPedComponentVariation(ped, 11, 28, 0, 2) --Blazer
            SetPedComponentVariation(ped, 3, 44, 0, 2) --Dessous
            SetPedComponentVariation(ped, 8, 32, 0, 2) --Chemise
            SetPedComponentVariation(ped, 7, 10, 2, 2) --Cravate
            SetPedComponentVariation(ped, 4, 10, 0, 2) --Pantalon
            SetPedComponentVariation(ped, 6, 10, 0, 2) --Chaussure
            SetPedComponentVariation(ped, 9, 0, 0, 2) --Armor
            SetPedArmour(ped, 0)
        end
    end)
end

function giveCombatWear()
    Citizen.CreateThread(function()
        local ped = GetPlayerPed(-1)
        if (GetEntityModel(ped) == GetHashKey("mp_m_freemode_01")) then
            ClearPedProp(ped, 0)
            ClearPedProp(ped, 1)
            ClearPedProp(ped, 2)
            SetPedPropIndex(ped, 0, 39, 0, 1) --Casque combat
            SetPedPropIndex(ped, 1, 23, 9, 1) --Ecouteur Bluetooh
            SetPedPropIndex(ped, 2, 0, 0, 1) --Ecouteur Bluetooh
            SetPedComponentVariation(ped, 11, 49, 0, 2) --Blazer
            SetPedComponentVariation(ped, 8, 15, 0, 2) --Dessous
            SetPedComponentVariation(ped, 3, 35, 0, 2) --Dessous
            SetPedComponentVariation(ped, 7, 15, 0, 2) --Chemise
            SetPedComponentVariation(ped, 4, 34, 0, 2) --Pantalon
            SetPedComponentVariation(ped, 6, 24, 0, 2) --Chaussure
            SetPedComponentVariation(ped, 1, 35, 0, 2) --Hood
            SetPedComponentVariation(ped, 9, 11, 1, 2) --Armor
            SetPedArmour(ped, 100)
        end
    end)
end

function removeUniforme()
    Citizen.CreateThread(function()
        SetPedArmour(GetPlayerPed(-1), 0)
        TriggerServerEvent("mm:otherspawn")
        TriggerServerEvent("weaponshop:GiveWeaponsToSelf")
    end)
end

-------------------------------------------------
---------------- CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenSSALockerSubmenu(menu)
    secretservicelocker.menu.from = 1
    secretservicelocker.menu.to = 10
    secretservicelocker.selectedbutton = 0
    secretservicelocker.currentmenu = menu
end

-------------------------------------------------
---------------- CONFIG BACK MENU-----------------
-------------------------------------------------
function BackVest()
    if backlock then
        return
    end
    backlock = true
    if secretservicelocker.currentmenu == "main" then
        CloseMenuVest()
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
function OpenSSALocker()
    secretservicelocker.currentmenu = "main"
    secretservicelocker.opened = true
    secretservicelocker.selectedbutton = 0
end

-------------------------------------------------
---------------- FONCTION CLOSE-------------------
-------------------------------------------------
function CloseMenuVest()
    secretservicelocker.opened = false
    secretservicelocker.menu.from = 1
    secretservicelocker.menu.to = 10
end

-------------------------------------------------
---------------- FONCTION OPEN MENU---------------
-------------------------------------------------

local takingService = { x = 135.898, y = -749.355, z = 258.152 }

local backlock = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GetDistanceBetweenCoords(takingService.x, takingService.y, takingService.z, GetEntityCoords(GetPlayerPed(-1))) > 2 then
            if secretservicelocker.opened then
                CloseMenuVest()
            end
        end
        if secretservicelocker.opened then
            local ped = LocalPed()
            local menu = secretservicelocker.menu[secretservicelocker.currentmenu]
            drawTxt(secretservicelocker.title, 1, 1, secretservicelocker.menu.x, secretservicelocker.menu.y, 1.0, 255, 255, 255, 255)
            drawMenuTitle(menu.title, secretservicelocker.menu.x, secretservicelocker.menu.y + 0.08)
            drawTxt(secretservicelocker.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, secretservicelocker.menu.x + secretservicelocker.menu.width / 2 - 0.0385, secretservicelocker.menu.y + 0.067, 0.4, 255, 255, 255, 255)
            local y = secretservicelocker.menu.y + 0.12
            buttoncount = tablelength(menu.buttons)
            local selected = false

            for i, button in pairs(menu.buttons) do
                if i >= secretservicelocker.menu.from and i <= secretservicelocker.menu.to then

                    if i == secretservicelocker.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button, secretservicelocker.menu.x, y, selected)
                    if button.distance ~= nil then
                        drawMenuRight(button.distance .. "m", secretservicelocker.menu.x, y, selected)
                    end
                    y = y + 0.04
                    if selected and IsControlJustPressed(1, 201) then
                        ButtonSelectedVest(button)
                    end
                end
            end
        end
        if secretservicelocker.opened then
            if IsControlJustPressed(1, 202) then
                BackVest()
            end
            if IsControlJustReleased(1, 202) then
                backlock = false
            end
            if IsControlJustPressed(1, 188) then
                if secretservicelocker.selectedbutton > 1 then
                    secretservicelocker.selectedbutton = secretservicelocker.selectedbutton - 1
                    if buttoncount > 10 and secretservicelocker.selectedbutton < secretservicelocker.menu.from then
                        secretservicelocker.menu.from = secretservicelocker.menu.from - 1
                        secretservicelocker.menu.to = secretservicelocker.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1, 187) then
                if secretservicelocker.selectedbutton < buttoncount then
                    secretservicelocker.selectedbutton = secretservicelocker.selectedbutton + 1
                    if buttoncount > 10 and secretservicelocker.selectedbutton > secretservicelocker.menu.to then
                        secretservicelocker.menu.to = secretservicelocker.menu.to + 1
                        secretservicelocker.menu.from = secretservicelocker.menu.from + 1
                    end
                end
            end
        end
    end
end)