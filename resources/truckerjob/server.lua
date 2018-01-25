RegisterServerEvent('truckerJob:success')
AddEventHandler('truckerJob:success', function(price)
    print("Player ID " .. source)
    -- Get the players money amount
    TriggerEvent('es:getPlayerFromId', source, function(user)
        total = price;
        -- update player money amount
        user:addMoney((total))
    end)
end)