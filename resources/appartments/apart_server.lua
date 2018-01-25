require "resources/mysql-async/lib/MySQL"

local interiors = {
    --    [1] = { ["price"] = 150000, ["xe"] = 1394.48278808594, ["ye"] = 1141.74035644531, ["ze"] = 114.606857299805, ["he"] = 0.000, ["xo"] = 1397.33056640625, ["yo"] = 1142.05017089844, ["zo"] = 114.333587646484, ["ho"] = 0.000, ["name"] = 'Ranch Main'},
    --    [2] = { ["price"] = 150000, ["xe"] = 1400.36584472656, ["ye"] = 1127.14978027344, ["ze"] = 114.334297180176, ["he"] = 0.000, ["xo"] = 1400.05810546875, ["yo"] = 1128.62951660156, ["zo"] = 114.334289550781, ["ho"] = 0.000, ["name"] = 'Ranche side'},
    [1] = { ["price"] = 172500, ["xe"] = -1910.7265625, ["ye"] = -576.919189453125, ["ze"] = 19.0969314575195, ["he"] = 0.00, ["xo"] = -1910.099609375, ["yo"] = -574.97265625, ["zo"] = 19.0956039428711, ["ho"] = 0.00, ["name"] = 'Bureau sur Plage 1' },
    [2] = { ["price"] = 735500, ["xe"] = -283.457214355469, ["ye"] = -940.855529785156, ["ze"] = 31.2185655564484, ["he"] = 0.00, ["xo"] = -270.538421630859, ["yo"] = -940.73974609375, ["zo"] = 92.5109481811523, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 1' },
    [3] = { ["price"] = 697500, ["xe"] = -44.6460037231445, ["ye"] = -587.163024902344, ["ze"] = 38.1613159179688, ["he"] = 0.00, ["xo"] = -30.8175601959229, ["yo"] = -595.315246582031, ["zo"] = 80.030891418457, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 2' },
    [4] = { ["price"] = 698500, ["xe"] = -43.9314346313477, ["ye"] = -584.379028320313, ["ze"] = 38.1618614196777, ["he"] = 0.00, ["xo"] = -18.1004009246826, ["yo"] = -590.620544433594, ["zo"] = 90.1148223876953, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 3' },
    [5] = { ["price"] = 698500, ["xe"] = -480.583343505859, ["ye"] = -688.393371582031, ["ze"] = 33.2119483947754, ["he"] = 0.00, ["xo"] = -466.607604980469, ["yo"] = -708.706115722656, ["zo"] = 77.0869216918945, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 4' },
    --    [8] = { ["price"] = 150000, ["xe"] = -796.283264160156, ["ye"] = 336.186981201172, ["ze"] = 85.7004165649414, ["he"] = 0.00, ["xo"] = -784.695556640625, ["yo"] = 323.346374511719, ["zo"] = 211.997192382813, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 5'},
    --    [9] = { ["price"] = 150000, ["xe"] = 414.587738037109, ["ye"] = -217.593215942383, ["ze"] = 59.9104766845703, ["he"] = 0.00, ["xo"] = 426.823150634766, ["yo"] = -255.383087158203, ["zo"] = 71.2514114379883, ["ho"] = 0.00, ["name"] = 'Terrasse Hotel'},
    --    [10] = { ["price"] = 150000, ["xe"] = -98.5413970947266, ["ye"] = 367.420593261719, ["ze"] = 113.274826049805, ["he"] = 0.00, ["xo"] = -101.87483215332, ["yo"] = 372.153594970703, ["zo"] = 142.680328369141, ["ho"] = 0.00, ["name"] = 'Terrasse C'},
    --    [11] = { ["price"] = 150000, ["xe"] = -107.244064331055, ["ye"] = 369.226196289063, ["ze"] = 112.880752563477, ["he"] = 0.00, ["xo"] = -88.3965454101563, ["yo"] = 324.328125, ["zo"] = 142.599212646484, ["ho"] = 0.00, ["name"] = 'Terrasse B'},
    --    [12] = { ["price"] = 150000, ["xe"] = -116.21142578125, ["ye"] = 372.935424804688, ["ze"] = 112.88077545166, ["he"] = 0.00, ["xo"] = -93.2163009643555, ["yo"] = 316.106872558594, ["zo"] = 136.855270385742, ["ho"] = 0.00, ["name"] = 'Terrasse A'},
    [6] = { ["price"] = 654000, ["xe"] = 119.249359130859, ["ye"] = 564.305969238281, ["ze"] = 183.96142578125, ["he"] = 0.00, ["xo"] = 117.411087036133, ["yo"] = 559.382934570313, ["zo"] = 184.30485534668, ["ho"] = 0.00, ["name"] = 'House Premium 1' },
    [7] = { ["price"] = 651000, ["xe"] = 374.177398681641, ["ye"] = 427.730651855469, ["ze"] = 145.684204101563, ["he"] = 0.00, ["xo"] = 373.5234375, ["yo"] = 423.222930908203, ["zo"] = 145.90788269043, ["ho"] = 0.00, ["name"] = 'House Premium 2' },
    [8] = { ["price"] = 657000, ["xe"] = -174.349594116211, ["ye"] = 502.55615234375, ["ze"] = 137.42024230957, ["he"] = 0.00, ["xo"] = -174.111358642578, ["yo"] = 497.260223388672, ["zo"] = 137.661056518555, ["ho"] = 0.00, ["name"] = 'House Premium 3' },
    [9] = { ["price"] = 658000, ["xe"] = 346.176666259766, ["ye"] = 440.199554443359, ["ze"] = 148.08430480957, ["he"] = 0.00, ["xo"] = 341.693542480469, ["yo"] = 437.470153808594, ["zo"] = 149.387069702148, ["ho"] = 0.00, ["name"] = 'House Premium 4' },
    --    [17] = { ["price"] = 150000, ["xe"] = -1910.7265625, ["ye"] = -576.919189453125, ["ze"] = 19.0969314575195, ["he"] = 0.00, ["xo"] = -1910.099609375, ["yo"] = -574.97265625, ["zo"] = 19.0956039428711, ["ho"] = 0.00, ["name"] = 'Bureau Sur Plage 2'},
    [18] = { ["price"] = 695900, ["xe"] = -635.626892089844, ["ye"] = 44.2951354980469, ["ze"] = 42.6980400085449, ["he"] = 0.00, ["xo"] = -603.831115722656, ["yo"] = 58.761058807373, ["zo"] = 98.2002182006836, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 6' },
    [19] = { ["price"] = 789000, ["xe"] = -776.924255371094, ["ye"] = 318.661376953125, ["ze"] = 85.6626510620117, ["he"] = 0.00, ["xo"] = -781.977478027344, ["yo"] = 325.327331542969, ["zo"] = 176.803680419922, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 7' },
    [20] = { ["price"] = 735000, ["xe"] = -1581.46313476563, ["ye"] = -558.558898925781, ["ze"] = 34.9528388977051, ["he"] = 0.00, ["xo"] = -1581.21960449219, ["yo"] = -561.3564453125, ["zo"] = 108.523002624512, ["ho"] = 0.00, ["name"] = 'Bureau du Gouverneur' },
    [21] = { ["price"] = 535800, ["xe"] = -1443.81750488281, ["ye"] = -536.080017089844, ["ze"] = 34.7401390075684, ["he"] = 0.00, ["xo"] = -1452.44152832031, ["yo"] = -540.203552246094, ["zo"] = 74.0443572998047, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 8' },
    --    [22] = { ["price"] = 150000, ["xe"] = -1454.64892578125, ["ye"] = -513.301879882813, ["ze"] = 31.5818099975586, ["he"] = 0.00, ["xo"] = -1452.44152832031, ["yo"] = -540.203552246094, ["zo"] = 74.0443572998047, ["ho"] = 0.00, ["name"] = 'Par Stationnement 1'},
    [10] = { ["price"] = 755400, ["xe"] = -1450.7607421875, ["ye"] = -540.988159179688, ["ze"] = 34.7401390075684, ["he"] = 0.00, ["xo"] = -1450.5263671875, ["yo"] = -525.1552734375, ["zo"] = 69.5566940307617, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 9' },
    --    [24] = { ["price"] = 150000, ["xe"] = -1456.5302734375, ["ye"] = -514.073425292969, ["ze"] = 31.5818099975586, ["he"] = 0.00, ["xo"] = -1450.5263671875, ["yo"] = -525.1552734375, ["zo"] = 69.5566940307617, ["ho"] = 0.00, ["name"] = 'Par Stationnement 2'},
    [11] = { ["price"] = 755900, ["xe"] = -1447.42456054688, ["ye"] = -537.894348144531, ["ze"] = 34.7402763366699, ["he"] = 0.00, ["xo"] = -1450.43359375, ["yo"] = -525.057312011719, ["zo"] = 56.9289970397949, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 10' },
    --    [26] = { ["price"] = 150000, ["xe"] = -1458.28088378906, ["ye"] = -515.629211425781, ["ze"] = 31.5818099975586, ["he"] = 0.00, ["xo"] = -1450.43359375, ["yo"] = -525.057312011719, ["zo"] = 56.9289970397949, ["ho"] = 0.00, ["name"] = 'Par Stationnement 3'},
    [12] = { ["price"] = 735400, ["xe"] = -889.443298339844, ["ye"] = -333.081909179688, ["ze"] = 34.6838188171387, ["he"] = 0.00, ["xo"] = -912.898193359375, ["yo"] = -365.340240478516, ["zo"] = 114.274772644043, ["ho"] = 0.00, ["name"] = 'Condo de Luxe' },
    --    [28] = { ["price"] = 150000, ["xe"] = -908.367492675781, ["ye"] = -368.992370605469, ["ze"] = 113.074188232422, ["he"] = 0.00, ["xo"] = -903.132080078125, ["yo"] = -369.993041992188, ["zo"] = 136.2822265625, ["ho"] = 0.00, ["name"] = 'Helipad'},
    [13] = { ["price"] = 780900, ["xe"] = -901.707275390625, ["ye"] = -339.162506103516, ["ze"] = 34.6806182861328, ["he"] = 0.00, ["xo"] = -907.419128417969, ["yo"] = -371.880340576172, ["zo"] = 109.44034576416, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 11' },
    [14] = { ["price"] = 750000, ["xe"] = -894.848999023438, ["ye"] = -353.67626953125, ["ze"] = 34.6796798706055, ["he"] = 0.00, ["xo"] = -922.5458984375, ["yo"] = -379.319671630859, ["zo"] = 85.4805603027344, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 12' },
    [15] = { ["price"] = 785500, ["xe"] = -844.5498046875, ["ye"] = -391.217437744141, ["ze"] = 31.4693260192871, ["he"] = 0.00, ["xo"] = -907.26611328125, ["yo"] = -454.278350830078, ["zo"] = 126.534423828125, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 13' },
    [16] = { ["price"] = 765500, ["xe"] = -837.708801269531, ["ye"] = -405.888824462891, ["ze"] = 31.4716987609863, ["he"] = 0.00, ["xo"] = -890.076171875, ["yo"] = -452.320587158203, ["zo"] = 95.4610977172852, ["ho"] = 0.00, ["name"] = 'Condo de Luxe 14' },
    --    [33] = { ["price"] = 150000, ["xe"] = -3093.06884765625, ["ye"] = 349.211853027344, ["ze"] = 7.53054094314575, ["he"] = 0.00, ["xo"] = -3094.15478515625, ["yo"] = 339.901702880859, ["zo"] = 10.8038291931152, ["ho"] = 0.00, ["name"] = 'Appartement plage 1er'},
    --    [34] = { ["price"] = 150000, ["xe"] = -3100.38256835938, ["ye"] = 360.864776611328, ["ze"] = 7.59101963043213, ["he"] = 0.00, ["xo"] = -3094.47314453125, ["yo"] = 340.733428955078, ["zo"] = 14.4392118453979, ["ho"] = 0.00, ["name"] = 'Appartement plage 2e'},
    --    [35] = { ["price"] = 150000, ["xe"] = 80.8491439819336, ["ye"] = 6643.9287109375, ["ze"] = 31.9288063049316, ["he"] = 0.00, ["xo"] = 82.4307098388672, ["yo"] = 6645.13037109375, ["zo"] = 31.9326190948486, ["ho"] = 0.00, ["name"] = 'Grange de Fortune 1'},
    --    [36] = { ["price"] = 150000, ["xe"] = 1929.818359375, ["ye"] = 4635.51953125, ["ze"] = 40.4547843933105, ["he"] = 0.00, ["xo"] = 1930.04479980469, ["yo"] = 4633.390625, ["zo"] = 40.4920272827148, ["ho"] = 0.00, ["name"] = 'Grange de Fortune 2'},
    [17] = { ["price"] = 150000, ["xe"] = -1565.64587402344, ["ye"] = -575.688049316406, ["ze"] = 108.522987365723, ["he"] = 0.00, ["xo"] = -1570.009765625, ["yo"] = -576.172729492188, ["zo"] = 114.449279785156, ["ho"] = 0.00, ["name"] = 'Gouverneur Helipad' },
}

local lang = 'fr'
local txt = {
    ['fr'] = {
        ['welcome'] = '~g~Bienvenue~w~ dans votre ~y~appartement~w~ !\n',
        ['nocash'] = 'Vous n\'avez ~r~pas assez~w~ d\'argent !\n',
        ['estVendu'] = 'Appartement vendu !\n'
    }
}

local isBuy = 0

RegisterServerEvent("apart:getAppart")
AddEventHandler('apart:getAppart', function(name)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local name = name
        MySQL.Async.fetchAll("SELECT * FROM user_appartement WHERE name = @nom", { ['@nom'] = tostring(name) }, function(result)
            if (result) then
                count = 0
                for _ in pairs(result) do
                    count = count + 1
                end
                if count > 0 then
                    if (result[1].identifier == player) then
                        TriggerClientEvent('apart:isMine', source)
                    else
                        TriggerClientEvent('apart:isBuy', source)
                    end
                else
                    TriggerClientEvent('apart:isNotBuy', source)
                end
            end
        end)
    end)
end)




RegisterServerEvent("apart:buyAppart")
AddEventHandler('apart:buyAppart', function(name, price)
    TriggerEvent("es:getPlayerFromId", source, function(user)
        local player = user.identifier
        local price = price
        if (tonumber(user.money) >= tonumber(price)) then
            user:removeMoney(tonumber(price))
            MySQL.Async.execute("INSERT INTO user_appartement (`identifier`, `name`, `price`) VALUES (@username, @name, @price)",
                { ['@username'] = tostring(player), ['@name'] = name, ['@price'] = price })
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "LS Immobilier", false, txt[lang]['welcome'])
            TriggerClientEvent('apart:isMine', source)
        else
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "LS Immobilier", false, txt[lang]['nocash'])
        end
    end)
end)

RegisterServerEvent("apart:sellAppart")
AddEventHandler('apart:sellAppart', function(name, price)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local name = name
        user:addMoney((price / 2))
        MySQL.Async.execute("DELETE FROM `user_appartement` WHERE `identifier` = @username AND `name` = @name", { ['@username'] = player, ['@name'] = name })
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "LS Immobilier", false, txt[lang]['estVendu'])
        TriggerClientEvent('apart:isNotBuy', source)
    end)
end)

RegisterServerEvent("apart:sendData_s")
AddEventHandler("apart:sendData_s", function()
    TriggerClientEvent("apart:f_sendData", source, interiors)
end)