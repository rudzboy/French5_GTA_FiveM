local animPlay = false

function stopEmote()
    local ped = GetPlayerPed(-1);
    if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped) then
        ClearPedTasks(ped)
        animPlay = false
    end
end

RegisterNetEvent("anim:emote")
AddEventHandler("anim:emote", function(emoteNane)
    local ped = GetPlayerPed(-1);
    if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped) then
        TaskStartScenarioInPlace(ped, emoteNane, 0, false)
        animPlay = true
    end
end)


RegisterNetEvent("anim:play")
AddEventHandler("anim:play", function(dictionaries, clip)
    local ped = GetPlayerPed(-1)
    if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped) then
        Citizen.CreateThread(function()
            RequestAnimDict(dictionaries)
            while not HasAnimDictLoaded(dictionaries) do
                Citizen.Wait(100)
            end

            if IsEntityPlayingAnim(ped, dictionaries, clip, 3) then
                ClearPedSecondaryTask(ped)
                animPlay = false
            else
                TaskPlayAnim(ped, dictionaries, clip, 8.0, -8, -1, 16, 0, 0, 0, 0)
                animPlay = true
            end
        end)
    end
end)

RegisterNetEvent("anim:playLoop")
AddEventHandler("anim:playLoop", function(dictionaries, clip, loop)
    local lPed = GetPlayerPed(-1)
    if DoesEntityExist(lPed) and not IsPedInAnyVehicle(lPed) then
        Citizen.CreateThread(function()
            RequestAnimDict(dictionaries)
            while not HasAnimDictLoaded(dictionaries) do
                Citizen.Wait(100)
            end

            if IsEntityPlayingAnim(lPed, dictionaries, clip, 3) then
                ClearPedSecondaryTask(lPed)
                --SetEnableYes(lPed, false)
            else
                local flag = 16
                if loop == true then
                    flag = 49
                end
                TaskPlayAnim(lPed, dictionaries, clip, 8.0, -8, -1, flag, 0, 0, 0, 0)
                --SetEnableYes(lPed, true)
            end
        end)
    end
end)

RegisterNetEvent("anim:clear")
AddEventHandler("anim:clear", function()
    local ped = GetPlayerPed(-1)
    if DoesEntityExist(ped) and not IsPedInAnyVehicle(ped) then
        Citizen.CreateThread(function()
            stopEmote()
            --ClearPedSecondaryTask(lPed)
            --SetEnableYes(lPed, false)
        end)
    end
end)

RegisterNetEvent("anim:effectHigh")
AddEventHandler("anim:effectHigh", function()
    local ped = GetPlayerPed(-1)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_DRUG_DEALER", 0, 1)
    RequestAnimSet("MOVE_M@DRUNK@SLIGHTLYDRUNK")
    while not HasAnimSetLoaded("MOVE_M@DRUNK@SLIGHTLYDRUNK") do
        Citizen.Wait(0)
    end
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearPedTasksImmediately(ped)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(ped, true)
    SetPedMovementClipset(ped, "MOVE_M@DRUNK@SLIGHTLYDRUNK", true)
    SetPedIsDrunk(ped, true)
end)

RegisterNetEvent("anim:effectNormal")
AddEventHandler("anim:effectNormal", function()
    local ped = GetPlayerPed(-1)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(ped, 0)
    SetPedIsDrunk(ped, false)
    SetPedMotionBlur(ped, false)
end)

RegisterNetEvent("anim:effectDrunk")
AddEventHandler("anim:effectDrunk", function()
    local ped = GetPlayerPed(-1)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_DRUG_DEALER", 0, 1)
    RequestAnimSet("move_m@drunk@verydrunk")
    while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
        Citizen.Wait(0)
    end
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearPedTasksImmediately(ped)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(ped, true)
    SetPedMovementClipset(ped, "move_m@drunk@verydrunk", true)
    SetPedIsDrunk(ped, true)
end)

-- Sprint   21
-- Jump 22
-- MoveLeftRight    30
-- MoveUpDown   31
-- MoveUpOnly   32
-- MoveDownOnly 33
-- MoveLeftOnly 34
-- MoveRightOnly    35

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if animPlay then
            if IsControlJustPressed(1, 22) or IsControlJustPressed(1, 30) or IsControlJustPressed(1, 31) then -- INPUT_JUMP
                stopEmote()
            end
        end
    end
end)