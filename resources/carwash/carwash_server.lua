--Settings--

enableprice = true -- true = carwash is paid, false = carwash is free

price = 50 -- you may edit this to your liking. if "enableprice = false" ignore this one

--DO-NOT-EDIT-BELLOW-THIS-LINE--

RegisterServerEvent('carwash:checkmoney')
AddEventHandler('carwash:checkmoney', function()
    TriggerEvent('es:getPlayerFromId', source, function(player)
        if (enableprice == true) then
            if (player:money >= price) then
                player:removeMoney((price))
                TriggerClientEvent('carwash:success', source, price)
            else
                moneyleft = price - player:money
                TriggerClientEvent('carwash:notenoughmoney', source, moneyleft)
            end
        else
            TriggerClientEvent('carwash:free', source)
        end
    end)
end)
