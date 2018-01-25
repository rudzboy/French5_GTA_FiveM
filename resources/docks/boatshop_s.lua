--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent('ply_docks:CheckMoneyForBoat')
RegisterServerEvent('ply_docks:BuyForBoat')
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


--Shop

AddEventHandler('ply_docks:CheckMoneyForBoat', function(name, boat, price)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local price = price
        if (tonumber(user.money) >= tonumber(price)) then
            local player = user.identifier
            local boat = boat
            local name = name
            user:removeMoney((price))
            TriggerClientEvent('ply_docks:FinishMoneyCheckForBoat', source, name, boat, price)
            TriggerClientEvent('ply_docks:BuyTrue', source)
        else
            TriggerClientEvent('ply_docks:BuyFalseTrue', source)
        end
    end)
end)

AddEventHandler('ply_docks:BuyForBoat', function(name, boat, price, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
    local user = getPlayerID(source)
    local name = name
    local price = price
    local boat = boat
    local plate = plate
    local state = state_out
    local primarycolor = primarycolor
    local secondarycolor = secondarycolor
    local pearlescentcolor = pearlescentcolor
    local wheelcolor = wheelcolor

    MySQL.Async.execute("INSERT INTO user_boat (identifier,boat_name,boat_model,boat_price,boat_plate,boat_state,boat_colorprimary,boat_colorsecondary,boat_pearlescentcolor,boat_wheelcolor) VALUES (@username,@name,@boat,@price,@plate,@state,@primarycolor,@secondarycolor,@pearlescentcolor,@wheelcolor)",
        { ['@username'] = user, ['@name'] = name, ['@boat'] = boat, ['@price'] = price, ['@plate'] = plate, ['@state'] = state, ['@primarycolor'] = primarycolor, ['@secondarycolor'] = secondarycolor, ['@pearlescentcolor'] = pearlescentcolor, ['@wheelcolor'] = wheelcolor }, function(data)
        end)
end)
