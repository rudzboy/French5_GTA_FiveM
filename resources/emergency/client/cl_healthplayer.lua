--[[
- Base credits: https://github.com/Jyben/emergency
--]]

local Keys = { ["P"] = 199 }
local lang = 'fr'
local txt = {
    ['fr'] = {
        ['inComa'] = '~r~Vous êtes dans le coma',
        ['accident'] = 'Un accident s\'est produit',
        ['murder'] = 'Tentative de meurtre',
        ['ambIsComming'] = 'Une ~b~ambulance~s~ est en route ! Tenez bon.',
        ['res'] = 'Vous avez été réanimé',
        ['ko'] = 'Vous êtes KO !',
        ['callAmb'] = 'Appuyez sur ~g~E~s~ pour appeler une ambulance',
        ['getDressed'] = 'Appuyez sur ~INPUT_PICKUP~ pour mettre vos vêtements',
        ['respawn'] = 'Appuyez sur ~r~P~w~ (ou ~r~Start~w~) pour aller à l\'~b~hôpital~w~.',
        ['youCallAmb'] = 'Vous avez appelé une ~b~ambulance~s~.',
        ['noDoc'] = 'Pas de ~b~médecin~w~ en service.'
    }
}

local hospital = {
    x = 253.521,
    y = -1351.04,
    z = 24.53781
}

local hospitalLocker= {
    x = 268.633,
    y = -1363.45,
    z = 24.53781
}

--[[
################################
            THREADS
################################
--]]

-- Display Map Blips
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(hospital.x, hospital.y, hospital.z)
    SetBlipSprite(blip, 61)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Hôpital")
    EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    local knockedOutDuration = 10000
    local knockedOutThreshold = 120
    while true do
        Citizen.Wait(1)
        local playerPed = GetPlayerPed(-1)
        if GetEntityHealth(playerPed) < knockedOutThreshold and not IsEntityDead(playerPed) and IsPedInMeleeCombat(playerPed) then
            SendNotification(txt[lang]['ko'])
            SetPedToRagdoll(playerPed, knockedOutDuration, knockedOutDuration, 0, 0, 0, 0)
        end
    end
end)

--[[
################################
            FUNCTIONS
################################
--]]

function OnPlayerDied(playerId, reasonID, reason)
    TriggerServerEvent('es_em:setPlayerIsDead', 1)
    TriggerEvent('es_em:startDeathScene')
end

function SendNotification(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, false)
end

--[[
################################
            EVENTS
################################
--]]

AddEventHandler("playerSpawned", function(spawn)
    exports.spawnmanager:setAutoSpawn(false)
end)

AddEventHandler('baseevents:onPlayerDied', function(playerId, reasonID)
    local reason = txt[lang]['accident']
    OnPlayerDied(playerId, reasonID, reason)
end)

AddEventHandler('baseevents:onPlayerKilled', function(playerId, playerKill, reasonID)
    local reason = txt[lang]['murder']
    OnPlayerDied(playerId, reasonID, reason)
end)

--[[
################################
          CUSTOM EVENTS
################################
--]]

RegisterNetEvent('es_em:isPlayedDead')
AddEventHandler('es_em:isPlayedDead', function(emsPlayerId)
    local playerPed = GetPlayerPed(-1)
    local pos = GetEntityCoords(playerPed)
    if IsEntityDead(playerPed) then
        if emsPlayerId == GetPlayerServerId(PlayerId()) then
            SendNotification('~r~Impossible de vous soigner...')
        else
            TriggerServerEvent('ems:announceDead', pos.x, pos.y, pos.z, emsPlayerId)
        end
    end
end)

RegisterNetEvent('es_em:isPlayedInjured')
AddEventHandler('es_em:isPlayedInjured', function(emsPlayerId)
    local playerPed = GetPlayerPed(-1)
    local pos = GetEntityCoords(playerPed)
    if (GetEntityHealth(playerPed) < GetPedMaxHealth(playerPed)) and not IsEntityDead(playerPed) then
        if emsPlayerId ~= GetPlayerServerId(PlayerId()) then
            TriggerServerEvent('ems:announceInjured', pos.x, pos.y, pos.z, emsPlayerId)
        end
    end
end)

RegisterNetEvent('es_em:cl_resurectPlayer')
AddEventHandler('es_em:cl_resurectPlayer', function()
    TriggerServerEvent('es_em:setPlayerIsDead', 0)
    local playerPed = GetPlayerPed(-1)
    ResurrectPed(playerPed)
    SetEntityHealth(playerPed, GetPedMaxHealth(playerPed) / 2)
    TriggerServerEvent("f5c:updateBasicNeedsValues", 15, 15)
    ClearPedTasksImmediately(playerPed)
    SendNotification(txt[lang]['res'])
end)

RegisterNetEvent('es_em:cl_healPlayer')
AddEventHandler('es_em:cl_healPlayer', function()
    local playerPed = GetPlayerPed(-1)
    SetEntityHealth(playerPed, GetPedMaxHealth(playerPed))
    ResetPedVisibleDamage(playerPed)
    ClearPedTasksImmediately(playerPed)
    SendNotification('Vous avez été ~g~soigné~w~.')
end)

RegisterNetEvent('es_em:cl_respawn')
AddEventHandler('es_em:cl_respawn', function()
    TriggerEvent('es_em:respawnPlayerAtHospital')
end)

RegisterNetEvent('es_em:respawnPlayerAtHospital')
AddEventHandler('es_em:respawnPlayerAtHospital', function()
    TriggerServerEvent("f5c:updateBasicNeedsValues", 30, 30)
    TriggerServerEvent('es_em:sv_removeMoney')
    TriggerServerEvent("inventory:reset")
    TriggerServerEvent("weaponshop:deletePlayerWeapons")
    DoScreenFadeOut(1000)
    while IsScreenFadingOut() do Citizen.Wait(0) end
    TriggerServerEvent('es_em:setPlayerIsDead', 0)
    NetworkResurrectLocalPlayer(hospital.x, hospital.y, hospital.z, true, true, false)
    Wait(1000)
    RemoveAllPedWeapons(GetPlayerPed(-1), true)
    setHospitalWear(GetPlayerPed(-1))
    DoScreenFadeIn(1000)
    while IsScreenFadingIn() do Citizen.Wait(0) end
end)

RegisterNetEvent('es_em:startDeathScene')
AddEventHandler('es_em:startDeathScene', function()
    if IsEntityDead(GetPlayerPed(-1)) then
        StartScreenEffect("DeathFailOut", 0, 0)
        ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
        local scaleform = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")
        while not HasScaleformMovieLoaded(scaleform) do
            Citizen.Wait(0)
        end
        if HasScaleformMovieLoaded(scaleform) then
            PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
            BeginTextComponent("STRING")
            AddTextComponentString(txt[lang]['inComa'])
            EndTextComponent()
            PopScaleformMovieFunctionVoid()
            Citizen.Wait(500)
            SendNotification(txt[lang]['respawn'])
            while IsEntityDead(GetPlayerPed(-1)) do
                Citizen.Wait(0)
                DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
                if (IsControlJustReleased(1, Keys['P'])) then
                    TriggerEvent('es_em:respawnPlayerAtHospital')
                end
            end
            StopScreenEffect("DeathFailOut")
        end
    end
end)

-- USE FOR DEBUG
--[[
AddEventHandler("onClientResourceStart", function(name)
  if name == "emergency" then
    exports.spawnmanager:setAutoSpawn(false)
  end
end)
]]--

function setHospitalWear(playerPed)
    if (GetEntityModel(playerPed) == GetHashKey("mp_m_freemode_01")) then
        SetPedComponentVariation(playerPed, 11, 114, 0, 2)
        SetPedComponentVariation(playerPed, 8, 15, 0, 2)
        SetPedComponentVariation(playerPed, 4, 56, 0, 2)
        SetPedComponentVariation(playerPed, 3, 14, 0, 2)
        SetPedComponentVariation(playerPed, 6, 34, 0, 2)
        SetPedComponentVariation(playerPed, 10, 8, 0, 2)
    elseif (GetEntityModel(playerPed) == GetHashKey("mp_f_freemode_01")) then
        SetPedComponentVariation(playerPed, 11, 105, 0, 2)
        SetPedComponentVariation(playerPed, 8, 15, 0, 2)
        SetPedComponentVariation(playerPed, 4, 57, 0, 2)
        SetPedComponentVariation(playerPed, 3, 15, 0, 2)
        SetPedComponentVariation(playerPed, 6, 35, 0, 2)
        SetPedComponentVariation(playerPed, 10, 7, 0, 2)
    end
    ClearAllPedProps(playerPed)
end

-- HOSPITAL LOCKER --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local playerPos = GetEntityCoords(GetPlayerPed(-1), true)
        if (Vdist(playerPos.x, playerPos.y, playerPos.z, hospitalLocker.x, hospitalLocker.y, hospitalLocker.z) < 20.0) then
            DrawMarker(1, hospitalLocker.x, hospitalLocker.y, hospitalLocker.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0, 165, 0, 0, 0, 0)
            if (Vdist(playerPos.x, playerPos.y, playerPos.z, hospitalLocker.x, hospitalLocker.y, hospitalLocker.z) < 2.0) then
                DisplayHelpText(txt[lang]['getDressed'])
                if (IsControlJustReleased(1, 38)) then
                    DoScreenFadeOut(1000)
                    while IsScreenFadingOut() do Citizen.Wait(0) end
                    TriggerServerEvent("mm:otherspawn")
                    DoScreenFadeIn(1000)
                    while IsScreenFadingIn() do Citizen.Wait(0) end
                end
            end
        end
    end
end)