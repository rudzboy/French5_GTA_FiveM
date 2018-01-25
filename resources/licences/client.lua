local hasLicence = 0

local permis = {
    opened = false,
    title = "Auto-École",
    lastmenu = nil,
    currentpos = nil,
    selectedbutton = 0,
    marker = { r = 155, g = 155, b = 255, a = 200, type = 1 }
}
local permis_locations = {
    {
        entering = { 249.7434, -1512.085, 27.34321 },
        inside = { 38.34729, -969.293, 29.09835 },
        outside = { 249.7434, -1512.085, 27.34321 }
    }
}

local currentCar = false

RegisterNetEvent("licences:getPlayerLicence")
AddEventHandler("licences:getPlayerLicence", function(result)
    hasLicence = result
end)

local spot = { x = 1711.0, y = 4803.954, z = 40.78 }
local vehicle = { x = 64.55118, y = 116.613, z = 78.69622 }

local permis_blips = {}
local inrangeofpermis = false
local currentlocation = nil
local onPermis = false
local blippermis = false

local function LocalPed()
    return GetPlayerPed(-1)
end

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function IsPlayerInRangeOfpermis()
    return inrangeofpermis
end

function ShowpermisBlips(bool)
    if bool and #permis_blips == 0 then
        for station, pos in pairs(permis_locations) do
            local loc = pos
            pos = pos.entering
            local blip = AddBlipForCoord(pos[1], pos[2], pos[3])
            SetBlipSprite(blip, 430)
            SetBlipColour(blip, 5)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Auto-École')
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip, true)
            SetBlipAsMissionCreatorBlip(blip, true)
            table.insert(permis_blips, { blip = blip, pos = loc })
        end

        Citizen.CreateThread(function()
            while #permis_blips > 0 do
                Citizen.Wait(0)
                local inrange = false
                for i, b in ipairs(permis_blips) do
                    if permis.opened == false and GetDistanceBetweenCoords(b.pos.entering[1], b.pos.entering[2], b.pos.entering[3], GetEntityCoords(LocalPed()), true) < 50 then
                        DrawMarker(1, b.pos.entering[1], b.pos.entering[2], b.pos.entering[3], 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 1.5001, 0, 155, 255, 200, 0, 0, 0, 0)
                        currentlocation = b
                        if GetDistanceBetweenCoords(b.pos.entering[1], b.pos.entering[2], b.pos.entering[3], GetEntityCoords(LocalPed()), true) < 4 and IsPedInAnyVehicle(LocalPed(), true) == false then
                            ShowInfo("Appuyez sur ~INPUT_CONTEXT~ pour passer votre ~y~permis de conduire~w~.", 0)
                            inrange = true
                        end
                    end
                end
                inrangeofpermis = inrange
            end
        end)

    elseif bool == false and #permis_blips > 0 then
        for i, b in ipairs(permis_blips) do
            if DoesBlipExist(b.blip) then
                SetBlipAsMissionCreatorBlip(b.blip, false)
                Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
            end
        end
        permis_blips = {}
    end
end

function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function DrawMissionText2(m_text, showtime)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(m_text)
    DrawSubtitleTimed(showtime, 1)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 38) and inrangeofpermis and not onPermis then
            if hasLicence == 0 then
                blippermis = AddBlipForCoord(spot.x, spot.y, spot.z)
                N_0x80ead8e2e1d5d52e(blippermis)
                SetBlipRoute(blippermis, 1)
                onPermis = true
                SpawnPermisCar()
            else
                TriggerEvent('showNotify', "Vous avez ~g~déjà~w~ votre ~y~permis de conduire~w~.", 0)
            end
        end
    end
end)

function SpawnPermisCar()
    Citizen.Wait(0)
    local player = PlayerId()
    local vehicleHash = GetHashKey('blista')

    RequestModel(vehicleHash)
    while not HasModelLoaded(vehicleHash) do
        Wait(1)
    end

    colors = table.pack(GetVehicleColours(veh))
    extra_colors = table.pack(GetVehicleExtraColours(veh))
    plate = math.random(100, 900)
    local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0, 5.0, 0)
    currentCar = CreateVehicle(vehicleHash, coords, vehicle.x, vehicle.y, vehicle.z, true, false)
    SetVehicleColours(currentCar, colors[1], colors[2])
    SetVehicleExtraColours(currentCar, extra_colors[1], extra_colors[2])
    SetVehicleOnGroundProperly(currentCar)
    SetPedIntoVehicle(GetPlayerPed(-1), currentCar, -1)
    SetModelAsNoLongerNeeded(vehicleHash)
    Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(currentCar))
    TriggerEvent('showNotify', "~y~Conduisez jusqu\'au point indiqué~w~, en respectant le ~b~code la route~w~.")
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if onPermis and currentCar ~= false then
            local distanceToEndPoint = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), spot.x, spot.y, spot.z, true)

            if not IsPedInVehicle(GetPlayerPed(-1), currentCar, false) then
                TriggerEvent('showNotify', "~r~Raté !~w~ Vous avez ~r~quitté~w~ le véhicule !")
                TriggerEvent("licences:discardTestVehicle")
                onPermis = false
            elseif IsVehicleDamaged(currentCar) then
                TriggerEvent('showNotify', "~r~Raté !~w~ Le véhicule a été ~r~endommagé~w~ !")
                TriggerEvent("licences:discardTestVehicle")
                onPermis = false
            end

            if distanceToEndPoint > 5.001 and distanceToEndPoint < 50.001 then
                DrawMarker(1, spot.x, spot.y, spot.z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 1.5001, 0, 155, 255, 200, 0, 0, 0, 0)
            elseif distanceToEndPoint < 5.001 then
                TriggerServerEvent('licences:updateDriverLicense', 1)
                TriggerEvent('showNotify', "Bravo ! Vous avez ~g~obtenu~w~ votre ~y~permis de conduire~w~.")
                TriggerEvent("licences:discardTestVehicle")
                onPermis = false
                hasLicence = 1
            end
        end
    end
end)

RegisterNetEvent("licences:setDriverLicense")
AddEventHandler("licences:setDriverLicense", function(value)
    TriggerServerEvent('licences:updateDriverLicense', value)
    hasLicence = value
end)

RegisterNetEvent("licences:discardTestVehicle")
AddEventHandler("licences:discardTestVehicle", function()
    if currentCar ~= false then
        TaskLeaveVehicle(GetPlayerPed(-1), currentCar, 0)

        if blippermis ~= false and DoesBlipExist(blippermis) then
            Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(blippermis))
            blippermis = nil
        end

        local lockStatus = GetVehicleDoorLockStatus(currentCar)
        SetVehicleDoorsLocked(currentCar, 2)
        SetVehicleDoorsLockedForPlayer(currentCar, PlayerId(), false)

        Wait(3000)

        SetEntityAsMissionEntity(currentCar, true, true)
        Citizen.InvokeNative(0xAE3CBE5BF394C9C9, Citizen.PointerValueIntInitialized(currentCar))

        currentCar = false
    end
end)

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
    TriggerServerEvent("licences:getPlayerLicence")
    if firstspawn == 0 then
        ShowpermisBlips(true)
        firstspawn = 1
    end
end)