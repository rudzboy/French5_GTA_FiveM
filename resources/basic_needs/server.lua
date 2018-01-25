-- Loading MySQL Class
require "resources/mysql-async/lib/MySQL"

local activeCommands = false

RegisterServerEvent("f5c:updateBasicNeedsValues")
AddEventHandler("f5c:updateBasicNeedsValues", function(eat, drink)
    TriggerEvent('es:getPlayerFromId', source, function(user)

        MySQL.Async.fetchAll("SELECT * FROM users WHERE `identifier` = @name",
            { ['@name'] = user.identifier }, function(result)
                if (result) then

                    local hunger = tonumber(result[1].hunger) + tonumber(eat)
                    local thirst = tonumber(result[1].thirst) + tonumber(drink)

                    if (hunger > 100) then hunger = 100 end
                    if (thirst > 100) then thirst = 100 end

                    if (hunger == 0 or thirst == 0) then
                        TriggerClientEvent('es_admin:kill', source)
                    end

                    MySQL.Async.execute("UPDATE users SET `hunger` = @hunger, `thirst` = @thirst WHERE `identifier` = @identifier",
                        { ['@hunger'] = hunger, ['@thirst'] = thirst, ['@identifier'] = user.identifier })

                    TriggerClientEvent('f5c:updateBasicNeedsUI', source, tonumber(hunger), tonumber(thirst))
                end
            end)
    end)
end)

-- Should not be used, except for debug --
if activeCommands == true then
    TriggerEvent('es:addCommand', 'eat', function(source, args, user)
        if (args[2] ~= nil and tonumber(args[3]) > 0) then
            TriggerClientEvent('chatMessage', source, "EAT", { 255, 0, 0 }, "Usage: ^2/eat (Int)")
        else
            TriggerClientEvent("f5c:playerEat", source, tonumber(args[2]))
        end
    end)

    TriggerEvent('es:addCommand', 'drink', function(source, args, user)
        if (args[2] ~= nil and tonumber(args[3]) > 0) then
            TriggerClientEvent('chatMessage', source, "DRINK", { 255, 0, 0 }, "Usage: ^2/drink (Int)")
        else
            TriggerClientEvent("f5c:playerDrink", source, tonumber(args[2]))
        end
    end)
end