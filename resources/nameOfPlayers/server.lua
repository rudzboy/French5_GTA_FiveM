require "resources/mysql-async/lib/MySQL"

RegisterServerEvent('cp:spawnplayer')
AddEventHandler('cp:spawnplayer', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        MySQL.Async.execute("UPDATE users SET `Nom` = @name WHERE identifier = @username",
            { ['@name'] = GetPlayerName(source), ['@username'] = player })
    end)
end)