-----------------------------------------------------------------------------------------------------------------
---------------------------------------------------- Cop Locker---------------------------------------------
-----------------------------------------------------------------------------------------------------------------
local policearmory = {
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
                { name = "Matraque", weapon = "WEAPON_NIGHTSTICK" },
                { name = "Pistolet paralysant", weapon = "WEAPON_STUNGUN" },
                { name = "Pistolet cal.50", weapon = "WEAPON_PISTOL50", ammo = "48" },
                { name = "Fusil à pompe", weapon = "WEAPON_PUMPSHOTGUN", ammo = "24" },
                { name = "Mitraillette", weapon = "WEAPON_SMG", ammo = "80" },
                { name = "Fusil de précision", weapon = "WEAPON_SNIPERRIFLE", ammo = "24" },
                { name = "Grenades lacrymogènes", weapon = "WEAPON_SMOKEGRENADE", ammo = "5" },
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
    if policearmory.currentmenu == "main" then
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
    if policearmory.currentmenu == "main" then
        CloseArmory()
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
function OpenArmory()
    policearmory.currentmenu = "main"
    policearmory.opened = true
    policearmory.selectedbutton = 0
end

-------------------------------------------------
---------------- FONCTION CLOSE-------------------
-------------------------------------------------
function CloseArmory()
    policearmory.opened = false
    policearmory.menu.from = 1
    policearmory.menu.to = 10
end

-------------------------------------------------
---------------- FONCTION OPEN MENU---------------
-------------------------------------------------

local armory = { x = 451.7, y = -980.01, z = 30.6895866394043 }

local backlock = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if GetDistanceBetweenCoords(armory.x, armory.y, armory.z, GetEntityCoords(GetPlayerPed(-1))) > 2 then
            if policearmory.opened then
                CloseArmory()
            end
        end
        if policearmory.opened then
            local ped = LocalPed()
            local menu = policearmory.menu[policearmory.currentmenu]
            drawTxt(policearmory.title, 1, 1, policearmory.menu.x, policearmory.menu.y, 1.0, 255, 255, 255, 255)
            drawMenuTitle(menu.title, policearmory.menu.x, policearmory.menu.y + 0.08)
            drawTxt(policearmory.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, policearmory.menu.x + policearmory.menu.width / 2 - 0.0385, policearmory.menu.y + 0.067, 0.4, 255, 255, 255, 255)
            local y = policearmory.menu.y + 0.12
            buttoncount = tablelength(menu.buttons)
            local selected = false

            for i, button in pairs(menu.buttons) do
                if i >= policearmory.menu.from and i <= policearmory.menu.to then

                    if i == policearmory.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button, policearmory.menu.x, y, selected)
                    if button.distance ~= nil then
                        drawMenuRight(button.distance .. "m", policearmory.menu.x, y, selected)
                    end
                    y = y + 0.04
                    if selected and IsControlJustPressed(1, 201) then
                        ButtonSelectedArmory(button)
                    end
                end
            end
        end
        if policearmory.opened then
            if IsControlJustPressed(1, 202) then
                BackVest()
            end
            if IsControlJustReleased(1, 202) then
                backlock = false
            end
            if IsControlJustPressed(1, 188) then
                if policearmory.selectedbutton > 1 then
                    policearmory.selectedbutton = policearmory.selectedbutton - 1
                    if buttoncount > 10 and policearmory.selectedbutton < policearmory.menu.from then
                        policearmory.menu.from = policearmory.menu.from - 1
                        policearmory.menu.to = policearmory.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1, 187) then
                if policearmory.selectedbutton < buttoncount then
                    policearmory.selectedbutton = policearmory.selectedbutton + 1
                    if buttoncount > 10 and policearmory.selectedbutton > policearmory.menu.to then
                        policearmory.menu.to = policearmory.menu.to + 1
                        policearmory.menu.from = policearmory.menu.from + 1
                    end
                end
            end
        end
    end
end)