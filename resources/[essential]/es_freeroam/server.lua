-- Configure the coordinates where the player gets spawned when he joins the server.
spawnCoords = { x = 1788.25, y = 3890.34, z = 34.3849 }

require "resources/mysql-async/lib/MySQL"

RegisterServerEvent('playerSpawn')
AddEventHandler('playerSpawn', function()
    TriggerClientEvent('es_freeroam:spawnPlayer', source, spawnCoords.x, spawnCoords.y, spawnCoords.z)
end)

AddEventHandler('es:playerLoaded', function(source)
    -- Get the players money amount
    TriggerEvent("es:getPlayerFromId", source, function(user)
        user:setMoney((user.money))
    end)
end)

RegisterServerEvent('mission:completed')
AddEventHandler('mission:completed', function(total)
    -- Get the players money amount
    TriggerEvent('es:getPlayerFromId', source, function(user)
        -- update player money amount
        user:addMoney((total))
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "You received ~g~$" .. tonumber(total))
    end)
end)

RegisterServerEvent('es_freeroam:pay')
AddEventHandler('es_freeroam:pay', function(amount)
    -- Get the players money amount
    TriggerEvent("es:getPlayerFromId", source, function(user)
        if (user.money > amount) then
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Your transaction is ~g~completed.")
            user:removeMoney((amount))
        else
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Your transaction is ~r~rejected.")
        end
    end)
end)
