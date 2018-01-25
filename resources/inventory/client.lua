local Keys = {
    ["Y"] = 246,
    ["N"] = 249
}

local clientItems = {}

RegisterNetEvent("inventory:getItems")
AddEventHandler("inventory:getItems", function()
    TriggerServerEvent("inventory:getItems")
end)

RegisterNetEvent("inventory:updateInventory")
AddEventHandler("inventory:updateInventory", function(items)
    clientItems = items
    TriggerEvent("menu:updateInventory", clientItems)
end)

function ShowAboveRadarMessage(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0, 1)
end

RegisterNetEvent('showNotify')
AddEventHandler('showNotify', function(notify)
    ShowAboveRadarMessage(notify)
end)

RegisterNetEvent("item:drop")
AddEventHandler("item:drop", function(id, libelle, isIllegal)
    if (isIllegal == 1) then
        TriggerEvent('showNotify', '~r~Les objets illegaux ne peuvent pas être supprimés.')
    else
        TriggerServerEvent("inventory:removeItem", id, 1)
    end
end)

RegisterNetEvent("item:give")
AddEventHandler("item:give", function(id)
    local nearestPlayer = getNearPlayer()
    local senderCoords = GetEntityCoords(GetPlayerPed(-1))
    if nearestPlayer ~= nil then
        TriggerServerEvent("inventory:askForTransfer", id, 1, GetPlayerServerId(nearestPlayer), senderCoords.x, senderCoords.y, senderCoords.z)
    else
        TriggerEvent('showNotify', 'Aucun ~y~joueur~w~ n\'est ~b~suffisament proche~w~ de vous.')
    end
end)

RegisterNetEvent("inventory:askForTransfer")
AddEventHandler("inventory:askForTransfer", function(item_id, value, item_label, senderId, senderCoordsX, senderCoordsY, senderCoordsZ, senderName)

    local abortRequest = false
    local controlPressed = false
    local startTime = GetGameTimer()
    local delay = 15000 -- ms
    local requiredDistance = 3.0
    local player = GetPlayerPed(-1)
    local playerCoords

    TriggerEvent('showNotify', '~b~' .. senderName .. '~w~ veut vous donner ~g~' .. value .. ' ' .. item_label .. '~w~.')
    TriggerEvent("showNotify", 'Appuyez sur ~g~Y~w~ pour accepter ou sur ~r~N~w~ pour refuser.')

    while (not IsEntityDead(player) and not controlPressed and not abortRequest) do
        Citizen.Wait(0)
        playerCoords = GetEntityCoords(player)
        if (GetTimeDifference(GetGameTimer(), startTime) > delay) then
            abortRequest = true
            TriggerEvent('showNotify', 'Vous n\'avez ~r~pas accepté~w~ la demande dans le ~b~temps imparti~w~.')
            TriggerServerEvent("inventory:transferAborted", senderId)
            break
        end
        if (Vdist(senderCoordsX, senderCoordsY, senderCoordsZ, playerCoords.x, playerCoords.y, playerCoords.z) > requiredDistance) then
            abortRequest = true
            TriggerEvent('showNotify', 'Vous vous êtes ~b~trop éloigné~w~ du joueur sans accepter son offre.')
            TriggerServerEvent("inventory:transferAborted", senderId)
            break
        end
        if IsControlPressed(1, Keys["Y"]) then
            TriggerEvent("inventory:transferAccepted", item_id, value, senderId)
            controlPressed = true
        end
        if IsControlPressed(1, Keys["N"]) then
            TriggerEvent('showNotify', 'Vous avez ~y~refusé~w~ l\'offre de ' .. senderName .. '.')
            TriggerServerEvent("inventory:transferRefused", senderId)
            controlPressed = true
        end
    end
end)

RegisterNetEvent("inventory:transferAccepted")
AddEventHandler("inventory:transferAccepted", function(id, value, senderId)
    TriggerServerEvent("inventory:transferItem", id, value, senderId)
end)

RegisterNetEvent("inventory:transferCompleted")
AddEventHandler("inventory:transferCompleted", function(id, value)
    TriggerServerEvent("inventory:removeItem", id, value)
end)

function getPlayers()
    local playerList = {}
    for i = 0, 1000 do
        local player = GetPlayerFromServerId(i)
        if NetworkIsPlayerActive(player) then
            table.insert(playerList, player)
        end
    end
    return playerList
end

function getNearPlayer()
    local players = getPlayers()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local pos2
    local distance
    local minDistance = 3
    local playerNear
    for _, player in pairs(players) do
        local playerPed = GetPlayerPed(player)
        if playerPed ~= nil and not IsEntityDead(playerPed) then
            pos2 = GetEntityCoords(playerPed)
            distance = GetDistanceBetweenCoords(pos["x"], pos["y"], pos["z"], pos2["x"], pos2["y"], pos2["z"], true)
            if (pos ~= pos2 and distance < minDistance) then
                playerNear = player
                minDistance = distance
            end
        end
    end
    if (minDistance < 3) then
        return playerNear
    end
end

--[[
  USABLE ITEMS
]]--

-- CONFIG --
local usableItemsId = { 1, 2, 3, 4, 5, 26, 27, 28, 29, 30 }
-- then use "item:use" event to set what happens when any item is used --
-- END CONFIG --

function isItemUsable(id)
    for _, v in pairs(usableItemsId) do
        if v == id then
            return true
        end
    end
    return false
end

RegisterNetEvent("item:use")
AddEventHandler("item:use", function(id, libelle)
    if isItemUsable(id) then
        TriggerEvent('showNotify', 'Vous avez consommé : ~b~' .. libelle)
        TriggerServerEvent("inventory:removeItem", id, 1)
        -- Water --
        if id == 1 then
            TriggerEvent("f5c:playerDrink", 25)
            TriggerEvent("player:animation", "mp_player_intdrink", "loop_bottle", 4.0, 16)
        end
        -- Cola / Orange Juice --
        if id == 26 or id == 27 then
            TriggerEvent("f5c:playerDrink", 35)
            TriggerEvent("player:animation", "mp_player_intdrink", "loop_bottle", 4.0, 16)
        end
        -- Hamburger --
        if id == 2 then
            TriggerEvent("f5c:playerEat", 35)
            TriggerEvent("player:animation", "mp_player_inteat@burger", "mp_player_int_eat_burger", 4.0, 16)
        end
        -- Sandwich --
        if id == 3 then
            TriggerEvent("f5c:playerEat", 25)
            TriggerEvent("player:animation", "mp_player_inteat@burger", "mp_player_int_eat_burger", 4.0, 16)
        end
        -- Smoke --
        if id == 4 or id == 5 then
            TriggerEvent("anim:emote", "WORLD_HUMAN_SMOKING_POT")
            TriggerEvent("anim:effectHigh")
            Citizen.Wait(120000)
            TriggerEvent("anim:effectNormal")
        end
        -- Alcool Vodka --
        if id == 28 then
            TriggerEvent("f5c:playerDrink", 15)
            TriggerEvent("player:animation", "mp_player_intdrink", "loop_bottle", 4.0, 16)
            TriggerEvent("anim:effectDrunk")
            Citizen.Wait(180000)
            TriggerEvent("anim:effectNormal")
        end

        -- Bandages --
        if id == 29 then
            local playerPed = GetPlayerPed(-1)
            if not IsEntityDead(playerPed) then
                SetEntityHealth(playerPed, GetPedMaxHealth(playerPed))
                TriggerEvent('showNotify', 'Vous vous êtes ~g~soigné~w~.')
            end
        end

        -- Kit de crochetage --
        if id == 30 then
            local playerPed = GetPlayerPed(-1)
            local pos = GetEntityCoords(playerPed)
            local entityWorld = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 20.0, 0.0)
            local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, playerPed, 0)
            local a, b, c, d, vehicleHandle = GetRaycastResult(rayHandle)
            if (DoesEntityExist(vehicleHandle)) then
                local luck = math.random(1, 100)
                if luck > 30 then
                    SetVehicleDoorsLocked(vehicleHandle, 1)
                    TriggerEvent('showNotify', "Crochetage : ~g~Succès~w~.")
                    TaskEnterVehicle(playerPed, vehicleHandle, 500, -1, 2.0, 1, 0)
                elseif luck <= 2 then
                    ClearPedTasksImmediately(playerPed)
                    NetworkExplodeVehicle(vehicleHandle, true, false, 0)
                    TriggerEvent('showNotify', "Crochetage : ~r~Échec critique~w~.")
                else
                    ClearPedTasksImmediately(playerPed)
                    TriggerEvent('showNotify', "Crochetage : ~r~Échec~w~.")
                end
            end
        end
    else
        TriggerEvent('showNotify', '~r~Cet objet ne peut pas être utilisé.')
    end
end)
