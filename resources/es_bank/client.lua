local robbing = false
local bank = ""
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

-- 8 Banks :
--      * Pacific Standard [pacificstd] Vinewood Boulevard 
--      * Flecca [fleeca] Vespucci Boulevard
--      * Fleeca [fleeca2] Hawick Avenue & Meteor Street
--      * Fleeca [fleeca3] Hawick Avenue
--      * Fleeca [fleeca4] Boulevard Del Perro
--      * Fleeca [fleeca5] Great Ocean Highway
--      * Fleeca [fleeca6] Route 68
--      * Blaine County Savings [blainecounty] Paleto Boulevard

local banks = {
    ["pacificstd"] = {
        position = { ['x'] = 254.251, ['y'] = 225.649, ['z'] = 101.775 },
        reward = 80000,
        nameofbank = "Pacific Standard, Vinewood Boulevard",
        lastrobbed = 0,
        robbingseconds = 480
    },
    ["fleeca"] = {
        position = { ['x'] = 147.049, ['y'] = -1044.944, ['z'] = 29.368 },
        reward = 20000,
        nameofbank = "Fleeca, Vespucci Boulevard",
        lastrobbed = 0,
        robbingseconds = 300
    },
    ["fleeca2"] = {
        position = { ['x'] = 311.232, ['y'] = -283.249, ['z'] = 54.074 },
        reward = 20000,
        nameofbank = "Fleeca, Hawick Avenue & Meteor Street",
        lastrobbed = 0,
        robbingseconds = 300
    },
    ["fleeca3"] = {
        position = { ['x'] = -353.814, ['y'] = -54.051, ['z'] = 49.046 },
        reward = 20000,
        nameofbank = "Fleeca, Hawick Avenue",
        lastrobbed = 0,
        robbingseconds = 300
    },
    ["fleeca4"] = {
        position = { ['x'] = -1211.607, ['y'] = -335.744, ['z'] = 37.689 },
        reward = 20000,
        nameofbank = "Fleeca, Boulevard Del Perro",
        lastrobbed = 0,
        robbingseconds = 300
    },
    ["fleeca5"] = {
        position = { ['x'] = -2957.667, ['y'] = 481.457, ['z'] = 15.697 },
        reward = 22000,
        nameofbank = "Fleeca, Great Ocean Highway",
        lastrobbed = 0,
        robbingseconds = 360
    },
    ["fleeca6"] = {
        position = { ['x'] = 1176.471, ['y'] = 2711.818, ['z'] = 37.997 },
        reward = 22000,
        nameofbank = "Fleeca, Route 68",
        lastrobbed = 0,
        robbingseconds = 360
    },
    ["blainecounty"] = {
        position = { ['x'] = -107.065, ['y'] = 6474.801, ['z'] = 31.626 },
        reward = 24000,
        nameofbank = "Blaine County Savings, Paleto Boulevard",
        lastrobbed = 0,
        robbingseconds = 480
    }
}

RegisterNetEvent('es_bank:currentlyrobbing')
AddEventHandler('es_bank:currentlyrobbing', function(robb, seconds)
    robbing = true
    bank = robb
    secondsRemaining = seconds
end)

RegisterNetEvent('es_bank:isrobbingpossible')
AddEventHandler('es_bank:isrobbingpossible', function(location, cops)
    local neededNumberOfCops = 3
    if cops < neededNumberOfCops then
        TriggerEvent('showNotify', "Braquage ~r~non autorisé~w~. Manque d\'unités ~b~policières~w~ (min: ~y~" .. neededNumberOfCops .. "~w~).")
    else
        TriggerServerEvent('es_bank:rob', location)
    end
end)

RegisterNetEvent('es_bank:toofarlocal')
AddEventHandler('es_bank:toofarlocal', function(robb)
    robbing = false
    TriggerEvent('showNotify', "Le braquage a été annulé. Aucun butin.")
    robbingName = ""
    secondsRemaining = 0
    incircle = false
end)

RegisterNetEvent('es_bank:robberycomplete')
AddEventHandler('es_bank:robberycomplete', function(robb)
    robbing = false
    TriggerEvent('showNotify', "~g~Braquage réussi !~w~ Votre butin est de ~g~$" .. banks[bank].reward .. "~w~.")
    bank = ""
    secondsRemaining = 0
    incircle = false
end)

Citizen.CreateThread(function()
    while true do
        if robbing then
            Citizen.Wait(1000)
            if (secondsRemaining > 0) then
                secondsRemaining = secondsRemaining - 1
            end
        end

        Citizen.Wait(0)
    end
end)

--Citizen.CreateThread(function()
--	for k,v in pairs(banks)do
--		local ve = v.position

--		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
--		SetBlipSprite(blip, 500)
--		SetBlipScale(blip, 0.8)
--		SetBlipAsShortRange(blip, true)
--		BeginTextCommandSetBlipName("STRING")
--		AddTextComponentString("Robbable Bank")
--		EndTextCommandSetBlipName(blip)
--	end
--end)
--incircle = false

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)

        for k, v in pairs(banks) do
            local pos2 = v.position

            if (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0) then
                if not robbing then
                    DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0, 255, 0, 0, 0, 0)

                    if (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0) then
                        if (incircle == false) then
                            DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour ~r~braquer~w~ la banque de ~y~" .. v.nameofbank .. "~w~ !")
                        end
                        incircle = true
                        if (IsControlJustReleased(1, 51)) then
                            TriggerServerEvent('police:isBankRobbable', k)
                        end
                    elseif (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0) then
                        incircle = false
                    end
                end
            end
        end

        if robbing then

            drawTxt(0.66, 1.44, 1.0, 1.0, 0.4, "Braquage en cours : ~r~" .. secondsRemaining .. "~w~ secondes restantes.", 255, 255, 255, 255)

            local pos2 = banks[bank].position

            if (Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 7.5) then
                TriggerServerEvent('es_bank:toofar', bank)
            end
        end

        Citizen.Wait(0)
    end
end)