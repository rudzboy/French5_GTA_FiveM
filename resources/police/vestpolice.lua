-----------------------------------------------------------------------------------------------------------------
---------------------------------------------------- Cop Locker---------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local vestpolice = {
    opened = false,
    title = "Vestiaire Police",
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
                { name = "Mettre/Retirer gilet pare-balles", description = "" },
                { name = "Mettre/Retirer gilet jaune", description = "" },
                { name = "Mettre/Retirer casquette", description = "" },
                { name = "Badge Sergent", description = "" },
                { name = "Badge Lieutenant", description = "" },
                { name = "Badge Capitaine", description = "" },
            }
        },
    }
}

local skin = {
    armor = false,
    yellowJacket = false,
    hat = false,
    badge = false
}

---------------------------------------------------------------------
-- CONFIG SELECTION cf: https://marekkraus.sk/gtav/skins/ -----------
---------------------------------------------------------------------
function ButtonSelectedVest(button)
    local ped = GetPlayerPed(-1)
    local this = vestpolice.currentmenu
    local btn = button.name
    if this == "main" then
        if btn == "Prendre votre service" then
            ServiceOn() -- En Service + Uniforme
            giveUniforme()
            drawNotification("Vous êtes maintenant en ~g~service~w~.")
            drawNotification("Appuyez sur ~y~F5~w~ pour ouvrir le ~b~menu police~w~.")
        elseif btn == "Quitter votre service" then
            ServiceOff()
            removeUniforme() --Finir Service + Enleve Uniforme
            drawNotification("Vous avez ~r~quitté~w~ votre service.")
        elseif btn == "Mettre/Retirer gilet pare-balles" then
            if skin.armor == false then
                if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
                    SetPedComponentVariation(ped, 9, 4, 1, 2)
                elseif (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
                    SetPedComponentVariation(ped, 9, 12, 1, 2)
                end
                SetPedArmour(ped, 100)
            else
                SetPedComponentVariation(ped, 9, 0, 1, 2)
                SetPedArmour(ped, 0)
            end
            skin.armor = not skin.armor
        elseif btn == "Mettre/Retirer gilet jaune" then
            if skin.yellowJacket == false then
                if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
                    SetPedComponentVariation(ped, 8, 59, 0, 2)
                elseif (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
                    SetPedComponentVariation(ped, 8, 36, 0, 2)
                end
            else
                if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
                    SetPedComponentVariation(ped, 8, 58, 0, 2)
                elseif (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
                    SetPedComponentVariation(ped, 8, 35, 0, 2)
                end
            end
            skin.yellowJacket = not skin.yellowJacket
        elseif btn == "Mettre/Retirer casquette" then
            if skin.hat == false then
                if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
                    SetPedPropIndex(GetPlayerPed(-1), 0, 46, 0, 0)
                elseif (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
                    SetPedPropIndex(GetPlayerPed(-1), 0, 45, 0, 0)
                end
            else
                ClearPedProp(GetPlayerPed(-1), 0)
            end
            skin.hat = not skin.hat
        elseif btn == "Badge Sergent" or btn == "Badge Lieutenant" or btn == "Badge Capitaine" then
            if skin.badge == false then
                if btn == "Badge Sergent" then
                    if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
                        SetPedComponentVariation(ped, 10, 8, 1, 2)
                    elseif (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
                        SetPedComponentVariation(ped, 10, 7, 1, 2)
                    end
                elseif btn == "Badge Lieutenant" then
                    if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
                        SetPedComponentVariation(ped, 10, 8, 3, 2)
                    elseif (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
                        SetPedComponentVariation(ped, 10, 7, 3, 2)
                    end
                elseif btn == "Badge Capitaine" then
                    if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
                        SetPedComponentVariation(ped, 10, 8, 2, 2)
                    elseif (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
                        SetPedComponentVariation(ped, 10, 7, 2, 2)
                    end
                end
            else
                if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
                    SetPedComponentVariation(ped, 10, 8, 0, 2)
                elseif (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
                    SetPedComponentVariation(ped, 10, 7, 0, 2)
                end
            end
            skin.badge = not skin.badge
        end
    end
end

-------------------------------------------------
------------------ FONCTION UNIFORME--------------
-------------------------------------------------
function giveUniforme()
    Citizen.CreateThread(function()

        if (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_m_freemode_01")) then
            SetPedPropIndex(GetPlayerPed(-1), 2, 0, 0, 2) --Ecouteur Bluetooh
            SetPedComponentVariation(GetPlayerPed(-1), 11, 55, 0, 2) --Chemise Police
            SetPedComponentVariation(GetPlayerPed(-1), 3, 0, 0, 2) --Tshirt non bug
            SetPedComponentVariation(GetPlayerPed(-1), 8, 58, 0, 2) --Ceinture+matraque Police
            SetPedComponentVariation(GetPlayerPed(-1), 4, 35, 0, 2) --Pantalon Police
            SetPedComponentVariation(GetPlayerPed(-1), 6, 24, 0, 2) --Chaussure Police
            SetPedComponentVariation(GetPlayerPed(-1), 10, 8, 0, 2) --grade 0
        elseif (GetEntityModel(GetPlayerPed(-1)) == GetHashKey("mp_f_freemode_01")) then
            SetPedPropIndex(GetPlayerPed(-1), 1, 11, 3, 2) --Lunette Soleil
            SetPedPropIndex(GetPlayerPed(-1), 2, 0, 0, 2) --Ecouteur Bluetooh
            SetPedComponentVariation(GetPlayerPed(-1), 3, 14, 0, 2) --Tshirt non bug
            SetPedComponentVariation(GetPlayerPed(-1), 11, 48, 0, 2) --Chemise Police
            SetPedComponentVariation(GetPlayerPed(-1), 8, 35, 0, 2) --Ceinture+matraque Police
            SetPedComponentVariation(GetPlayerPed(-1), 4, 34, 0, 2) --Pantalon Police
            SetPedComponentVariation(GetPlayerPed(-1), 6, 29, 0, 2) -- Chaussure Police
            SetPedComponentVariation(GetPlayerPed(-1), 10, 7, 0, 2) --grade 0
        end
    end)

    RemoveAllPedWeapons(GetPlayerPed(-1))
end

function removeUniforme()
    Citizen.CreateThread(function()
        TriggerServerEvent("mm:otherspawn")
        TriggerServerEvent("weaponshop:GiveWeaponsToSelf")
    end)
end

-------------------------------------------------
---------------- CONFIG OPEN MENU-----------------
-------------------------------------------------
function OpenVestMenu(menu)
    vestpolice.menu.from = 1
    vestpolice.menu.to = 10
    vestpolice.selectedbutton = 0
    vestpolice.currentmenu = menu
end

-------------------------------------------------
---------------- CONFIG BACK MENU-----------------
-------------------------------------------------
function BackVest()
    if backlock then
        return
    end
    backlock = true
    if vestpolice.currentmenu == "main" then
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
function OpenMenuVest()
    vestpolice.currentmenu = "main"
    vestpolice.opened = true
    vestpolice.selectedbutton = 0
end

-------------------------------------------------
---------------- FONCTION CLOSE-------------------
-------------------------------------------------
function CloseMenuVest()
    vestpolice.opened = false
    vestpolice.menu.from = 1
    vestpolice.menu.to = 10
end

-------------------------------------------------
---------------- FONCTION OPEN MENU---------------
-------------------------------------------------
local backlock = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GetDistanceBetweenCoords(457.956, -992.723, 30.689, GetEntityCoords(GetPlayerPed(-1))) > 2 then
            if vestpolice.opened then
                CloseMenuVest()
            end
        end
        if vestpolice.opened then
            local ped = LocalPed()
            local menu = vestpolice.menu[vestpolice.currentmenu]
            drawTxt(vestpolice.title, 1, 1, vestpolice.menu.x, vestpolice.menu.y, 1.0, 255, 255, 255, 255)
            drawMenuTitle(menu.title, vestpolice.menu.x, vestpolice.menu.y + 0.08)
            drawTxt(vestpolice.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, vestpolice.menu.x + vestpolice.menu.width / 2 - 0.0385, vestpolice.menu.y + 0.067, 0.4, 255, 255, 255, 255)
            local y = vestpolice.menu.y + 0.12
            buttoncount = tablelength(menu.buttons)
            local selected = false

            for i, button in pairs(menu.buttons) do
                if i >= vestpolice.menu.from and i <= vestpolice.menu.to then

                    if i == vestpolice.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button, vestpolice.menu.x, y, selected)
                    if button.distance ~= nil then
                        drawMenuRight(button.distance .. "m", vestpolice.menu.x, y, selected)
                    end
                    y = y + 0.04
                    if selected and IsControlJustPressed(1, 201) then
                        ButtonSelectedVest(button)
                    end
                end
            end
        end
        if vestpolice.opened then
            if IsControlJustPressed(1, 202) then
                BackVest()
            end
            if IsControlJustReleased(1, 202) then
                backlock = false
            end
            if IsControlJustPressed(1, 188) then
                if vestpolice.selectedbutton > 1 then
                    vestpolice.selectedbutton = vestpolice.selectedbutton - 1
                    if buttoncount > 10 and vestpolice.selectedbutton < vestpolice.menu.from then
                        vestpolice.menu.from = vestpolice.menu.from - 1
                        vestpolice.menu.to = vestpolice.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1, 187) then
                if vestpolice.selectedbutton < buttoncount then
                    vestpolice.selectedbutton = vestpolice.selectedbutton + 1
                    if buttoncount > 10 and vestpolice.selectedbutton > vestpolice.menu.to then
                        vestpolice.menu.to = vestpolice.menu.to + 1
                        vestpolice.menu.from = vestpolice.menu.from + 1
                    end
                end
            end
        end
    end
end)