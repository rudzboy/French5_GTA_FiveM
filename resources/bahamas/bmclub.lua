local strippersBM = {
    { type = 5, hash = 0x2970a494, x = -1383.37, y = -612.19, z = 31.75, a = 114.75 }, --BM
    { type = 5, hash = 0x2970a494, x = -1379.97, y = -617.55, z = 31.75, a = 107.08 }, --BM
}
local bartenders = {
    { type = 8, hash = 0x780c01bd, x = -1390.908, y = -600.691, z = 30.319, a = 38.2 },
    { type = 8, hash = 0x780c01bd, x = -1392.058, y = -603.685, z = 30.319, a = 125.21 },
    { type = 8, hash = 0x780c01bd, x = -1391.028, y = -606.129, z = 30.320, a = 125.217 },
}
-------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    -- Load the ped modal (0x18ce57d0)
    RequestModel("s_f_y_bartender_01")
    while not HasModelLoaded("s_f_y_bartender_01") do
        Wait(1)
    end

    -- Load the ped modal (mp_f_stripperlite)
    RequestModel(GetHashKey("mp_f_stripperlite"))
    while not HasModelLoaded(GetHashKey("mp_f_stripperlite")) do
        Wait(1)
    end

    -- Load the animation (testing)
    RequestAnimDict("mini@strip_club@idles@stripper")
    while not HasAnimDictLoaded("mini@strip_club@idles@stripper") do
        Wait(1)
    end


    ----------------------------------------------------------------------------------
    for _, item in pairs(bartenders) do
        bartenders = CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
        SetPedCombatAttributes(bartenders, 46, false)
        SetPedFleeAttributes(bartenders, 0, 0)
        SetPedArmour(bartenders, 500)
        SetPedMaxHealth(bartenders, 500)
        SetPedCanRagdoll(bartenders, true)
        SetPedDiesWhenInjured(bartenders, true)
        SetBlockingOfNonTemporaryEvents(bartenders, false)
    end


    -- Spawn the strippers to the coordinates
    for _, item in pairs(strippersBM) do
        stripperBM = CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
        --    GiveWeaponToPed(stripper, 0x99B507EA, 2800, false, false)
        SetPedCombatAttributes(stripperBM, 46, false)
        SetPedFleeAttributes(stripperBM, 0, 0)
        SetPedArmour(stripperBM, 200)
        SetPedMaxHealth(stripperBM, 200)
        SetPedDiesWhenInjured(ped, false)
        --    SetPedRelationshipGroupHash(stripper, GetHashKey("army"))
        TaskPlayAnim(stripperBM, "mini@strip_club@idles@stripper", "stripper_idle_03", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    end
end)


local playerCoords
local playerPed
showStartText = false

Citizen.CreateThread(function()
    while true do
        Wait(0)
        playerPed = GetPlayerPed(-1)
        playerCoords = GetEntityCoords(playerPed, 0)

        if (GetDistanceBetweenCoords(playerCoords, 128.900, -1283.21, 29.273) < 2) then
            if (showStartText == false) then
                StartText()
            end

            -- Start mission
            if (IsControlPressed(1, 38)) then
                TriggerServerEvent("es_freeroam:pay", tonumber(50))
                Toxicated()
                Citizen.Wait(120000)
                reality()
            end
        else
            showStartText = false
        end --if GetDistanceBetweenCoords ...
    end
end)


function Toxicated()
    RequestAnimSet("move_m@drunk@verydrunk")
    while not HasAnimSetLoaded("move_m@drunk@verydrunk") do
        Citizen.Wait(0)
    end

    TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_DRUG_DEALER", 0, 1)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(GetPlayerPed(-1), true)
    SetPedMovementClipset(GetPlayerPed(-1), "move_m@drunk@verydrunk", true)
    SetPedIsDrunk(GetPlayerPed(-1), true)
    DoScreenFadeIn(1000)
end

function reality()
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
    DoScreenFadeIn(1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(GetPlayerPed(-1), 0)
    SetPedIsDrunk(GetPlayerPed(-1), false)
    SetPedMotionBlur(GetPlayerPed(-1), false)
    -- Stop the toxication
    Citizen.Trace("Going back to reality\n")
end
