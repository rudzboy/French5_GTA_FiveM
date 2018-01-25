require "resources/mysql-async/lib/MySQL"

RegisterServerEvent('CheckMoneyForVeh')
RegisterServerEvent('BuyForVeh')
RegisterServerEvent('vehshop:addFreeVehicle')

AddEventHandler('CheckMoneyForVeh', function(name, vehicle, price)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local price = tonumber(price)
        MySQL.Async.fetchAll("SELECT * FROM `user_vehicle` WHERE identifier = @username",
            { ['@username'] = user.identifier }, function(result)
                if (result) then
                    if #result >= 5 then
                        TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Votre garage est ~y~complet~w~.")
                    else
                        if (tonumber(user.money) >= tonumber(price)) then
                            user:removeMoney(price)
                            TriggerClientEvent('FinishMoneyCheckForVeh', source, name, vehicle, tonumber(price))
                            TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Merci ! ~g~Bonne route~w~.")
                        else
                            TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "~r~Fonds insuffisants !")
                        end
                    end
                else
                    if (tonumber(user.money) >= tonumber(price)) then
                        user:removeMoney(price)
                        TriggerClientEvent('FinishMoneyCheckForVeh', source, name, vehicle, tonumber(price))
                        TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Merci ! ~g~Bonne route~w~.")
                    else
                        TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "~r~Fonds insuffisants !")
                    end
                end
            end)
    end)
end)

AddEventHandler('BuyForVeh', function(name, vehicle, price, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
    TriggerEvent('es:getPlayerFromId', source, function(user)

        local player = user.identifier
        local name = name
        local price = price
        local vehicle = vehicle
        local plate = plate
        local state = "Sortit"
        local primarycolor = primarycolor
        local secondarycolor = secondarycolor
        local pearlescentcolor = pearlescentcolor
        local wheelcolor = wheelcolor
        MySQL.Async.execute("INSERT INTO user_vehicle (`identifier`, `vehicle_name`, `vehicle_model`, `vehicle_price`, `vehicle_plate`, `vehicle_state`, `vehicle_colorprimary`, `vehicle_colorsecondary`, `vehicle_pearlescentcolor`, `vehicle_wheelcolor`) VALUES (@username, @name, @vehicle, @price, @plate, @state, @primarycolor, @secondarycolor, @pearlescentcolor, @wheelcolor)",
            { ['@username'] = player, ['@name'] = name, ['@vehicle'] = vehicle, ['@price'] = price, ['@plate'] = plate, ['@state'] = state, ['@primarycolor'] = primarycolor, ['@secondarycolor'] = secondarycolor, ['@pearlescentcolor'] = pearlescentcolor, ['@wheelcolor'] = wheelcolor })
    end)
end)

AddEventHandler('vehshop:addFreeVehicle', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local name = "Faggio Sport"
        local price = 1000
        local vehicle = "faggio"
        local plate = GeneratePlate(8)
        local state = "Rentré"
        local primarycolor = 1
        local secondarycolor = 1
        local pearlescentcolor = 1
        local wheelcolor = 1
        MySQL.Async.execute("INSERT INTO user_vehicle (`identifier`, `vehicle_name`, `vehicle_model`, `vehicle_price`, `vehicle_plate`, `vehicle_state`, `vehicle_colorprimary`, `vehicle_colorsecondary`, `vehicle_pearlescentcolor`, `vehicle_wheelcolor`) VALUES (@username, @name, @vehicle, @price, @plate, @state, @primarycolor, @secondarycolor, @pearlescentcolor, @wheelcolor)",
            { ['@username'] = player, ['@name'] = name, ['@vehicle'] = vehicle, ['@price'] = price, ['@plate'] = plate, ['@state'] = state, ['@primarycolor'] = primarycolor, ['@secondarycolor'] = secondarycolor, ['@pearlescentcolor'] = pearlescentcolor, ['@wheelcolor'] = wheelcolor })
    end)
end)

function GeneratePlate(length)
    local charset = {}

    -- 1234567890
    for i = 48, 57 do table.insert(charset, string.char(i)) end
    -- QWERTYUIOPASDFGHJKLZXCVBNM
    for i = 65, 90 do table.insert(charset, string.char(i)) end

    math.randomseed(os.time())

    local plate = ""
    while string.len(plate) < length do
        plate = plate .. charset[math.random(1, #charset)]
    end

    return plate
end