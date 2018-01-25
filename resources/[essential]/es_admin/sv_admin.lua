local permission = {
    kick = 1,
    ban = 4
}

local serverTime = tonumber(os.time())

-- Loading MySQL Class
require "resources/mysql-async/lib/MySQL"

-- Adding custom groups called owner, inhereting from superadmin. (It's higher then superadmin). And moderator, higher then user but lower then admin
TriggerEvent("es:addGroup", "owner", "superadmin", function(group) end)
TriggerEvent("es:addGroup", "mod", "user", function(group) end)

-- Default commands
TriggerEvent('es:addCommand', 'admin', function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Permission level: ^2" .. user['permission_level'])
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Group: ^2" .. user.group.group)
end)

TriggerEvent('es:addGroupCommand', 'vn', "mod", function(source, args, user)
    TriggerClientEvent("es_admin:viewname", source)
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficient permissions!")
end)

--[[
TriggerEvent('es:addCommand', 'car', function(source, args, user)
	TriggerClientEvent('es_admin:spawnVehicle', source, args[2])
end)

TriggerEvent('es:addCommand', 'hash', function(source, args, user)
	TriggerClientEvent('es_admin:getHash', source, args[2])
end)
]]--

-- Default commands
TriggerEvent('es:addCommand', 'report', function(source, args, user)
    table.remove(args, 1)
    TriggerClientEvent('chatMessage', source, "REPORT", { 255, 0, 0 }, " (^2" .. GetPlayerName(source) .. " | " .. source .. "^0) " .. table.concat(args, " "))

    TriggerEvent("es:getPlayers", function(pl)
        for k, v in pairs(pl) do
            TriggerEvent("es:getPlayerFromId", k, function(user)
                if (user.permission_level > 0 and k ~= source) then
                    TriggerClientEvent('chatMessage', k, "REPORT", { 255, 0, 0 }, " (^2" .. GetPlayerName(source) .. " | " .. source .. "^0) " .. table.concat(args, " "))
                end
            end)
        end
    end)
end)

-- Append a message
function appendNewPos(msg)
    local file = io.open('resources/[essential]/es_admin/positions.txt', "a")
    newFile = msg
    file:write(newFile)
    file:flush()
    file:close()
end

-- Do them hashes
function doHashes()
    lines = {}
    for line in io.lines("resources/[essential]/es_admin/input.txt") do
        lines[#lines + 1] = line
    end

    return lines
end


RegisterServerEvent('es_admin:givePos')
AddEventHandler('es_admin:givePos', function(str)
    appendNewPos(str)
end)

TriggerEvent('es:addGroupCommand', 'hashes', "owner", function(source, args, user)
    TriggerClientEvent('es_admin:doHashes', source, doHashes())
end, function(source, args, user) end)

-- Noclip
TriggerEvent('es:addGroupCommand', 'noclip', "owner", function(source, args, user)
    TriggerClientEvent("es_admin:noclip", source)
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficienct permissions!")
end)

-- Kicking
TriggerEvent('es:addGroupCommand', 'kick', "mod", function(source, args, user)
    if (GetPlayerName(tonumber(args[2]))) then
        local player = tonumber(args[2])

        -- User permission check
        TriggerEvent("es:getPlayerFromId", player, function(target)
            if (tonumber(target.permission_level) > tonumber(user.permission_level)) then
                TriggerClientEvent("chatMessage", source, "SYSTEM", { 255, 0, 0 }, "You're not allowed to target this person!")
                return
            end

            local reason = args
            table.remove(reason, 1)
            table.remove(reason, 1)
            if (#reason == 0) then
                reason = "Kick: Vous avez été viré du serveur."
            else
                reason = "Kick: " .. table.concat(reason, " ")
            end

            --TriggerClientEvent('chatMessage', -1, "SYSTEM", {255, 0, 0}, "Player ^2" .. GetPlayerName(player) .. "^0 has been kicked(^2" .. reason .. "^0)")
            DropPlayer(player, reason)
        end)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Incorrect player ID!")
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficienct permissions!")
end)

-- Banning
TriggerEvent('es:addGroupCommand', 'ban', "mod", function(source, args, user)
    if (GetPlayerName(tonumber(args[2])) ~= nil) then
        -- User permission check
        local player = tonumber(args[2])
        TriggerEvent("es:getPlayerFromId", player, function(target)
            if (tonumber(target.permission_level) > tonumber(user.permission_level)) then
                TriggerClientEvent("chatMessage", source, "SYSTEM", { 255, 0, 0 }, "You're not allowed to target this person!")
                return
            end
            local time = args[3]

            local message = ""

            if string.find(time, "m") then
                time = string.gsub(time, "m", "")
                time = os.time() + (tonumber(time) * 60)
                message = time .. " minute(s)"
            elseif string.find(time, "h") then
                time = string.gsub(time, "h", "")
                message = time .. " hour(s)"
                time = os.time() + (tonumber(time) * 60 * 60)
            else
                time = os.time() + tonumber(time)
                message = time .. " second(s)"
            end

            if not tonumber(time) > 0 then
                time = os.time() + 999999999999
                message = 'very long'
            end

            local reason = args
            table.remove(reason, 1)
            table.remove(reason, 1)
            table.remove(reason, 1)

            reason = "Banned: " .. table.concat(reason, " ")

            if (reason == "Banned: ") then
                reason = reason .. "Vous avez été banni pour : ^1^*" .. message .. "^r^0."
                DropPlayer(player, "Vous avez été banni pour : " .. message)
            else
                DropPlayer(player, "Banni: " .. reason)
            end

            if player ~= nil then
                TriggerClientEvent('showNotify', -1, "~b~" .. GetPlayerName(player) .. "~w~ a été ~r~banni~w~ pour : " .. reason .. ".")
            else
                TriggerClientEvent('showNotify', -1, "Un ~b~joueur~w~ a été ~r~banni~w~ pour : " .. reason .. ".")
            end

            local tstamp = os.date("*t", time)
            local tstamp2 = os.date("*t", os.time())

            MySQL.Sync.execute("DELETE FROM bans where `banned` = @username",
                { ['@username'] = target.identifier })

            MySQL.Sync.execute("INSERT INTO bans (`banned`, `reason`, `expires`, `banner`, `timestamp`) VALUES (@username, @reason, @expires, @banner, @now)",
                { ['@username'] = target.identifier, ['@reason'] = reason, ['@expires'] = os.date(tstamp.year .. "-" .. tstamp.month .. "-" .. tstamp.day .. " " .. tstamp.hour .. ":" .. tstamp.min .. ":" .. tstamp.sec), ['@banner'] = user.identifier, ['@now'] = os.date(tstamp2.year .. "-" .. tstamp2.month .. "-" .. tstamp2.day .. " " .. tstamp2.hour .. ":" .. tstamp2.min .. ":" .. tstamp2.sec) })
        end)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Incorrect player ID!")
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficienct permissions!")
end)

function stringsplit(self, delimiter)
    local a = self:Split(delimiter)
    local t = {}

    for i = 0, #a - 1 do
        table.insert(t, a[i])
    end

    return t
end

-- Announcing
TriggerEvent('es:addGroupCommand', 'announce', "mod", function(source, args, user)
    table.remove(args, 1)
    TriggerClientEvent('chatMessage', -1, "ANNONCE", { 255, 0, 0 }, "" .. table.concat(args, " "))
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficienct permissions!")
end)

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'freeze', "owner", function(source, args, user)
    if (GetPlayerName(tonumber(args[2]))) then
        local player = tonumber(args[2])

        -- User permission check
        TriggerEvent("es:getPlayerFromId", player, function(target)
            if (tonumber(target.permission_level) > tonumber(user.permission_level)) then
                TriggerClientEvent("chatMessage", source, "SYSTEM", { 255, 0, 0 }, "You're not allowed to target this person!")
                return
            end

            if (frozen[player]) then
                frozen[player] = false
            else
                frozen[player] = true
            end

            TriggerClientEvent('es_admin:freezePlayer', player, frozen[player])

            local state = "unfrozen"
            if (frozen[player]) then
                state = "frozen"
            end

            TriggerClientEvent('chatMessage', player, "SYSTEM", { 255, 0, 0 }, "You have been " .. state .. " by ^2" .. GetPlayerName(source))
            TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Player ^2" .. GetPlayerName(player) .. "^0 has been " .. state)
        end)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Incorrect player ID!")
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficienct permissions!")
end)

-- Bring
local frozen = {}
TriggerEvent('es:addGroupCommand', 'bring', "owner", function(source, args, user)
    if (GetPlayerName(tonumber(args[2]))) then
        local player = tonumber(args[2])

        -- User permission check
        TriggerEvent("es:getPlayerFromId", player, function(target)
            if (tonumber(target.permission_level) > tonumber(user.permission_level)) then
                TriggerClientEvent("chatMessage", source, "SYSTEM", { 255, 0, 0 }, "You're not allowed to target this person!")
                return
            end

            TriggerClientEvent('es_admin:teleportUser', player, source)

            TriggerClientEvent('chatMessage', player, "SYSTEM", { 255, 0, 0 }, "You have brought by ^2" .. GetPlayerName(source))
            TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Player ^2" .. GetPlayerName(player) .. "^0 has been brought")
        end)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Incorrect player ID!")
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficienct permissions!")
end)

-- Bring
local frozen = {}
TriggerEvent('es:addGroupCommand', 'slap', "owner", function(source, args, user)
    if (GetPlayerName(tonumber(args[2]))) then
        local player = tonumber(args[2])

        -- User permission check
        TriggerEvent("es:getPlayerFromId", player, function(target)
            if (tonumber(target.permission_level) > tonumber(user.permission_level)) then
                TriggerClientEvent("chatMessage", source, "SYSTEM", { 255, 0, 0 }, "You're not allowed to target this person!")
                return
            end

            TriggerClientEvent('es_admin:slap', player)

            TriggerClientEvent('chatMessage', player, "SYSTEM", { 255, 0, 0 }, "You have slapped by ^2" .. GetPlayerName(source))
            TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Player ^2" .. GetPlayerName(player) .. "^0 has been slapped")
        end)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Incorrect player ID!")
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficienct permissions!")
end)

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'goto', "owner", function(source, args, user)
    if (GetPlayerName(tonumber(args[2]))) then
        local player = tonumber(args[2])

        -- User permission check
        TriggerEvent("es:getPlayerFromId", player, function(target)
            if (target) then
                if (tonumber(target.permission_level) > tonumber(user.permission_level)) then
                    TriggerClientEvent("chatMessage", source, "SYSTEM", { 255, 0, 0 }, "You're not allowed to target this person!")
                    return
                end

                TriggerClientEvent('es_admin:teleportUser', source, player)

                TriggerClientEvent('chatMessage', player, "SYSTEM", { 255, 0, 0 }, "You have been teleported to by ^2" .. GetPlayerName(source))
                TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Teleported to player ^2" .. GetPlayerName(player) .. "")
            end
        end)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Incorrect player ID!")
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficienct permissions!")
end)

-- Kill yourself
TriggerEvent('es:addCommand', 'die', function(source, args, user)
    TriggerClientEvent('es_admin:kill', source)
    TriggerClientEvent('chatMessage', source, "", { 0, 0, 0 }, "^1^*You killed yourself.")
end)

-- Killing
TriggerEvent('es:addGroupCommand', 'slay', "owner", function(source, args, user)
    if (GetPlayerName(tonumber(args[2]))) then
        local player = tonumber(args[2])

        -- User permission check
        TriggerEvent("es:getPlayerFromId", player, function(target)
            if (tonumber(target.permission_level) > tonumber(user.permission_level)) then
                TriggerClientEvent("chatMessage", source, "SYSTEM", { 255, 0, 0 }, "You're not allowed to target this person!")
                return
            end

            TriggerClientEvent('es_admin:kill', player)

            TriggerClientEvent('chatMessage', player, "SYSTEM", { 255, 0, 0 }, "You have been killed by ^2" .. GetPlayerName(source))
            TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Player ^2" .. GetPlayerName(player) .. "^0 has been killed.")
        end)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Incorrect player ID!")
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficienct permissions!")
end)

-- Crashing
TriggerEvent('es:addGroupCommand', 'crash', "superadmin", function(source, args, user)
    if (GetPlayerName(tonumber(args[2]))) then
        local player = tonumber(args[2])

        -- User permission check
        TriggerEvent("es:getPlayerFromId", player, function(target)
            if (tonumber(target.permission_level) > tonumber(user.permission_level)) then
                TriggerClientEvent("chatMessage", source, "SYSTEM", { 255, 0, 0 }, "You're not allowed to target this person!")
                return
            end

            TriggerClientEvent('es_admin:crash', player)

            TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Player ^2" .. GetPlayerName(player) .. "^0 has been crashed.")
        end)
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Incorrect player ID!")
    end
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficienct permissions!")
end)

-- Position
TriggerEvent('es:addGroupCommand', 'pos', "owner", function(source, args, user)
    TriggerClientEvent('es_admin:givePosition', source)
end, function(source, args, user)
    TriggerClientEvent('chatMessage', source, "SYSTEM", { 255, 0, 0 }, "Insufficienct permissions!")
end)


-- Rcon commands
AddEventHandler('rconCommand', function(commandName, args)
    if commandName == 'setadmin' then
        if #args ~= 2 then
            RconPrint("Usage: setadmin [user-id] [permission-level]\n")
            CancelEvent()
            return
        end

        if (GetPlayerName(tonumber(args[1])) == nil) then
            RconPrint("Player not ingame\n")
            CancelEvent()
            return
        end

        TriggerEvent("es:setPlayerData", tonumber(args[1]), "permission_level", tonumber(args[2]), function(response, success)
            RconPrint(response)

            if (success) then
                print(args[1] .. " " .. args[2])
                TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'rank', tonumber(args[2]), true)
                TriggerClientEvent('chatMessage', -1, "CONSOLE", { 0, 0, 0 }, "Permission level of ^2" .. GetPlayerName(tonumber(args[1])) .. "^0 has been set to ^2" .. args[2])
            end
        end)

        CancelEvent()
    elseif commandName == 'setgroup' then
        if #args ~= 2 then
            RconPrint("Usage: setgroup [user-id] [group]\n")
            CancelEvent()
            return
        end

        if (GetPlayerName(tonumber(args[1])) == nil) then
            RconPrint("Player not ingame\n")
            CancelEvent()
            return
        end

        TriggerEvent("es:getAllGroups", function(groups)

            if (groups[args[2]]) then
                TriggerEvent("es:setPlayerData", tonumber(args[1]), "group", args[2], function(response, success)
                    RconPrint(response)

                    if (success) then
                        print(args[1] .. " " .. args[2])
                        TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'group', tonumber(args[2]), true)
                        TriggerClientEvent('chatMessage', -1, "CONSOLE", { 0, 0, 0 }, "Group of ^2" .. GetPlayerName(tonumber(args[1])) .. "^0 has been set to ^2" .. args[2])
                    end
                end)
            else
                RconPrint("This group does not exist.\n")
            end
        end)

        CancelEvent()
    elseif commandName == 'setmoney' then
        if #args ~= 2 then
            RconPrint("Usage: setmoney [user-id] [money]\n")
            CancelEvent()
            return
        end

        if (GetPlayerName(tonumber(args[1])) == nil) then
            RconPrint("Player not ingame\n")
            CancelEvent()
            return
        end

        TriggerEvent("es:getPlayerFromId", tonumber(args[1]), function(user)
            if (user) then
                user:setMoney((args[2] + 0.0))

                RconPrint("Money set")
                TriggerClientEvent('chatMessage', tonumber(args[1]), "CONSOLE", { 0, 0, 0 }, "Your money has been set to: $" .. tonumber(args[2]))
            end
        end)

        CancelEvent()
    elseif commandName == 'unban' then
        if #args ~= 1 then
            RconPrint("Usage: unban [identifier]\n")
            CancelEvent()
            return
        end

        CancelEvent()
    elseif commandName == 'ban' then
        if #args ~= 1 then
            RconPrint("Usage: ban [user-id]\n")
            CancelEvent()
            return
        end

        if (GetPlayerName(tonumber(args[1])) == nil) then
            RconPrint("Player not ingame\n")
            CancelEvent()
            return
        end

        TriggerEvent("es:setPlayerData", tonumber(args[1]), "banned", 1, function(response, success)
            TriggerClientEvent('showNotify', -1, "~b~" .. GetPlayerName(player) .. "~w~ a été ~r~banni~w~ du serveur.")
        end)

        CancelEvent()
    end
end)

-- Logging
AddEventHandler("es:adminCommandRan", function(source, command)
end)

-- Custom Server Logs (Mostly to replace public Rconlog) --
RegisterServerEvent('Slog')
AddEventHandler('Slog', function(text)
    local gt = os.date('*t')
    local f,err = io.open("logs/Server-"..serverTime..".log","a")
    if not f then return print(err) end
    local h = gt['hour'] if h < 10 then h = "0"..h end
    local m = gt['min'] if m < 10 then m = "0"..m end
    local s = gt['sec'] if s < 10 then s = "0"..s end
    local formattedlog = string.format("[%s:%s:%s] %s \n",h,m,s,text)
    f:write(formattedlog)
    f:close()
    -- uncomment line below, if you need (to show all logs in console also)
    --print(formattedlog)
end)

RegisterServerEvent('Clog')
AddEventHandler('Clog', function(text)
    TriggerEvent('Slog', '[CLIENT] id: '..source..' ,name: '..GetPlayerName(source)..', info: '..text)
end)