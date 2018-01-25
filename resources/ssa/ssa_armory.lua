-----------------------------------------------------------------------------------------------------------------
---------------------------------------------------- Secret Service Locker---------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local secretservicearmory = {
    opened = false,
    title = "Armurerie",
    currentmenu = "main",
    lastmenu = nil,
    currentpos = nil,
    selectedbutton = 0,
    marker = { r = 0, g = 155, b = 255, a = 80, type = 1 }, -- ???
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
            title = "INVENTAIRE",
            name = "main",
            buttons = {
                { name = "Couteau", weapon = "WEAPON_KNIFE" },
                { name = "Revolver lourd", weapon = "WEAPON_REVOLVER", ammo = "48" },
                { name = "Fusil à pompe d\'assaut", weapon = "WEAPON_ASSAULTSHOTGUN", ammo = "24" },
                { name = "Pistolet-mitrailleur", weapon = "WEAPON_MICROSMG", ammo = "140" },
                { name = "ADP de combat", weapon = "WEAPON_COMBATPDW", ammo = "100" },
                { name = "Fusil amélioré", weapon = "WEAPON_ADVANCEDRIFLE", ammo = "160" },
                { name = "Fusil de précision lourd", weapon = "WEAPON_HEAVYSNIPER", ammo = "24" },
                { name = "Lance-roquettes", weapon = "WEAPON_RPG", ammo = "10" },
                { name = "Bombe collante", weapon = "WEAPON_STICKYBOMB", ammo = "5" },
                { name = "Lampe de poche", weapon = "WEAPON_FLASHLIGHT" }
            }
        }
    }
}

---------------------------------------------------------------------
-- CONFIG SELECTION cf: https://marekkraus.sk/gtav/skins/ -----------
---------------------------------------------------------------------
function ButtonSelectedArmory(button)
    local ped = GetPlayerPed(-1)
    if secretservicearmory.currentmenu == "main" then
        if button.ammo ~= nil and tonumber(button.ammo) > 0 then
            TakeWeapon(ped, button.weapon, button.ammo)
        else
            TakeWeapon(ped, button.weapon)
        end
    end
end

function TakeWeapon(ped, weapon, ammo)
    if ammo ~= nil and tonumber(ammo) > 0 then
        GiveWeaponToPed(ped, GetHashKey(tostring(weapon)), tonumber(ammo), true, false)
    else
        GiveWeaponToPed(ped, GetHashKey(tostring(weapon)), true, false)
    end
end

-------------------------------------------------
---------------- CONFIG BACK MENU-----------------
-------------------------------------------------
function BackVest()
    if backlock then
        return
    end
    backlock = true
    if secretservicearmory.currentmenu == "main" then
        CloseSSAArmory()
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
function OpenSSAArmory()
    secretservicearmory.currentmenu = "main"
    secretservicearmory.opened = true
    secretservicearmory.selectedbutton = 0
end

-------------------------------------------------
---------------- FONCTION CLOSE-------------------
-------------------------------------------------
function CloseSSAArmory()
    secretservicearmory.opened = false
    secretservicearmory.menu.from = 1
    secretservicearmory.menu.to = 10
end

-------------------------------------------------
---------------- FONCTION OPEN MENU---------------
-------------------------------------------------

local armory = { x = 151.746, y = -760.687, z = 258.152 }

local backlock = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GetDistanceBetweenCoords(armory.x, armory.y, armory.z, GetEntityCoords(GetPlayerPed(-1))) > 2 then
            if secretservicearmory.opened then
                CloseSSAArmory()
            end
        end
        if secretservicearmory.opened then
            local ped = LocalPed()
            local menu = secretservicearmory.menu[secretservicearmory.currentmenu]
            drawTxt(secretservicearmory.title, 1, 1, secretservicearmory.menu.x, secretservicearmory.menu.y, 1.0, 255, 255, 255, 255)
            drawMenuTitle(menu.title, secretservicearmory.menu.x, secretservicearmory.menu.y + 0.08)
            drawTxt(secretservicearmory.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, secretservicearmory.menu.x + secretservicearmory.menu.width / 2 - 0.0385, secretservicearmory.menu.y + 0.067, 0.4, 255, 255, 255, 255)
            local y = secretservicearmory.menu.y + 0.12
            buttoncount = tablelength(menu.buttons)
            local selected = false

            for i, button in pairs(menu.buttons) do
                if i >= secretservicearmory.menu.from and i <= secretservicearmory.menu.to then

                    if i == secretservicearmory.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button, secretservicearmory.menu.x, y, selected)
                    if button.distance ~= nil then
                        drawMenuRight(button.distance .. "m", secretservicearmory.menu.x, y, selected)
                    end
                    y = y + 0.04
                    if selected and IsControlJustPressed(1, 201) then
                        ButtonSelectedArmory(button)
                    end
                end
            end
        end
        if secretservicearmory.opened then
            if IsControlJustPressed(1, 202) then
                BackVest()
            end
            if IsControlJustReleased(1, 202) then
                backlock = false
            end
            if IsControlJustPressed(1, 188) then
                if secretservicearmory.selectedbutton > 1 then
                    secretservicearmory.selectedbutton = secretservicearmory.selectedbutton - 1
                    if buttoncount > 10 and secretservicearmory.selectedbutton < secretservicearmory.menu.from then
                        secretservicearmory.menu.from = secretservicearmory.menu.from - 1
                        secretservicearmory.menu.to = secretservicearmory.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1, 187) then
                if secretservicearmory.selectedbutton < buttoncount then
                    secretservicearmory.selectedbutton = secretservicearmory.selectedbutton + 1
                    if buttoncount > 10 and secretservicearmory.selectedbutton > secretservicearmory.menu.to then
                        secretservicearmory.menu.to = secretservicearmory.menu.to + 1
                        secretservicearmory.menu.from = secretservicearmory.menu.from + 1
                    end
                end
            end
        end
    end
end)