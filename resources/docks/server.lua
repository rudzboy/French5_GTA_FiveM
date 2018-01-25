--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent('ply_docks:CheckForSpawnBoat')
RegisterServerEvent('ply_docks:CheckForBoat')
RegisterServerEvent('ply_docks:SetBoatOut')
RegisterServerEvent('ply_docks:CheckDockForBoat')
RegisterServerEvent('ply_docks:CheckForSelBoat')
RegisterServerEvent('ply_docks:Lang')



--[[Function]]--

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function boatPlate(plate)
    local plate = plate
    local user = getPlayerID(source)
    return MySQL.Sync.fetchScalar("SELECT boat_plate FROM user_boat WHERE identifier=@identifier AND boat_plate=@plate", { ['@identifier'] = user, ['@plate'] = plate })
end

function boatPrice(plate)
    local plate = plate
    local user = getPlayerID(source)
    return MySQL.Sync.fetchScalar("SELECT boat_price FROM user_boat WHERE identifier=@identifier AND boat_plate=@plate", { ['@identifier'] = user, ['@plate'] = plate })
end



--[[Local/Global]]--

boats = {}



--[[Events]]--


--Langage
AddEventHandler('ply_docks:Lang', function(lang)
    local lang = lang
    if lang == "FR" then
        state_in = "Rentré"
        state_out = "Sortit"
    elseif lang == "EN" then
        state_in = "In"
        state_out = "Out"
    end
end)


--Dock

AddEventHandler('ply_docks:CheckForSpawnBoat', function(boat_id)
    local boat_id = boat_id
    local user = getPlayerID(source)
    MySQL.Async.fetchAll("SELECT * FROM user_boat WHERE identifier = @identifier AND id = @id", { ['@identifier'] = user, ['@id'] = boat_id }, function(data)
        TriggerClientEvent('ply_docks:SpawnBoat', source, data[1].boat_model, data[1].boat_plate, data[1].boat_state, data[1].boat_colorprimary, data[1].boat_colorsecondary, data[1].boat_pearlescentcolor, data[1].boat_wheelcolor)
    end)
end)

AddEventHandler('ply_docks:CheckForBoat', function(plate)
    local plate = plate
    local state = state_out
    local user = getPlayerID(source)
    local boat_plate = tostring(boatPlate(plate))
    if boat_plate == plate then
        local state = state_in
        MySQL.Sync.execute("UPDATE user_boat SET boat_state=@state WHERE identifier=@identifier AND boat_plate=@plate", { ['@identifier'] = user, ['@state'] = state, ['@plate'] = plate })
        TriggerClientEvent('ply_docks:StoreBoatTrue', source)
    else
        TriggerClientEvent('ply_docks:StoreBoatFalse', source)
    end
end)

AddEventHandler('ply_docks:SetBoatOut', function(boat, plate)
    local user = getPlayerID(source)
    local boat = boat
    local state = state_out
    local plate = plate
    MySQL.Sync.execute("UPDATE user_boat SET boat_state=@state WHERE identifier=@identifier AND boat_plate=@plate AND boat_model=@boat", { ['@identifier'] = user, ['@boat'] = boat, ['@state'] = state, ['@plate'] = plate })
end)

AddEventHandler('ply_docks:CheckForSelBoat', function(plate)
    local plate = plate
    local state = state_out
    local user = getPlayerID(source)
    local boat_plate = tostring(boatPlate(plate))
    local boat_price = boatPrice(plate)
    if boat_plate == plate then
        local boat_price = boat_price / 2
        TriggerEvent('es:getPlayerFromId', source, function(user)
            user:addMoney((boat_price))
        end)
        MySQL.Sync.execute("DELETE from user_boat WHERE identifier=@identifier AND boat_plate=@plate", { ['@identifier'] = user, ['@plate'] = plate })
        TriggerClientEvent('ply_docks:SelBoatTrue', source)
    else
        TriggerClientEvent('ply_docks:SelBoatFalse', source)
    end
end)


-- Base

AddEventHandler('ply_docks:CheckDockForBoat', function()
    boats = {}
    local user = getPlayerID(source)
    MySQL.Async.fetchAll("SELECT * FROM user_boat WHERE identifier=@identifier", { ['@identifier'] = user }, function(data)
        for _, v in ipairs(data) do
            t = { ["id"] = v.id, ["boat_model"] = v.boat_model, ["boat_name"] = v.boat_name, ["boat_state"] = v.boat_state }
            table.insert(boats, tonumber(v.id), t)
        end
        TriggerClientEvent('ply_docks:getBoat', source, boats)
    end)
end)
--
AddEventHandler('playerConnecting', function()
    local old_state = state_out
    local state = state_in
    MySQL.Sync.execute("UPDATE user_boat SET boat_state=@state WHERE boat_state=@old_state", { ['@old_state'] = old_state, ['@state'] = state })
end)
