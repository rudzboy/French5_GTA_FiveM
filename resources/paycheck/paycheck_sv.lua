require "resources/mysql-async/lib/MySQL"

RegisterServerEvent('paycheck:salary')
AddEventHandler('paycheck:salary', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        MySQL.Async.fetchAll("SELECT `salary` FROM `users` INNER JOIN `jobs` ON `users`.`job` = `jobs`.`job_id` WHERE `identifier` = @username",
            { ['@username'] = user.identifier }, function(result)
                local salary = result[1].salary
                if (tonumber(salary) > 0) then
                    TriggerClientEvent('paycheck:depositSalary', source, tonumber(salary))
                end
            end)
    end)
end)
