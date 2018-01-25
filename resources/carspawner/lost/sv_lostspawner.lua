RegisterServerEvent('cp:lostspawncheck')
AddEventHandler('cp:lostspawncheck', function()

    TriggerEvent('es:getPlayerFromId', source, function(user)

        local player = user.identifier

        print(player)

        if user.permission_level >= (0) then

            TriggerClientEvent('lostvanspawn', source)

            TriggerClientEvent('lostworked', source)

        else

            TriggerClientEvent('notworked', source)
        end
    end)
end)


