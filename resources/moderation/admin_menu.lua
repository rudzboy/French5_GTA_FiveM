local accessGranted = false
local inputpos = 0
local inputteleport = 0
local inputgoto = 0
local inputkick = 0
local godmode = false
local invisible = false
local noclip = false
local noclip_speed = 2.0

local adminmenu = {
    opened = false,
    title = "Modération",
    currentmenu = "main",
    lastmenu = nil,
    currentpos = nil,
    selectedbutton = 0,
    marker = { r = 255, g = 234, b = 0, a = 200, type = 1 },
    menu = {
        x = 0.1,
        y = 0.22,
        width = 0.2,
        height = 0.04,
        buttons = 8,
        from = 1,
        to = 10,
        scale = 0.4,
        font = 0,
        ["main"] = {
            title = "CATEGORIES",
            name = "main",
            buttons = {
                { name = "Voir le nom des joueurs", description = '' },
                { name = "Invincible", description = '' },
                { name = "No-Clip", description = '' },
                { name = "Invisible", description = '' },
                { name = "Kick", description = '' },
                -- {name = "Ban", description = ''}, -- Non autorisé --
                { name = "Se téléporter vers un joueur", description = '' },
                { name = "Ammener un joueur", description = '' },
                { name = "Se téléporter à une position", description = '' },
                { name = "Afficher vos coordonnées", description = '' },
            }
        }
    }
}

RegisterNetEvent('moderation:accessGranted')
AddEventHandler('moderation:accessGranted', function()
    accessGranted = true
    TriggerEvent('showNotify', "Vous avez ~g~accès~w~ au menu de ~y~modération~w~ via la touche ~b~F7~w~.")
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('moderation:checkPermission')
end)

function OpenCreatoradminmenu()
    adminmenu.currentmenu = "main"
    adminmenu.opened = true
    adminmenu.selectedbutton = 0
end

function CloseCreatoradminmenu()
    Citizen.CreateThread(function()
        adminmenu.opened = false
        adminmenu.menu.from = 1
        adminmenu.menu.to = 8
    end)
end

-- UI DISPLAY FUNCTIONS --

function drawMenuButton(button, x, y, selected)
    local menu = adminmenu.menu
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

function drawMenuInfo(text)
    local menu = adminmenu.menu
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

function drawMenuRight(txt, x, y, selected)
    local menu = adminmenu.menu
    SetTextFont(menu.font)
    SetTextProportional(0)
    SetTextScale(menu.scale, menu.scale)
    SetTextRightJustify(1)
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

function drawMenuTitleCivmen(txt, x, y)
    local menu = adminmenu.menu
    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(txt)
    DrawRect(x, y, menu.width, menu.height, 117, 202, 93, 150)
    DrawText(x - menu.width / 2 + 0.005, y - menu.height / 2 + 0.0028)
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function NotifyAdminMenu(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function ShowNotificationMenuAdmin2(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

local backlock = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if accessGranted and IsControlJustPressed(1, 168) then -- F7 --
            if adminmenu.opened then
                CloseCreatoradminmenu()
            else
                OpenCreatoradminmenu()
            end
        end
        if adminmenu.opened then
            local menu = adminmenu.menu[adminmenu.currentmenu]
            drawTxt(adminmenu.title, 1, 1, adminmenu.menu.x, adminmenu.menu.y, 1.0, 255, 255, 255, 255)
            drawMenuTitleCivmen(menu.title, adminmenu.menu.x, adminmenu.menu.y + 0.08)
            drawTxt(adminmenu.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, adminmenu.menu.x + adminmenu.menu.width / 2 - 0.0385, adminmenu.menu.y + 0.067, 0.4, 255, 255, 255, 255)
            local y = adminmenu.menu.y + 0.12
            local buttoncount = tablelength(menu.buttons)
            local selected = false

            for i, button in pairs(menu.buttons) do
                if i >= adminmenu.menu.from and i <= adminmenu.menu.to then

                    if i == adminmenu.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button, adminmenu.menu.x, y, selected)
                    y = y + 0.04
                    if selected and IsControlJustPressed(1, 201) then
                        ButtonSelectedAdminMenu(button)
                    end
                end
            end

            if IsControlJustPressed(1, 202) then
                BackAdminMenu()
            end
            if IsControlJustReleased(1, 202) then
                backlock = false
            end
            if IsControlJustPressed(1, 188) then
                if adminmenu.selectedbutton > 1 then
                    adminmenu.selectedbutton = adminmenu.selectedbutton - 1
                    if buttoncount > 8 and adminmenu.selectedbutton < adminmenu.menu.from then
                        adminmenu.menu.from = adminmenu.menu.from - 1
                        adminmenu.menu.to = adminmenu.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1, 187) then
                if adminmenu.selectedbutton < buttoncount then
                    adminmenu.selectedbutton = adminmenu.selectedbutton + 1
                    if buttoncount > 8 and adminmenu.selectedbutton > adminmenu.menu.to then
                        adminmenu.menu.to = adminmenu.menu.to + 1
                        adminmenu.menu.from = adminmenu.menu.from + 1
                    end
                end
            end
        end
    end
end)

function DrawTextAdmin(m_text, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(m_text)
    DrawSubtitleTimed(showtime, 1)
end

function ButtonSelectedAdminMenu(button)
    local this = adminmenu.currentmenu
    local btn = button.name

    if this == "main" then
        if btn == "No-Clip" then
            NoClip()
        elseif btn == "Kick" then
            DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
            ShowNotificationMenuAdmin2("~b~Entrez l'id du joueur")
            inputkick = 1
            CloseCreatoradminmenu()
            -- elseif btn == "Ban" then
            -- DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
            -- ShowNotificationMenuAdmin2("~b~Entrez l'id du joueur")
            -- inputban = 1
            -- CloseCreatoradminmenu()
        elseif btn == "Se téléporter vers un joueur" then
            DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
            ShowNotificationMenuAdmin2("~b~Entrez l'id du joueur")
            inputgoto = 1
            CloseCreatoradminmenu()
        elseif btn == "Ammener un joueur" then
            DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
            ShowNotificationMenuAdmin2("~b~Entrez l'id du joueur")
            inputteleport = 1
            CloseCreatoradminmenu()
        elseif btn == "Se téléporter à une position" then
            DisplayOnscreenKeyboard(true, "FMMC_KEY_TIP8", "", "", "", "", "", 120)
            ShowNotificationMenuAdmin2("~b~Entrez la position...")
            inputpos = 1
            CloseCreatoradminmenu()
        elseif btn == "Afficher vos coordonnées" then
            local x, y, z = getPosition()
            DrawTextAdmin("Coordonnées: " .. x .. ", " .. y .. ", " .. z, 60000)
        elseif btn == "Invincible" then
            Invincible()
        elseif btn == "Invisible" then
            Invisible()
        elseif btn == "Voir le nom des joueurs" then
            ViewPlayerNames()
        end
    end
end

function OpenMenuAdminmenu(menu)
    adminmenu.lastmenu = adminmenu.currentmenu
    adminmenu.menu.from = 1
    adminmenu.menu.to = 8
    adminmenu.selectedbutton = 0
    adminmenu.currentmenu = menu
end

function BackAdminMenu()
    if backlock then
        return
    end
    backlock = true
    if adminmenu.currentmenu == "main" then
        CloseCreatoradminmenu()
    else
        OpenMenuAdminmenu(adminmenu.lastmenu)
    end
end

function stringstartsAdminMenu(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function DrawMissionText3(m_text, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(m_text)
    DrawSubtitleTimed(showtime, 1)
end

function Notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- FUNCTION : NOCLIP + INVINCIBLE + INVISIBLE --

function NoClip()
    noclip = not noclip
    local ped = GetPlayerPed(-1)
    if noclip then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
        invisible = true
        godmode = true
        Notify("NoClip ~g~activé~w~.")
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
        invisible = false
        godmode = false
        Notify("NoClip ~r~désactivé~w~.")
    end
end

function getPosition()
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
    return x, y, z
end

function getCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(GetPlayerPed(-1))
    local pitch = GetGameplayCamRelativePitch()

    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)

    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end

    return x, y, z
end

-- THREAD : NOCLIP + INVINCIBLE + INVISIBLE --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if noclip then
            local ped = GetPlayerPed(-1)
            local x, y, z = getPosition()
            local dx, dy, dz = getCamDirection()
            local speed = noclip_speed

            -- reset du velocity
            SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)

            -- aller vers le haut
            if IsControlPressed(0, 32) then -- MOVE UP
                x = x + speed * dx
                y = y + speed * dy
                z = z + speed * dz
            end

            -- aller vers le bas
            if IsControlPressed(0, 269) then -- MOVE DOWN
                x = x - speed * dx
                y = y - speed * dy
                z = z - speed * dz
            end

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
        end
    end
end)

-- TP --

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if inputpos == 1 then
            if UpdateOnscreenKeyboard() == 3 then
                inputpos = 0
            elseif UpdateOnscreenKeyboard() == 1 then
                inputpos = 2
            elseif UpdateOnscreenKeyboard() == 2 then
                inputpos = 0
            end
        end
        if inputpos == 2 then
            local pos = GetOnscreenKeyboardResult() -- GetOnscreenKeyboardResult RECUPERE LA POSITION RENTRER PAR LE JOUEUR
            local _, _, x, y, z = string.find(pos or "0,0,0", "([%d%.]+),([%d%.]+),([%d%.]+)")
            SetEntityCoords(GetPlayerPed(-1), tonumber(x + 0.0001), tonumber(y + 0.0001), tonumber(z + 0.0001), 1, 0, 0, 1) -- TP LE JOUEUR A LA POSITION
            --TriggerServerEvent('vmenu:giveCash_s', GetPlayerServerId(sendTarget), addCash)
            inputpos = 0
        end
    end
end)

-- BRING --

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if inputteleport == 1 then
            if UpdateOnscreenKeyboard() == 3 then
                inputteleport = 0
            elseif UpdateOnscreenKeyboard() == 1 then
                inputteleport = 2
            elseif UpdateOnscreenKeyboard() == 2 then
                inputteleport = 0
            end
        end
        if inputteleport == 2 then
            --local x,y,z = getPosition()
            local teleportply = GetOnscreenKeyboardResult()
            local playerPed = GetPlayerFromServerId(tonumber(teleportply))
            local teleportPed = GetEntityCoords(GetPlayerPed(-1))
            SetEntityCoords(playerPed, teleportPed)
            inputteleport = 0
        end
    end
end)

-- GOTO --

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if inputgoto == 1 then
            if UpdateOnscreenKeyboard() == 3 then
                inputgoto = 0
            elseif UpdateOnscreenKeyboard() == 1 then
                inputgoto = 2
            elseif UpdateOnscreenKeyboard() == 2 then
                inputgoto = 0
            end
        end
        if inputgoto == 2 then
            --local x,y,z = getPosition()
            local gotoply = GetOnscreenKeyboardResult()
            --local tplayer = GetPlayerPed(GetPlayerFromServerId(id))
            --x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(gotoply) , true))
            -- x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(gotoply) , true)))
            -- SetEntityCoords(GetPlayerPed(-1), x+0.0001, y+0.0001, z+0.0001, 1, 0, 0, 1)
            local playerPed = GetPlayerPed(-1)
            local teleportPed = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(gotoply))))
            SetEntityCoords(playerPed, teleportPed)

            inputgoto = 0
        end
    end
end)

-- KICK --

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if inputkick == 1 then
            if UpdateOnscreenKeyboard() == 3 then
                inputkick = 0
            elseif UpdateOnscreenKeyboard() == 1 then
                inputkick = 2
            elseif UpdateOnscreenKeyboard() == 2 then
                inputkick = 0
            end
        end
        if inputkick == 2 then

            local kickid = GetOnscreenKeyboardResult() -- GetOnscreenKeyboardResult RECUPERE L'ID RENTRER PAR LE JOUEUR
            TriggerServerEvent('moderation:kick', kickid)
            inputkick = 0
        end
    end
end)

-- INVINCIBLE --

function Invincible()
    godmode = not godmode
    local ped = GetPlayerPed(-1)
    if godmode then -- activé
        SetEntityInvincible(ped, true)
        Notify("Invincibilité ~g~activée~w~.")
    else
        SetEntityInvincible(ped, false)
        Notify("Invincibilité ~r~désactivée~w~.")
    end
end

-- INVISIBLE --

function Invisible()
    invisible = not invisible
    local ped = GetPlayerPed(-1)
    if invisible then
        SetEntityVisible(ped, false, false)
        Notify("Invisibilité ~g~activée~w~.")
    else
        SetEntityVisible(ped, true, false)
        Notify("Invisibilité ~r~désactivée~w~.")
    end
end

function ViewPlayerNames()
    TriggerEvent("es_admin:viewname")
end