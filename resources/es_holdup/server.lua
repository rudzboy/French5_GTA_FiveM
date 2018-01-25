local stores = {
    ["paleto_twentyfourseven"] = {
        position = { ['x'] = 1730.35949707031, ['y'] = 6416.7001953125, ['z'] = 35.0372161865234 },
        reward = 5000,
        nameofstore = "24/7 (Paleto Bay)",
        lastrobbed = 0,
        robbingseconds = 420
    },
    ["sandyshores_twentyfoursever"] = {
        position = { ['x'] = 1958.2, ['y'] = 3744.04, ['z'] = 32.343738555908 },
        reward = 5000,
        nameofstore = "24/7 (Sandy Shores)",
        lastrobbed = 0,
        robbingseconds = 360
    },
    ["bar_one"] = {
        position = { ['x'] = 1986.1240234375, ['y'] = 3053.8747558594, ['z'] = 47.215171813965 },
        reward = 5000,
        nameofstore = "Yellow Jack. (Sandy Shores)",
        lastrobbed = 0,
        robbingseconds = 360
    },
    ["littleseoul_twentyfourseven"] = {
        position = { ['x'] = -709.17022705078, ['y'] = -904.21722412109, ['z'] = 19.215591430664 },
        reward = 8000,
        nameofstore = "24/7 (Little Seoul)",
        lastrobbed = 0,
        robbingseconds = 240
    }
}

local robbers = {}

local delayBetweenRobbings = 7200

function get3DDistance(x1, y1, z1, x2, y2, z2)
    return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('es_holdup:toofar')
AddEventHandler('es_holdup:toofar', function(robb)
    if (robbers[source]) then
        TriggerClientEvent('es_holdup:toofarlocal', source)
        robbers[source] = nil
        local message = "Le braquage a été ~b~annulé~w~ à : ~y~" .. stores[robb].nameofstore .. "~w~."
        TriggerServerEvent('police:sendAlert', message)
        TriggerServerEvent('ssa:sendAlert', message)
    end
end)

RegisterServerEvent('es_holdup:rob')
AddEventHandler('es_holdup:rob', function(robb)
    if stores[robb] then
        local store = stores[robb]

        if (os.time() - store.lastrobbed) < delayBetweenRobbings and store.lastrobbed ~= 0 then
            -- TriggerClientEvent("showNotify", source, "Un braquage a eu lieu récemment ici. Possible dans ~y~" .. (7200 - (os.time() - store.lastrobbed)) .. " secondes~w~.")
            TriggerClientEvent("showNotify", source, "Un ~b~braquage~w~ a déjà eu lieu récemment ici.")
            return
        end
        local message = "~r~BRAQUAGE EN COURS~w~ à : ~y~" .. store.nameofstore .. "~w~."
        TriggerServerEvent('police:sendAlert', message)
        TriggerServerEvent('ssa:sendAlert', message)
        TriggerClientEvent("showNotify", source, "~r~L\'alarme a été déclenchée !")
        TriggerClientEvent("showNotify", source, "~y~Vous devez rester dans cette zone !")
        TriggerClientEvent("showNotify", source, "Tenez la position pendant ~y~" .. (store.robbingseconds / 60) .. " minutes~w~ et l\'~g~argent~w~ sera à vous !")
        TriggerClientEvent('es_holdup:currentlyrobbing', source, robb, store.robbingseconds)
        stores[robb].lastrobbed = os.time()
        robbers[source] = robb
        local savedSource = source
        SetTimeout((store.robbingseconds * 1000), function()
            if (robbers[savedSource]) then
                TriggerClientEvent('es_holdup:robberycomplete', savedSource, job)
                TriggerEvent('es:getPlayerFromId', savedSource, function(target)
                    if (target) then
                        target:addMoney(store.reward)
                        local message = "Le ~r~braquage~w~ est bientôt terminé à : ~y~" .. store.nameofstore .. " ~w~!"
                        TriggerServerEvent('police:sendAlert', message)
                        TriggerServerEvent('ssa:sendAlert', message)
                    end
                end)
            end
        end)
    end
end)
