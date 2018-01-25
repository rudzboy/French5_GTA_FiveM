local Keys = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}

local x = 20.0 -- Portée par défaut à la connexion
local y = 2.0 -- Portée +/-

AddEventHandler('onClientMapStart', function()
    NetworkSetTalkerProximity(x)
end)

-- Réglages par une touche : Chuchoter -> parler -> crier
local portevoix = 10.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, Keys["F6"]) then
            if portevoix <= 2.0 then
                portevoix = 10.0
                --			NetworkSetTalkerProximity(portevoix)
                Texte("Vous parlez à haute voix (~g~" .. portevoix .. "~s~m)", 5000)
            elseif portevoix == 10.0 then
                portevoix = 26.0
                --			NetworkSetTalkerProximity(portevoix)
                Texte("Vous criez (~g~" .. portevoix .. "~s~m)", 5000)
            elseif portevoix >= 26.0 then
                portevoix = 2.0
                --			NetworkSetTalkerProximity(portevoix)
                Texte("Vous chuchotez (~g~" .. portevoix .. "~s~m)", 5000)
            end
            NetworkSetTalkerProximity(portevoix)
        end
        if IsControlPressed(1, Keys["F6"]) then
            local posPlayer = GetEntityCoords(GetPlayerPed(-1))
            DrawMarker(1, posPlayer.x, posPlayer.y, posPlayer.z - 1, 0, 0, 0, 0, 0, 0, portevoix * 2, portevoix * 2, 0.8001, 0, 75, 255, 165, 0, 0, 0, 0)
        end
    end
end)

function Texte(_texte, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(_texte)
    DrawSubtitleTimed(showtime, 1)
end