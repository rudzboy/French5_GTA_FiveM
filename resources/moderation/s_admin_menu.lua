RegisterServerEvent('moderation:checkPermission')
AddEventHandler('moderation:checkPermission', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        if user ~= nil and tonumber(user.permission_level) == 4 then
            TriggerClientEvent('moderation:accessGranted', source)
            TriggerClientEvent('scoreboard:accessGranted', source)
            TriggerClientEvent('safes:withdrawAccessGranted', source)
        end
    end)
end)

RegisterServerEvent("moderation:kick")
AddEventHandler("moderation:kick", function(kickid)
    local kick = GetPlayerFromServerId(tonumber(kickid))
    TriggerClientEvent('showNotify', source, "Vous avez dégagé ~r~" .. GetPlayerName(kick) .. " ~w~du serveur.")
    DropPlayer(kick, 'Vous avez été dégagé du serveur.')
end)