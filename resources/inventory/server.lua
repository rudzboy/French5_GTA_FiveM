require "resources/mysql-async/lib/MySQL"

local itemsLabels = {}
local itemsLegality = {}
local itemsMaxQuantity = {}

MySQL.Async.fetchAll("SELECT * FROM `items`",
    {}, function(result)
        if (result) then
            for _, v in ipairs(result) do
                table.insert(itemsLegality, tonumber(v.id), v.isIllegal)
                table.insert(itemsLabels, tonumber(v.id), tostring(v.libelle))
                table.insert(itemsMaxQuantity, tonumber(v.id), tostring(v.maxQuantity))
            end
        end
    end)

RegisterServerEvent("inventory:addItem")
AddEventHandler("inventory:addItem", function(item_id, value)
    local user_identifier = tostring(getPlayerID(source))
    local quantity = getItemQuantity(user_identifier, item_id)
    local total = tonumber(quantity + value)
    if total <= tonumber(itemsMaxQuantity[item_id]) then
        if (quantity == 0) then
            MySQL.Async.execute("INSERT INTO `user_inventory` (`user_id`, `item_id`, `quantity`) VALUES (@user_identifier, @item_id, @value)",
                { ['@user_identifier'] = tostring(user_identifier), ['@item_id'] = tonumber(item_id), ['@value'] = tonumber(total) },
            function()
                TriggerClientEvent('showNotify', source, 'Inventaire : ~y~' .. tostring(total) .. '~w~ ' .. tostring(itemsLabels[item_id]))
                TriggerClientEvent("inventory:getItems", source)
            end)
        else
            MySQL.Async.execute("UPDATE `user_inventory` SET `quantity` = @value WHERE `user_id` = @user_identifier AND `item_id` = @item_id",
                { ['@user_identifier'] = tostring(user_identifier), ['@item_id'] = tonumber(item_id), ['@value'] = tonumber(total) },
            function()
                TriggerClientEvent('showNotify', source, 'Inventaire : ~y~' .. tostring(total) .. '~w~ ' .. tostring(itemsLabels[item_id]))
                TriggerClientEvent("inventory:getItems", source)
            end)
        end

    else
        TriggerClientEvent('showNotify', source, '~r~Vous ne pouvez pas porter plus de ~w~: ~y~' .. tostring(itemsLabels[item_id]) .. '~w~ (max: ' .. itemsMaxQuantity[item_id] .. ').')
    end
end)

RegisterServerEvent("inventory:buyItem")
AddEventHandler("inventory:buyItem", function(item_id, value, price)
    local user_identifier = tostring(getPlayerID(source))
    local quantity = getItemQuantity(user_identifier, item_id)
    local total = tonumber(quantity + value)
    if total <= tonumber(itemsMaxQuantity[item_id]) then
        TriggerEvent("es:getPlayerFromId", source, function(user)
            local totalPrice = tonumber(value * price)
            if (user.money > totalPrice) then
                user:removeMoney(totalPrice)
                if (quantity == 0) then
                    MySQL.Async.execute("INSERT INTO `user_inventory` (`user_id`, `item_id`, `quantity`) VALUES (@user_identifier, @item_id, @value)",
                        { ['@user_identifier'] = tostring(user_identifier), ['@item_id'] = tonumber(item_id), ['@value'] = tonumber(total) },
                    function()
                        TriggerClientEvent('showNotify', source, 'Inventaire : ~y~' .. tostring(total) .. '~w~ ' .. tostring(itemsLabels[item_id]))
                        TriggerClientEvent("inventory:getItems", source)
                    end)
                else
                    MySQL.Async.execute("UPDATE `user_inventory` SET `quantity` = @value WHERE `user_id` = @user_identifier AND `item_id` = @item_id",
                        { ['@user_identifier'] = tostring(user_identifier), ['@item_id'] = tonumber(item_id), ['@value'] = tonumber(total) },
                    function()
                        TriggerClientEvent('showNotify', source, 'Inventaire : ~y~' .. tostring(total) .. '~w~ ' .. tostring(itemsLabels[item_id]))
                        TriggerClientEvent("inventory:getItems", source)
                    end)
                end
            else
                TriggerClientEvent('showNotify', source, '~r~Vous n\'avez pas assez d\'argent.')
            end
        end)
    else
        TriggerClientEvent('showNotify', source, '~r~Vous ne pouvez pas porter plus de ~w~: ~y~' .. tostring(itemsLabels[item_id]) .. '~w~ (max: ' .. itemsMaxQuantity[item_id] .. ').')
    end
end)

RegisterServerEvent("inventory:transferItem")
AddEventHandler("inventory:transferItem", function(item_id, value, senderId)
    local receiverId = source
    local user_identifier = tostring(getPlayerID(receiverId))
    local quantity = getItemQuantity(user_identifier, item_id)
    local total = tonumber(quantity + value)
    if total <= tonumber(itemsMaxQuantity[item_id]) then
        if (quantity == 0) then
            MySQL.Async.execute("INSERT INTO `user_inventory` (`user_id`, `item_id`, `quantity`) VALUES (@user_identifier, @item_id, @value)",
                { ['@user_identifier'] = tostring(user_identifier), ['@item_id'] = tonumber(item_id), ['@value'] = tonumber(total) },
            function()
                TriggerClientEvent('showNotify', receiverId, '~b~' .. GetPlayerName(senderId) .. ' ~w~vous a donné ' .. value .. ' ~y~' .. tostring(itemsLabels[item_id]) .. '~w~.')
                TriggerClientEvent('showNotify', source, 'Inventaire : ~y~' .. tostring(total) .. '~w~ ' .. tostring(itemsLabels[item_id]))
                TriggerClientEvent("inventory:getItems", receiverId)
                TriggerClientEvent('inventory:transferCompleted', senderId, item_id, value)
                TriggerClientEvent('showNotify', senderId, 'Vous avez donné ' .. value .. ' ~y~' .. tostring(itemsLabels[item_id]) .. '~w~ à ~b~' .. GetPlayerName(receiverId) .. '~w~.')
            end)
        else
            MySQL.Async.execute("UPDATE `user_inventory` SET `quantity` = @value WHERE `user_id` = @user_identifier AND `item_id` = @item_id",
                { ['@user_identifier'] = tostring(user_identifier), ['@item_id'] = tonumber(item_id), ['@value'] = tonumber(total) },
            function()
                TriggerClientEvent('showNotify', receiverId, '~b~' .. GetPlayerName(senderId) .. ' ~w~vous a donné ' .. value .. ' ~y~' .. tostring(itemsLabels[item_id]) .. '~w~.')
                TriggerClientEvent('showNotify', source, 'Inventaire : ~y~' .. tostring(total) .. '~w~ ' .. tostring(itemsLabels[item_id]))
                TriggerClientEvent("inventory:getItems", receiverId)
                TriggerClientEvent('inventory:transferCompleted', senderId, item_id, value)
                TriggerClientEvent('showNotify', senderId, 'Vous avez donné ' .. value .. ' ~y~' .. tostring(itemsLabels[item_id]) .. '~w~ à ~b~' .. GetPlayerName(receiverId) .. '~w~.')
            end)
        end
    else
        TriggerClientEvent('showNotify', receiverId, '~r~Vous ne pouvez pas porter plus de ~w~: ~y~' .. tostring(itemsLabels[item_id]) .. '~w~ (max: ' .. itemsMaxQuantity[item_id] .. ').')
        TriggerClientEvent('showNotify', senderId, '~b~' .. GetPlayerName(receiverId) .. ' ~r~ ne peut pas porter plus de ~w~: ~y~' .. tostring(itemsLabels[item_id]) .. '~w~ (max: ' .. itemsMaxQuantity[item_id] .. ').')
    end
end)

RegisterServerEvent("inventory:removeItem")
AddEventHandler("inventory:removeItem", function(item_id, value)
    local user_identifier = tostring(getPlayerID(source))
    local quantity = getItemQuantity(user_identifier, item_id)
    local remaining = tonumber(quantity - value)
    if (remaining < 0) then
        TriggerClientEvent('showNotify', source, '~r~Suppression impossible')
    else
        if (remaining > 0) then
            MySQL.Async.execute("UPDATE `user_inventory` SET `quantity` = @value WHERE `user_id` = @user_identifier AND `item_id` = @item_id",
                { ['@user_identifier'] = tostring(user_identifier), ['@item_id'] = tonumber(item_id), ['@value'] = tonumber(remaining) },
            function()
                TriggerClientEvent("inventory:getItems", source)
            end)
        else
            MySQL.Async.execute("DELETE FROM `user_inventory` WHERE `user_id` = @user_identifier AND `item_id` = @item_id",
                { ['@user_identifier'] = tostring(user_identifier), ['@item_id'] = tonumber(item_id) },
            function()
                TriggerClientEvent('showNotify', source, 'Plus de : ' .. tostring(itemsLabels[item_id]))
                TriggerClientEvent("inventory:getItems", source)
            end)
        end
    end
end)

RegisterServerEvent("inventory:askForTransfer")
AddEventHandler("inventory:askForTransfer", function(item_id, value, playerId, senderCoordsX, senderCoordsY, senderCoordsZ)
    TriggerClientEvent('showNotify', source, 'Vous avez proposé ' .. value .. ' ~y~' .. tostring(itemsLabels[item_id]) .. '~w~ à ' .. GetPlayerName(playerId) .. '.')
    TriggerClientEvent("inventory:askForTransfer", playerId, item_id, value, tostring(itemsLabels[item_id]), source, senderCoordsX, senderCoordsY, senderCoordsZ, GetPlayerName(source))
end)

RegisterServerEvent("inventory:transferRefused")
AddEventHandler("inventory:transferRefused", function(senderId)
    TriggerClientEvent('showNotify', senderId, '~b~' .. GetPlayerName(source) .. '~w~ a ~r~refusé~w~ de recevoir cet ~y~objet~w~.')
end)

RegisterServerEvent("inventory:transferAborted")
AddEventHandler("inventory:transferAborted", function(senderId)
    TriggerClientEvent('showNotify', senderId, '~b~' .. GetPlayerName(source) .. '~w~ n\'a ~r~pas donné suite ~w~à la réception de cet ~y~objet~w~.')
end)

RegisterServerEvent("inventory:removeIllegalItems")
AddEventHandler("inventory:removeIllegalItems", function(player)
    local user_identifier = tostring(getPlayerID(player))
    MySQL.Async.execute("DELETE FROM `user_inventory` WHERE `user_id` = @user_identifier AND `item_id` IN (SELECT `id` FROM `items` WHERE `isIllegal` = 1)",
        { ['@user_identifier'] = tostring(user_identifier) },
    function()
        TriggerClientEvent('showNotify', player, 'Vos objets illégaux ont été supprimés.')
        TriggerClientEvent("inventory:getItems", player)
    end)

end)

RegisterServerEvent("inventory:getItemQuantity")
AddEventHandler("inventory:getItemQuantity", function(item_id)
    local user_identifier = tostring(getPlayerID(source))
    local quantity = getItemQuantity(user_identifier, item_id)
    TriggerClientEvent("player:getItemQuantity", source, item_id, quantity)
end)


RegisterServerEvent("inventory:reset")
AddEventHandler("inventory:reset", function()
    local user_identifier = tostring(getPlayerID(source))
    MySQL.Async.execute("DELETE FROM `user_inventory` WHERE `user_id` = @user_identifier",
        { ['@user_identifier'] = tostring(user_identifier) },
    function()
        TriggerClientEvent('showNotify', source, 'Vous n\'avez ~r~plus d\'objet~w~ dans votre ~y~inventaire~w~ !')
        TriggerClientEvent("inventory:getItems", source)
    end)
end)

RegisterServerEvent("inventory:sell")
AddEventHandler("inventory:sell", function(item_id, value, price)
    local user_identifier = tostring(getPlayerID(source))
    local quantity = getItemQuantity(user_identifier, item_id)
    local remaining = tonumber(quantity - value)

    if (remaining < 0) then
        TriggerClientEvent('showNotify', source, '~r~Vente impossible')
    else
        if (remaining > 0) then
            MySQL.Async.execute("UPDATE `user_inventory` SET `quantity` = @value WHERE `user_id` = @user_identifier AND `item_id` = @item_id",
                { ['@user_identifier'] = tostring(user_identifier), ['@item_id'] = tonumber(item_id), ['@value'] = tonumber(remaining) },
            function()
                TriggerClientEvent('showNotify', source, 'Reste : ~y~' .. tostring(remaining) .. '~w~ ' .. tostring(itemsLabels[item_id]))
                TriggerEvent('es:getPlayerFromId', source, function(user)
                    user:addMoney(tonumber(price * value))
                end)
                TriggerClientEvent('showNotify', source, 'Vendu : ~y~' .. tostring(value) .. '~w~ ' .. tostring(itemsLabels[item_id]) .. ' contre ~g~$' .. tostring(price * value))
                TriggerClientEvent("inventory:getItems", source)
            end)

        else
            MySQL.Async.execute("DELETE FROM `user_inventory` WHERE `user_id` = @user_identifier AND `item_id` = @item_id",
                { ['@user_identifier'] = tostring(user_identifier), ['@item_id'] = tonumber(item_id) },
            function()
                TriggerClientEvent('showNotify', source, 'Plus de : ' .. tostring(itemsLabels[item_id]))
                TriggerEvent('es:getPlayerFromId', source, function(user)
                    user:addMoney(tonumber(price * value))
                end)
                TriggerClientEvent('showNotify', source, 'Vendu : ~y~' .. tostring(value) .. '~w~ ' .. tostring(itemsLabels[item_id]) .. ' contre ~g~$' .. tostring(price * value))
                TriggerClientEvent("inventory:getItems", source)
            end)
        end
    end
end)

function getItemQuantity(user_identifier, item_id)
    return tonumber(MySQL.Sync.fetchScalar("SELECT `quantity` FROM `user_inventory` JOIN `items` ON `user_inventory`.`item_id` = `items`.`id` WHERE `user_id` = @user_identifier AND `item_id` = @item_id",
        { ['@user_identifier'] = user_identifier, ['@item_id'] = item_id }) or 0)
end

-- UTILITY EVENT OR NOT --

RegisterServerEvent("inventory:getItems")
AddEventHandler("inventory:getItems", function()
    local items = {}
    local player = getPlayerID(source)
    MySQL.Async.fetchAll("SELECT * FROM `user_inventory` JOIN `items` ON `user_inventory`.`item_id` = `items`.`id` WHERE user_id = @username",
        { ['@username'] = player }, function(result)
            if (result) then
                for _, v in ipairs(result) do
                    local t = { ["id"] = tonumber(v.item_id), ["quantity"] = tonumber(v.quantity), ["libelle"] = v.libelle, ["isIllegal"] = i_format(itemsLegality[tonumber(v.item_id)]) }
                    table.insert(items, t)
                end
            end
            TriggerClientEvent("inventory:updateInventory", source, items)
        end)
end)

-- UTILITY FUNCTION OR NOT --

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function i_format(var)
    if var == "True" then
        return "1"
    end
    return "0"
end
