local holdingup = false
local store = ""
local secondsRemaining = 0

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if (outline) then
        SetTextOutline()
    end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width / 2 + 0.1, y - height / 2 + 0.005)
end

local stores = {
    ["paleto_twentyfourseven"] = {
        position = { ['x'] = 1730.35949707031, ['y'] = 6416.7001953125, ['z'] = 35.0372161865234 },
        reward = 8000,
        nameofstore = "24/7 (Paleto Bay)",
        lastrobbed = 0,
        robbingseconds = 420
    },
    ["sandyshores_twentyfoursever"] = {
        position = { ['x'] = 1958.2, ['y'] = 3744.04, ['z'] = 32.343738555908 },
        reward = 8000,
        nameofstore = "24/7 (Sandy Shores)",
        lastrobbed = 0,
        robbingseconds = 360
    },
    ["bar_one"] = {
        position = { ['x'] = 1986.1240234375, ['y'] = 3053.8747558594, ['z'] = 47.215171813965 },
        reward = 8000,
        nameofstore = "Yellow Jack. (Sandy Shores)",
        lastrobbed = 0,
        robbingseconds = 360
    },
    ["littleseoul_twentyfourseven"] = {
        position = { ['x'] = -709.17022705078, ['y'] = -904.21722412109, ['z'] = 19.215591430664 },
        reward = 8000,
        nameofstore = "24/7 (Little Seoul)",
        lastrobbed = 0,
        robbingseconds = 240
    }
}

RegisterNetEvent('es_holdup:currentlyrobbing')
AddEventHandler('es_holdup:currentlyrobbing', function(robb, seconds)
    holdingup = true
    store = robb
    secondsRemaining = seconds
end)

RegisterNetEvent('es_holdup:isrobbingpossible')
AddEventHandler('es_holdup:isrobbingpossible', function(location, cops)
    local neededNumberOfCops = 2
    if cops < neededNumberOfCops then
        TriggerEvent('showNotify', "Braquage ~r~non autorisé~w~. Manque d\'unités ~b~policières~w~ (min: ~y~" .. neededNumberOfCops .. "~w~).")
    else
        TriggerServerEvent('es_holdup:rob', location)
    end
end)

RegisterNetEvent('es_holdup:toofarlocal')
AddEventHandler('es_holdup:toofarlocal', function(robb)
    holdingup = false
    TriggerEvent('showNotify', "Le braquage a été annulé. Aucun butin.")
    robbingName = ""
    secondsRemaining = 0
    incircle = false
end)


RegisterNetEvent('es_holdup:robberycomplete')
AddEventHandler('es_holdup:robberycomplete', function(robb)
    holdingup = false
    TriggerEvent('showNotify', "~g~Braquage réussi !~w~ Votre butin est de ~g~$" .. stores[store].reward .. "~w~.")
    store = ""
    secondsRemaining = 0
    incircle = false
end)

Citizen.CreateThread(function()
    while true do
        if holdingup then
            Citizen.Wait(1000)
            if (secondsRemaining > 0) then
                secondsRemaining = secondsRemaining - 1
            end
        end

        Citizen.Wait(0)
    end
end)

--[[
Citizen.CreateThread(function()
	for k,v in pairs(stores)do
		local ve = v.position
		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 52)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Robbable Store")
		EndTextCommandSetBlipName(blip)
	end
end)
]]--


incircle = false

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)

        for k, v in pairs(stores) do
            local pos2 = v.position

            if (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0) then
                if not holdingup then
                    DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0, 255, 0, 0, 0, 0)

                    if (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0) then
                        if (incircle == false) then
                            DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour ~r~braquer~w~ la caisse du ~y~" .. v.nameofstore .. "~w~ !")
                        end
                        incircle = true
                        if (IsControlJustReleased(1, 51)) then
                            TriggerServerEvent('police:isShopRobbable', k)
                        end
                    elseif (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0) then
                        incircle = false
                    end
                end
            end
        end

        if holdingup then

            drawTxt(0.66, 1.44, 1.0, 1.0, 0.4, "Braquage en cours : ~r~" .. secondsRemaining .. "~w~ secondes restantes.", 255, 255, 255, 255)

            local pos2 = stores[store].position

            if (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 7.5) then
                TriggerServerEvent('es_holdup:toofar', store)
            end
        end

        Citizen.Wait(0)
    end
end)
