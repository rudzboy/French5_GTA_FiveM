-- Loading MySQL Class
require "resources/mysql-async/lib/MySQL"

local max_number_weapons = 6 --maximum number of weapons that the player can buy. Weapons given at spawn doesn't count.
local cost_ratio = 100 --Ratio for withdrawing the weapons. This is price/cost_ratio = cost.

RegisterServerEvent('CheckMoneyForWea')
AddEventHandler('CheckMoneyForWea', function(weapon, price)
    TriggerEvent('es:getPlayerFromId', source, function(user)

        if (tonumber(user.money) >= tonumber(price)) then
            local player = user.identifier
            MySQL.Async.fetchAll("SELECT * FROM user_weapons WHERE identifier = @username",
                { ['@username'] = player }, function(result)

                    if (tonumber(max_number_weapons) > #result) then
                        local hasWeapon = false
                        local result = MySQL.Async.fetchAll("SELECT * FROM user_weapons WHERE identifier = @username",
                            { ['@username'] = player })
                        if (result) then
                            for _, v in ipairs(result) do
                                if (v.weapon_model == weapon) then
                                    hasWeapon = true
                                    TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_ROBERTO", 1, "Roberto", false, "Vous avez déjà cette arme !\n")
                                    return
                                end
                            end
                        end

                        if hasWeapon == false then
                            user:removeMoney((price))
                            MySQL.Async.execute("INSERT INTO user_weapons (`identifier`,`weapon_model`,`withdraw_cost`) VALUES (@username, @weapon, @cost)",
                                { ['@username'] = player, ['@weapon'] = weapon, ['@cost'] = (price) / cost_ratio })
                            -- Trigger some client stuff
                            --TriggerClientEvent('FinishMoneyCheckForWea',source)
                            TriggerClientEvent("giveWeapon", source, weapon, 10)
                            TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_ROBERTO", 1, "Roberto", false, "Merci pour votre achat !\n")
                        end

                    else
                        -- TriggerClientEvent('ToManyWeapons',source)
                        TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_ROBERTO", 1, "Roberto", false, "Vous ne pouvez pas porter plus d\'armes ! (max: " .. max_number_weapons .. ")")
                    end
                end)
        else
            -- Inform the player that he needs more money
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_ROBERTO", 1, "Roberto", false, "Pas assez d\'argent !\n")
        end
    end)
end)

RegisterServerEvent("weaponshop:playerSpawned")
AddEventHandler("weaponshop:playerSpawned", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        TriggerEvent('weaponshop:GiveWeaponsToPlayer', source)
    end)
end)

RegisterServerEvent("weaponshop:deletePlayerWeapons")
AddEventHandler("weaponshop:deletePlayerWeapons", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        MySQL.Async.execute("DELETE FROM user_weapons WHERE identifier = @username", { ['@username'] = user.identifier })
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_ROBERTO", 1, "Roberto", false, "Vous avez ~r~perdu~w~ vos ~y~armes~w~ !\n")
    end)
end)

RegisterServerEvent("weaponshop:GiveWeaponsToPlayer")
AddEventHandler("weaponshop:GiveWeaponsToPlayer", function(player)
    TriggerEvent('es:getPlayerFromId', player, function(user)
        local delay = 2000

        MySQL.Async.fetchAll("SELECT * FROM user_weapons WHERE identifier = @username",
            { ['@username'] = user.identifier }, function(result)
                if (result) then
                    for _, v in ipairs(result) do
                        TriggerClientEvent("giveWeapon", player, v.weapon_model, delay)
                    end
                end
            end)
    end)
end)

RegisterServerEvent("weaponshop:GiveWeaponsToSelf")
AddEventHandler("weaponshop:GiveWeaponsToSelf", function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local delay = 2000
        MySQL.Async.fetchAll("SELECT * FROM user_weapons WHERE identifier = @username",
            { ['@username'] = user.identifier }, function(result)
                if (result) then
                    for _, v in ipairs(result) do
                        TriggerClientEvent("giveWeapon", source, v.weapon_model, delay)
                    end
                end
            end)
    end)
end)
