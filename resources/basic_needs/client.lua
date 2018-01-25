-- Configuration  --
-- set INTERVAL (in milliseconds) - Info: Bar decrements from 100 to 0
-- example : will take 100 minutes for each bar to get empty
local interval = 60000
-- End Configuration  --
local pauseMenu = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(interval)
        if not IsEntityDead(GetPlayerPed(-1)) then
            TriggerServerEvent('f5c:updateBasicNeedsValues', -1, -1)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsPauseMenuActive() and not pauseMenu then
            pauseMenu = true
            TriggerEvent('f5c:displayBasicNeedsUI', false)
        elseif not IsPauseMenuActive() and pauseMenu then
            pauseMenu = false
            TriggerEvent('f5c:displayBasicNeedsUI', true)
        end
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('f5c:updateBasicNeedsValues', 0, 0)
    TriggerEvent('f5c:displayBasicNeedsUI', true)
end)

RegisterNetEvent("f5c:playerEat")
AddEventHandler("f5c:playerEat", function(value)
    if (value < 100) then
        TriggerServerEvent("f5c:updateBasicNeedsValues", value, 0)
    end
end)

RegisterNetEvent("f5c:playerDrink")
AddEventHandler("f5c:playerDrink", function(value)
    if (value < 100) then
        TriggerServerEvent("f5c:updateBasicNeedsValues", 0, value)
    end
end)

RegisterNetEvent('f5c:updateBasicNeedsUI')
AddEventHandler('f5c:updateBasicNeedsUI', function(hunger, thirst)
    SendNUIMessage({
        type = "basicneeds",
        hunger = hunger,
        thirst = thirst
    })
end)

RegisterNetEvent('f5c:displayBasicNeedsUI')
AddEventHandler('f5c:displayBasicNeedsUI', function(display)
    SendNUIMessage({
        type = "basicneeds",
        display = display
    })
end)
