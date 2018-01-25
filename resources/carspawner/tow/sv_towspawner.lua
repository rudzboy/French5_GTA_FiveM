RegisterServerEvent('cp:towspawncheck')
AddEventHandler('cp:towspawncheck', function()

    TriggerEvent('es:getPlayerFromId', source, function(user)

        local player = user.identifier

        print(player)

        if user.permission_level >= (0) then

            TriggerClientEvent('towspawn', source)

            TriggerClientEvent('towworked', source)

        else

            TriggerClientEvent('notworked', source)
        end
    end)
end)


