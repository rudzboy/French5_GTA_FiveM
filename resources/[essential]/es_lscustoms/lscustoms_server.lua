local tbl = {
    [1] = { locked = false }
}
RegisterServerEvent('lockGarage')
AddEventHandler('lockGarage', function(b, garage)
    tbl[tonumber(garage)].locked = b
    TriggerClientEvent('lockGarage', -1, tbl)
    -- print(json.encode(tbl))
end)


RegisterServerEvent('getGarageInfo')
AddEventHandler('getGarageInfo', function()
    TriggerClientEvent('lockGarage', -1, tbl)
    --print(json.encode(tbl))
end)