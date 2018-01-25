local candraw = false
local iteriors = {}
local distance = 50.5999 -- distance to draw
local timer = 0
local current_int = 0

AddEventHandler('onClientMapStart', function()
    TriggerServerEvent("getInteriors")
end)

RegisterNetEvent('sendInteriors')
AddEventHandler('sendInteriors', function(idata)
    iteriors = idata
    candraw = not candraw
end)

function DrawAdvancedText(x, y, w, h, sc, text, r, g, b, a, font, jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
    N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - 0.1 + w, y - 0.02 + h)
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if candraw then
            if timer > 0 and current_int > 0 then DrawAdvancedText(0.707, 0.77, 0.005, 0.0028, 1.89, "~b~" .. iteriors[current_int][4], 255, 255, 255, 255, 1, 1) end
            for i = 1, #iteriors do
                if not IsEntityDead(PlayerPedId()) then
                    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), iteriors[i][2][1], iteriors[i][2][2], iteriors[i][2][3], true) < distance then
                        DrawMarker(1, iteriors[i][2][1], iteriors[i][2][2], iteriors[i][2][3] - 1.0001, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 255, 255, 255, 70, 0, 0, 2, 0, 0, 0, 0)
                        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), iteriors[i][2][1], iteriors[i][2][2], iteriors[i][2][3], true) < 1.599 then
                            DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~y~accéder~w~ à la ~b~zone~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255) -- ~g~E~s~
                            if IsControlJustPressed(1, 51) then
                                if timer == 0 then
                                    DoScreenFadeOut(1000)
                                    while IsScreenFadingOut() do Citizen.Wait(0) end
                                    --NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
                                    Wait(1000)
                                    SetEntityCoords(GetPlayerPed(-1), iteriors[i][3][1], iteriors[i][3][2], iteriors[i][3][3])
                                    SetEntityHeading(GetPlayerPed(-1), iteriors[i][3][4])
                                    --NetworkFadeInEntity(GetPlayerPed(-1), 0)
                                    Wait(1000)
                                    current_int = i
                                    timer = 5
                                    SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
                                    DoScreenFadeIn(1000)
                                    while IsScreenFadingIn() do Citizen.Wait(0) end
                                end
                            end
                        end
                    end
                    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), iteriors[i][3][1], iteriors[i][3][2], iteriors[i][3][3], true) < distance then
                        DrawMarker(1, iteriors[i][3][1], iteriors[i][3][2], iteriors[i][3][3] - 1.0001, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, 255, 255, 255, 70, 0, 0, 2, 0, 0, 0, 0)
                        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), iteriors[i][3][1], iteriors[i][3][2], iteriors[i][3][3], true) < 1.599 then
                            DisplayHelpText('Appuyez sur ~INPUT_CONTEXT~ pour ~y~accéder~w~ à la ~b~zone~w~.', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255) -- ~g~E~s~
                            if IsControlJustPressed(1, 51) then
                                if timer == 0 then
                                    DoScreenFadeOut(1000)
                                    while IsScreenFadingOut() do Citizen.Wait(0) end
                                    NetworkFadeOutEntity(GetPlayerPed(-1), true, false)
                                    Wait(1000)
                                    SetEntityCoords(GetPlayerPed(-1), iteriors[i][2][1], iteriors[i][2][2], iteriors[i][2][3])
                                    SetEntityHeading(GetPlayerPed(-1), iteriors[i][2][4])
                                    NetworkFadeInEntity(GetPlayerPed(-1), 0)
                                    Wait(1000)
                                    current_int = i
                                    timer = 5
                                    SimulatePlayerInputGait(PlayerId(), 1.0, 100, 1.0, 1, 0)
                                    DoScreenFadeIn(1000)
                                    while IsScreenFadingIn() do Citizen.Wait(0) end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if timer > 0 then
            timer = timer - 1
            if timer == 0 then current_int = 0 end
        end
    end
end)