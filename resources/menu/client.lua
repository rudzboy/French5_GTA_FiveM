Keys = {
    ["INPUT_ATTACK"] = 24,
    ["INPUT_SPRINT"] = 21,
    ["INPUT_VEH_CIN_CAM"] = 80,
    ["INPUT_PHONE"] = 27,
    ["INPUT_CELLPHONE_UP"] = 172,
    ["INPUT_CELLPHONE_DOWN"] = 173,
    ["INPUT_CELLPHONE_SELECT"] = 176,
    ["INPUT_CELLPHONE_CANCEL"] = 177,
    ["KEYBOARD_M"] = 244,
    ["KEYBOARD_Y"] = 246,
    ["KEYBOARD_N"] = 249,
    ["INPUT_MELEE_ATTACK_LIGHT"] = 140,
    ["INPUT_MELEE_ATTACK_HEAVY"] = 141,
    ["INPUT_MELEE_ATTACK_ALTERNATE"] = 142,
    ["INPUT_CELLPHONE_CAMERA_FOCUS_LOCK"] = 182,
    ["INPUT_VEH_HEADLIGHT"] = 74
}

local pauseMenu = false

local menuIsOpened = false
local menuSelector = false

local formIsOpened = false
local openedFormSelector = false

function LocalPed()
    return GetPlayerPed(-1)
end

-- Show Menu
function showGui()
    SendNUIMessage({
        type = "menu",
        visible = true
    })
end

-- Hide Menu
function hideGui()
    SendNUIMessage({
        type = "menu",
        visible = false
    })
end

-- Open Menu
function openGui(menuSelector)
    TriggerEvent("gcPhone:closePhone")
    SendNUIMessage({
        type = "menu",
        selector = menuSelector,
        display = true
    })
    menuIsOpened = true
end

-- Close Menu
function closeGui(menuSelector)
    SendNUIMessage({
        type = "menu",
        selector = menuSelector,
        display = false
    })
end

-- Open Form and disable NUI
function openForm(formSelector, formReceiver)
    SetNuiFocus(true)
    SendNUIMessage({
        type = "form",
        selector = formSelector,
        receiver = formReceiver,
        display = true
    })
    formIsOpened = true
    openedFormSelector = formSelector
    -- Cellphone Animation
    if formSelector == "phone-message" then
        TriggerEvent("anim:emote", "WORLD_HUMAN_STAND_MOBILE")
    end
end

-- Close Form and disable NUI
function closeForm(formSelector)
    SendNUIMessage({
        type = "form",
        selector = formSelector,
        display = false
    })
    formIsOpened = false
    openedFormSelector = false
    SetNuiFocus(false)
    -- Cellphone Animation
    if formSelector == "phone-message" then
        TriggerEvent("anim:clear")
    end
end

function updateGuiSelection(menuSelector, value)
    PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);
    SendNUIMessage({
        type = "menu",
        selector = menuSelector,
        selection = value
    })
end

function backGui(menuSelector)
    PlaySound(-1, "CANCEL", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);
    SendNUIMessage({
        type = "menu",
        selector = menuSelector,
        back = true
    })
end

function enterGui(menuSelector)
    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);
    SendNUIMessage({
        type = "menu",
        selector = menuSelector,
        enter = true
    })
end

function updateInventory(i)
    SendNUIMessage({
        type = "inventory",
        items = i
    })
end

function displayPhoneMessage(m, s)
    PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1);
    SendNUIMessage({
        type = "phone",
        message = m,
        sender = s
    })
end

-- Utility functions --

function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    for index, value in ipairs(players) do
        local target = GetPlayerPed(value)
        if (target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
            if (closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

function GetPlayers()
    local players = {}
    for i = 0, 1000 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function disableControls()
    DisableControlAction(0, Keys["INPUT_ATTACK"], true)
    DisableControlAction(0, Keys["INPUT_SPRINT"], true)
    DisableControlAction(0, Keys["INPUT_VEH_CIN_CAM"], true)
    DisableControlAction(0, Keys["INPUT_MELEE_ATTACK_LIGHT"], true)
    DisableControlAction(0, Keys["INPUT_MELEE_ATTACK_HEAVY"], true)
    DisableControlAction(0, Keys["INPUT_MELEE_ATTACK_ALTERNATE"], true)
    DisableControlAction(0, Keys["INPUT_CELLPHONE_CAMERA_FOCUS_LOCK"], true)
    DisableControlAction(0, Keys["INPUT_VEH_HEADLIGHT"], true)
end

-- Client threads --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsPauseMenuActive() and not pauseMenu then
            pauseMenu = true
            hideGui()
        elseif not IsPauseMenuActive() and pauseMenu then
            pauseMenu = false
            showGui()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if menuIsOpened then
            if formIsOpened == true then
                DisplayHelpText("Appuyez sur ~g~Entrée~w~ pour valider ou ~r~Échap~w~ pour annuler.")
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if menuIsOpened == true then

            disableControls()
            
            -- Correctif pour éviter le bug d'affichage du bloc "Message"
            -- Blocage de la fermeture du menu avant le fait d'annuler le message
            if formIsOpened == false then
                if IsControlJustReleased(1, Keys["KEYBOARD_M"]) then
                    closeGui(false)
                    menuSelector = false
                    menuIsOpened = false
                end
                if IsControlJustReleased(1, Keys["INPUT_CELLPHONE_UP"]) then
                    updateGuiSelection(menuSelector, "up")
                end
                if IsControlJustReleased(1, Keys["INPUT_CELLPHONE_DOWN"]) then
                    updateGuiSelection(menuSelector, "down")
                end
                if IsControlJustReleased(1, Keys["INPUT_CELLPHONE_CANCEL"]) then
                    backGui(menuSelector)
                end
                if IsControlJustReleased(1, Keys["INPUT_CELLPHONE_SELECT"]) then -- ~INPUT_PICKUP~
                    enterGui(menuSelector)
                end
            end
        else
            if IsControlJustReleased(1, Keys["KEYBOARD_M"]) then
                openGui("main")
            end
        end
    end
end)

RegisterNUICallback('close', function(data, cb)
    closeGui(false)
    cb('ok')
end)

RegisterNUICallback('update', function(data, cb)
    menuSelector = data.display
    if data.display ~= false then
        closeGui(data.current)
        openGui(data.display)
    else
        menuIsOpened = false
        closeGui(false)
    end
    cb('ok')
end)

RegisterNUICallback('action', function(data, cb)
    if data.event ~= nil then
        if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
            if data.event == "anim:emote" then
                TriggerEvent(data.event, data.dict)
            end
            if data.event == "anim:play" then
                TriggerEvent(data.event, data.dict, data.clip)
            end
            if data.event == "anim:clear" then
                TriggerEvent(data.event)
            end
            if data.event == "anim:playLoop" then
                TriggerEvent(data.event, data.dict, data.clip, true)
            end
            if data.event == "item:use" then
                TriggerEvent(data.event, data.id, data.libelle)
            end
            if data.event == "item:give" then
                TriggerEvent(data.event, data.id)
            end
            if data.event == "item:drop" then
                TriggerEvent(data.event, data.id, data.libelle, data.illegal)
            end
            if data.event == "player:animation" then
                TriggerEvent(data.event, data.dict, data.anim, tonumber(data.speed), tonumber(data.flags))
            end
        end
        if data.event == "phone:sendMessage" then
            TriggerServerEvent(data.event, data.message, data.receiver)
        end
        if data.event == "bank:givecash" then
            t, distance = GetClosestPlayer()
            if (distance ~= -1 and distance < 3) then
                TriggerServerEvent(data.event, GetPlayerServerId(t), tonumber(data.amount))
                TriggerEvent("anim:play", "mp_common", "givetake1_a")
            else
                TriggerEvent('showNotify', "~r~Aucun citoyen près de vous !")
            end
        end
        if data.event == "menu:wearMask" then
            TriggerEvent(data.event)
        end
        if data.event == "menu:removeMask" then
            TriggerEvent(data.event)
        end
        if data.event == "garages:swapLockPersonalVehicle" then
            TriggerEvent(data.event)
        end
    end
    if data.form ~= nil then
        if formIsOpened == false then
            openForm(data.form, data.receiver)
        end
    end
end)

RegisterNUICallback('closeform', function(data, cb)
    if data.selector ~= nil then
        closeForm(data.selector)
    end
    cb('ok')
end)

RegisterNetEvent("menu:updateInventory")
AddEventHandler("menu:updateInventory", function(items)
    updateInventory(items)
end)

RegisterNetEvent("player:animation")
AddEventHandler("player:animation", function(dict, anim, speed, flags)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end

    local playerPedId = PlayerPedId()
    --[[if IsEntityPlayingAnim(playerPedId, dict, anim, 3) then
      ClearPedTasksImmediately(playerPedId)
    else
      -- TaskPlayAnim(playerPedId, dict, anim, speed, speed, -1, flags, 0, 0, 0, 0)
    end
    ]]--
    TaskPlayAnim(playerPedId, dict, anim, speed, speed, -1, flags, 0, 0, 0, 0)
end)

RegisterNetEvent("menu:wearMask")
AddEventHandler("menu:wearMask", function()
    SetPedComponentVariation(LocalPed(), 1, 35, 0, 2)
end)

RegisterNetEvent("menu:removeMask")
AddEventHandler("menu:removeMask", function()
    SetPedComponentVariation(LocalPed(), 1, 0, 0, 2)
end)

RegisterNetEvent("phone:receiveMessage")
AddEventHandler("phone:receiveMessage", function(message, sender)
    displayPhoneMessage(message, sender)
end)

RegisterNetEvent("service:receiveMessage")
AddEventHandler("service:receiveMessage", function(message, senderId, senderName, user, jobId)
    if not IsEntityDead(GetPlayerPed(-1)) then
        displayPhoneMessage(message, senderName)
        Citizen.CreateThread(function()

            local messageAnswered = false
            TriggerEvent("showNotify", 'Message de ~b~' .. senderName .. '~w~.\nAppuyez sur ~g~Y~w~ pour accepter ou sur ~r~N~w~ pour refuser.')
            while messageAnswered ~= senderName do
                Citizen.Wait(0)
                if IsControlJustPressed(1, Keys["KEYBOARD_Y"]) then
                    TriggerEvent("showNotify", '~g~Vous avez accepté le message de ~b~' .. senderName .. '~w~.')
                    TriggerServerEvent("service:handleMessage", senderId, true, jobId)
                    SetNewWaypoint(user.coords.x, user.coords.y)
                    messageAnswered = senderName
                end
                if IsControlJustPressed(1, Keys["KEYBOARD_N"]) then
                    TriggerEvent("showNotify", '~r~Vous avez refusé le message de ~b~' .. senderName .. '~w~.')
                    TriggerServerEvent("service:handleMessage", senderId, false, jobId)
                    messageAnswered = senderName
                end
            end
        end)
    end
end)

-- BUILD MENU ON START --

AddEventHandler('onClientMapStart', function(res)
    SetNuiFocus(false)
    TriggerServerEvent("inventory:getItems")
    TriggerServerEvent("menu:getConnectedPlayers")
end)


--[[ UNUSED since gcphone ressource added

function updateRepertoire(p)
    SendNUIMessage({
        type = "phone",
        players = p
    })
end

RegisterNetEvent("menu:getConnectedPlayers")
AddEventHandler("menu:getConnectedPlayers", function(connectedPlayers)
    updateRepertoire(connectedPlayers)
end)

]]--