require "resources/mysql-async/lib/MySQL"

function mysql_load_interiors()
    local result = MySQL.Sync.fetchAll("SELECT * FROM interiors", {})
    local ints = {}
    if result ~= nil then
        for i = 1, #result do
            local t = table.pack(result[i]['id'], json.decode(result[i]['enter']), json.decode(result[i]['exit']), result[i]['iname'])
            table.insert(ints, t)
        end
    end
    return ints
end

RegisterServerEvent("getInteriors")
AddEventHandler('getInteriors', function()
    local to_player = mysql_load_interiors()
    if to_player ~= nil then
        TriggerClientEvent('sendInteriors', source, to_player)
    end
end)