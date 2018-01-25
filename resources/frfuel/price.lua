local fuel = 1.30 -- Fuel Cost, this could be made to randomise between 1.05 and 1.30 or something like that

function round(num, numDecimalPlaces)
    local mult = 5 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

RegisterServerEvent('frfuel:fuelAdded')
AddEventHandler('frfuel:fuelAdded', function(amount)

    local cost = round(fuel * amount)

    TriggerClientEvent('showNotify', source, "~b~Carburant~w~ : " .. round(amount) .. " litres.\nMontant total : ~g~" .. cost .. "$~w~.")

    TriggerEvent('es:getPlayerFromId', source, function(user)

        local player = user.identifier
        local money = user.money
        local remaining = money - cost
        local due = 0

        if (remaining < 0) then
            due = cost - money
            user:setMoney(0)
            remaining = 0
        else
            user:removeMoney(cost)
        end

        TriggerEvent("es:setPlayerDataId", player, "money", remaining, function(response, success)
            TriggerClientEvent('es:activateMoney', source, remaining)
            if due > 0 then
                TriggerClientEvent('showNotify', -1, GetPlayerName(source) .. " n\'a ~r~pas payé~w~ son carburant ! (" .. due .. "$).")
            end
        end)
    end)
end)