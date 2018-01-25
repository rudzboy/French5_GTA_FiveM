-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

-- Loading MySQL Class
require "resources/mysql-async/lib/MySQL"

function LoadUser(identifier, source, new)
   --MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @name",
       --{ ['@name'] = identifier }, function(result)
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @name", {['@name'] = identifier})
    local group = groups[result[1].group]
    Users[source] = Player(source, result[1].permission_level, result[1].money, result[1].identifier, group, result[1].phone_number, result[1].isFirstConnection )

    TriggerEvent('es:playerLoaded', source, Users[source])

    if (true) then
        TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
    end

    if (true) then
        TriggerEvent('es:newPlayerLoaded', source, Users[source])
    end
end

function stringsplit(self, delimiter)
    local a = self:Split(delimiter)
    local t = {}

    for i = 0, #a - 1 do
        table.insert(t, a[i])
    end

    return t
end

function isIdentifierBanned(id)
    local result = MySQL.Sync.fetchAll("SELECT * FROM bans WHERE banned = @name",
        { ['@name'] = id })
    if (result) then
        for k, v in ipairs(result) do
            if v.expires > v.timestamp then
                return true
            end
        end
    end
    return false
end

AddEventHandler('es:getPlayers', function(cb)
    cb(Users)
end)

function hasAccount(identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @name",
        { ['@name'] = identifier })
    if (result[1] ~= nil) then
        return true
    end
    return false
end


function isLoggedIn(source)
    if (Users[GetPlayerName(source)] ~= nil) then
        if (Users[GetPlayerName(source)]['isLoggedIn'] == 1) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function registerUser(identifier, source)
    if not hasAccount(identifier) then
        -- Inserting Default User Account Stats
        MySQL.Async.execute("INSERT INTO users (`identifier`, `permission_level`, `money`, `group`) VALUES (@username, 0, @money, 'user')",
            { ['@username'] = identifier, ['@money'] = settings.defaultSettings.startingCash })

        LoadUser(identifier, source, true)
    else
        LoadUser(identifier, source)
    end
end

AddEventHandler("es:setPlayerData", function(user, k, v, cb)
    if (Users[user]) then
        if (Users[user][k]) then

            if (k ~= "money") then
                Users[user][k] = v

                MySQL.Async.execute("UPDATE users SET `@attr`=@value WHERE identifier = @identifier",
                    { ['@attr'] = k, ['@value'] = v, ['@identifier'] = Users[user]['identifier'] })
            end

            if (k == "group") then
                Users[user].group = groups[v]
            end

            cb("Player data edited.", true)
        else
            cb("Column does not exist!", false)
        end
    else
        cb("User could not be found!", false)
    end
end)

AddEventHandler("es:setPlayerDataId", function(user, k, v, cb)
    MySQL.Async.execute("UPDATE users SET @key =@value WHERE identifier = @identifier",
        { ['@key'] = k, ['@value'] = v, ['@identifier'] = user })

    cb("Player data edited.", true)
end)

AddEventHandler("es:getPlayerFromId", function(user, cb)
    if (Users) then
        if (Users[user]) then
            cb(Users[user])
        else
            cb(nil)
        end
    else
        cb(nil)
    end
end)

AddEventHandler("es:getPlayerFromIdentifier", function(identifier, cb)
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @name",
        { ['@name'] = identifier }, function(result)
            if (result[1]) then
                cb(result[1])
            else
                cb(nil)
            end
        end)
end)

AddEventHandler("es:getAllPlayers", function(cb)
    MySQL.Async.fetchAll("SELECT * FROM users",
        {}, function(result)
            if (result) then
                cb(result)
            else
                cb(nil)
            end
        end)
end)

-- Function to update player money every 60 seconds.
local function savePlayerMoney()
    SetTimeout(60000, function()
        TriggerEvent("es:getPlayers", function(users)
            for k, v in pairs(users) do
                MySQL.Async.execute("UPDATE users SET `money`=@value WHERE identifier = @identifier",
                    { ['@value'] = v.money, ['@identifier'] = v.identifier })
            end
        end)

        savePlayerMoney()
    end)
end

savePlayerMoney()