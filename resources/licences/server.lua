require "resources/mysql-async/lib/MySQL"

--[[Register]]--

RegisterServerEvent('licences:getPlayerLicence')
RegisterServerEvent('licences:checkPlayerLicence')
RegisterServerEvent('licences:updateDriverLicense')
RegisterServerEvent('licences:updateCitizenLicense')

--[[Events]]--

AddEventHandler('licences:updateDriverLicense', function(value)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        updateDriverLicense(user.identifier, value)
    end)
end)

AddEventHandler('licences:getPlayerLicence', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        TriggerClientEvent('licences:getPlayerLicence', source, getDriverLicense(user.identifier))
    end)
end)

AddEventHandler('licences:checkPlayerLicence', function(target)
    TriggerEvent('es:getPlayerFromId', target, function(user)
        local targetLicence = getDriverLicense(user.identifier)
        if targetLicence == 0 then
            TriggerClientEvent("showNotify", source, "~b~" .. GetPlayerName(target) .. " ~r~ne possède pas~w~ de permis de conduire !")
        else
            TriggerClientEvent("showNotify", source, "~b~" .. GetPlayerName(target) .. " ~w~possède un permis de conduire ~g~valide~w~.")
        end
    end)
end)

AddEventHandler('licences:updateCitizenLicense', function(player, value)
    updateDriverLicense(player, value)
end)

--[[Function]]--

function updateDriverLicense(player, value)
    MySQL.Async.execute("UPDATE users SET `driving_licence` = @value WHERE identifier = @identifier", { ['@value'] = value, ['@identifier'] = player })
end

function getDriverLicense(player)
    return tonumber(MySQL.Sync.fetchScalar("SELECT `driving_licence` FROM users WHERE identifier = @identifier",
        { ['@value'] = value, ['@identifier'] = player }))
end