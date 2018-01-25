--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent('ply_garages:CheckForSpawnVeh')
RegisterServerEvent('ply_garages:CheckForPoundVeh')
RegisterServerEvent('ply_garages:CheckForVeh')
RegisterServerEvent('ply_garages:SetVehOut')
RegisterServerEvent('ply_garages:PutVehInGarages')
RegisterServerEvent('ply_garages:CheckGarageForVeh')
RegisterServerEvent('ply_garages:CheckForSelVeh')
RegisterServerEvent('ply_garages:Lang')
RegisterServerEvent('ply_garages:UpdateVeh')

--[[Function]]--

function getPlayerID(source)
    return getIdentifiant(GetPlayerIdentifiers(source))
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function vehiclePlate(plate)
    return MySQL.Sync.fetchScalar("SELECT vehicle_plate FROM user_vehicle WHERE identifier=@identifier AND vehicle_plate=@plate", { ['@identifier'] = getPlayerID(source), ['@plate'] = plate })
end

function vehiclePrice(plate)
    return MySQL.Sync.fetchScalar("SELECT vehicle_price FROM user_vehicle WHERE identifier=@identifier AND vehicle_plate=@plate", { ['@identifier'] = getPlayerID(source), ['@plate'] = plate })
end



--[[Local/Global]]--

vehicles = {}



--[[Events]]--


--Langage
AddEventHandler('ply_garages:Lang', function(lang)
    if lang == "FR" then
        state_in = "Rentré"
        state_out = "Sortit"
        state_pound = "Fourriere"
    elseif lang == "EN" then
        state_in = "In"
        state_out = "Out"
        state_pound = "Pound"
    end
end)

--Garage
AddEventHandler('ply_garages:CheckForSpawnVeh', function(veh_id)
    MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE identifier = @identifier AND id = @id", { ['@identifier'] = getPlayerID(source), ['@id'] = veh_id }, function(data)
        TriggerClientEvent('ply_garages:SpawnVehicle', source, data[1].vehicle_model, data[1].vehicle_plate, data[1].vehicle_state, data[1].vehicle_colorprimary, data[1].vehicle_colorsecondary, data[1].vehicle_pearlescentcolor, data[1].vehicle_wheelcolor, data[1].vehicle_plateindex, data[1].vehicle_neoncolor1, data[1].vehicle_neoncolor2, data[1].vehicle_neoncolor3, data[1].vehicle_windowtint, data[1].vehicle_wheeltype, data[1].vehicle_mods0, data[1].vehicle_mods1, data[1].vehicle_mods2, data[1].vehicle_mods3, data[1].vehicle_mods4, data[1].vehicle_mods5, data[1].vehicle_mods6, data[1].vehicle_mods7, data[1].vehicle_mods8, data[1].vehicle_mods9, data[1].vehicle_mods10, data[1].vehicle_mods11, data[1].vehicle_mods12, data[1].vehicle_mods13, data[1].vehicle_mods14, data[1].vehicle_mods15, data[1].vehicle_mods16, data[1].vehicle_turbo, data[1].vehicle_tiresmoke, data[1].vehicle_xenon, data[1].vehicle_mods23, data[1].vehicle_mods24, data[1].vehicle_neon0, data[1].vehicle_neon1, data[1].vehicle_neon2, data[1].vehicle_neon3, data[1].vehicle_bulletproof, data[1].vehicle_smokecolor1, data[1].vehicle_smokecolor2, data[1].vehicle_smokecolor3, data[1].vehicle_modvariation)
    end)
end)

--Car Pound
AddEventHandler('ply_garages:CheckForPoundVeh', function(veh_id, price)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        if (tonumber(user.money) >= tonumber(price)) then
            user:removeMoney(price)
            MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE identifier = @identifier AND id = @id", { ['@identifier'] = getPlayerID(source), ['@id'] = veh_id }, function(data)
                TriggerClientEvent('ply_garages:SpawnVehicle', source, data[1].vehicle_model, data[1].vehicle_plate, data[1].vehicle_state, data[1].vehicle_colorprimary, data[1].vehicle_colorsecondary, data[1].vehicle_pearlescentcolor, data[1].vehicle_wheelcolor, data[1].vehicle_plateindex, data[1].vehicle_neoncolor1, data[1].vehicle_neoncolor2, data[1].vehicle_neoncolor3, data[1].vehicle_windowtint, data[1].vehicle_wheeltype, data[1].vehicle_mods0, data[1].vehicle_mods1, data[1].vehicle_mods2, data[1].vehicle_mods3, data[1].vehicle_mods4, data[1].vehicle_mods5, data[1].vehicle_mods6, data[1].vehicle_mods7, data[1].vehicle_mods8, data[1].vehicle_mods9, data[1].vehicle_mods10, data[1].vehicle_mods11, data[1].vehicle_mods12, data[1].vehicle_mods13, data[1].vehicle_mods14, data[1].vehicle_mods15, data[1].vehicle_mods16, data[1].vehicle_turbo, data[1].vehicle_tiresmoke, data[1].vehicle_xenon, data[1].vehicle_mods23, data[1].vehicle_mods24, data[1].vehicle_neon0, data[1].vehicle_neon1, data[1].vehicle_neon2, data[1].vehicle_neon3, data[1].vehicle_bulletproof, data[1].vehicle_smokecolor1, data[1].vehicle_smokecolor2, data[1].vehicle_smokecolor3, data[1].vehicle_modvariation)
            end)
        else
            TriggerClientEvent('showNotify', source, "~r~Vous n\'avez pas assez d\'argent")
        end
    end)
end)

AddEventHandler('ply_garages:CheckForVeh', function(plate)
    if vehiclePlate(plate) == plate then
        MySQL.Sync.execute("UPDATE user_vehicle SET vehicle_state=@state WHERE identifier=@identifier AND vehicle_plate=@plate",
            { ['@identifier'] = getPlayerID(source), ['@state'] = state_in, ['@plate'] = tostring(vehiclePlate(plate)) })
        TriggerClientEvent('ply_garages:StoreVehicleTrue', source)
    else
        TriggerClientEvent('ply_garages:StoreVehicleFalse', source)
    end
end)

AddEventHandler('ply_garages:UpdateVeh', function(plate, plateindex, primarycolor, secondarycolor, pearlescentcolor, wheelcolor, neoncolor1, neoncolor2, neoncolor3, windowtint, wheeltype, mods0, mods1, mods2, mods3, mods4, mods5, mods6, mods7, mods8, mods9, mods10, mods11, mods12, mods13, mods14, mods15, mods16, turbo, tiresmoke, xenon, mods23, mods24, neon0, neon1, neon2, neon3, bulletproof, smokecolor1, smokecolor2, smokecolor3, variation)
    if vehiclePlate(plate) == plate then
        MySQL.Sync.execute("UPDATE user_vehicle SET vehicle_plateindex=@plateindex, vehicle_colorprimary=@primarycolor, vehicle_colorsecondary=@secondarycolor, vehicle_pearlescentcolor=@pearlescentcolor, vehicle_wheelcolor=@wheelcolor, vehicle_neoncolor1=@neoncolor1, vehicle_neoncolor2=@neoncolor2, vehicle_neoncolor3=@neoncolor3, vehicle_windowtint=@windowtint, vehicle_wheeltype=@wheeltype, vehicle_mods0=@mods0, vehicle_mods1=@mods1, vehicle_mods2=@mods2, vehicle_mods3=@mods3, vehicle_mods4=@mods4, vehicle_mods5=@mods5, vehicle_mods6=@mods6, vehicle_mods7=@mods7, vehicle_mods8=@mods8, vehicle_mods9=@mods9, vehicle_mods10=@mods10, vehicle_mods11=@mods11, vehicle_mods12=@mods12, vehicle_mods13=@mods13, vehicle_mods14=@mods14, vehicle_mods15=@mods15, vehicle_mods16=@mods16, vehicle_turbo=@turbo, vehicle_tiresmoke=@tiresmoke, vehicle_xenon=@xenon, vehicle_mods23=@mods23, vehicle_mods24=@mods24, vehicle_neon0=@neon0, vehicle_neon1=@neon1, vehicle_neon2=@neon2, vehicle_neon3=@neon3, vehicle_bulletproof=@bulletproof, vehicle_smokecolor1=@smokecolor1, vehicle_smokecolor2=@smokecolor2, vehicle_smokecolor3=@smokecolor3, vehicle_modvariation=@variation WHERE identifier=@identifier AND vehicle_plate=@plate",
            { ['@identifier'] = getPlayerID(source), ['@plateindex'] = plateindex, ['@primarycolor'] = primarycolor, ['@secondarycolor'] = secondarycolor, ['@pearlescentcolor'] = pearlescentcolor, ['@wheelcolor'] = wheelcolor, ['@neoncolor1'] = neoncolor1, ['@neoncolor2'] = neoncolor2, ['@neoncolor3'] = neoncolor3, ['@windowtint'] = windowtint, ['@wheeltype'] = wheeltype, ['@mods0'] = mods0, ['@mods1'] = mods1, ['@mods2'] = mods2, ['@mods3'] = mods3, ['@mods4'] = mods4, ['@mods5'] = mods5, ['@mods6'] = mods6, ['@mods7'] = mods7, ['@mods8'] = mods8, ['@mods9'] = mods9, ['@mods10'] = mods10, ['@mods11'] = mods11, ['@mods12'] = mods12, ['@mods13'] = mods13, ['@mods14'] = mods14, ['@mods15'] = mods15, ['@mods16'] = mods16, ['@turbo'] = turbo, ['@tiresmoke'] = tiresmoke, ['@xenon'] = xenon, ['@mods23'] = mods23, ['@mods24'] = mods24, ['@neon0'] = neon0, ['@neon1'] = neon1, ['@neon2'] = neon2, ['@neon3'] = neon3, ['@bulletproof'] = bulletproof, ['@plate'] = plate, ['@smokecolor1'] = smokecolor1, ['@smokecolor2'] = smokecolor2, ['@smokecolor3'] = smokecolor3, ['@variation'] = variation })
        TriggerClientEvent('ply_garages:UpdateDone', source)
    else
        TriggerClientEvent('ply_garages:StoreVehicleFalse', source)
    end
end)

AddEventHandler('ply_garages:SetVehOut', function(vehicle, plate)
    MySQL.Sync.execute("UPDATE user_vehicle SET vehicle_state=@state WHERE identifier=@identifier AND vehicle_plate=@plate AND vehicle_model=@vehicle",
        { ['@identifier'] = getPlayerID(source), ['@vehicle'] = vehicle, ['@state'] = state_out, ['@plate'] = plate })
end)

AddEventHandler('ply_garages:CheckForSelVeh', function(plate)
    if vehiclePlate(plate) == plate then
        TriggerEvent('es:getPlayerFromId', source, function(user)
            user:addMoney((vehiclePrice(plate) / 2))
        end)
        MySQL.Sync.execute("DELETE from user_vehicle WHERE identifier=@identifier AND vehicle_plate=@plate",
            { ['@identifier'] = getPlayerID(source), ['@plate'] = tostring(vehiclePlate(plate)) })
        TriggerClientEvent('ply_garages:SelVehicleTrue', source)
    else
        TriggerClientEvent('ply_garages:SelVehicleFalse', source)
    end
end)


-- Base

AddEventHandler("ply_garages:CheckGarageForVeh", function()
    vehicles = {}
    MySQL.Async.fetchAll("SELECT * FROM user_vehicle WHERE identifier=@identifier", { ['@identifier'] = getPlayerID(source) }, function(data)
        for _, v in ipairs(data) do
            t = { ["id"] = v.id, ["vehicle_model"] = v.vehicle_model, ["vehicle_name"] = v.vehicle_name, ["vehicle_state"] = v.vehicle_state, ["vehicle_price"] = v.vehicle_price }
            table.insert(vehicles, tonumber(v.id), t)
        end
        TriggerClientEvent("ply_garages:getVehicles", source, vehicles)
    end)
end)

-- Put vehicles out of garage to car pound when player leaves

AddEventHandler('es:playerDropped', function(player)
    if (player.identifier ~= nil) then
        MySQL.Async.execute("UPDATE user_vehicle SET `vehicle_state` = @statePound WHERE `identifier` = @user_identifier AND `vehicle_state` = @stateOut",
            { ['@user_identifier'] = player.identifier, ['@stateOut'] = state_out, ['@statePound'] = state_pound },
            function(data)
            end)
    end
end)

--[[

    -- Reset vehicle_states when server starts --

    function resetOnStart()
        MySQL.Async.execute("UPDATE user_vehicle SET vehicle_state=@state", {['@state'] = "Rentré"}, function(data)
        end)
    end
    resetOnStart()
]]--