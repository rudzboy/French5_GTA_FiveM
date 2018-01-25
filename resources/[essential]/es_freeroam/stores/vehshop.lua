--[[Register]]--

RegisterNetEvent('FinishMoneyCheckForVeh')
RegisterNetEvent('vehshop:spawnVehicle')
RegisterNetEvent('vehshop:addFreeVehicle')

--[[Local/Global]]--

local vehshop = {
    opened = false,
    title = "Vehicle Shop",
    currentmenu = "main",
    lastmenu = nil,
    currentpos = nil,
    selectedbutton = 0,
    marker = { r = 0, g = 155, b = 255, a = 200, type = 1 },
    menu = {
        x = 0.9,
        y = 0.08,
        width = 0.2,
        height = 0.04,
        buttons = 10,
        from = 1,
        to = 10,
        scale = 0.4,
        font = 0,
        ["main"] = {
            title = "CATEGORIES",
            name = "main",
            buttons = {
                { name = "Vehicles", description = "" },
                { name = "Motorcycles", description = "" },
            }
        },
        ["vehicles"] = {
            title = "VEHICLES",
            name = "vehicles",
            buttons = {
                { name = "Compacts", description = '' },
                { name = "Coupes", description = '' },
                { name = "Sedans", description = '' },
                { name = "Sports", description = '' },
                { name = "Sports Classics", description = '' },
                { name = "Super", description = '' },
                { name = "Muscle", description = '' },
                { name = "Off-Road", description = '' },
                { name = "SUVs", description = '' },
                { name = "Vans", description = '' },
                { name = "Cycles", description = '' },
            }
        },
        ["compacts"] = {
            title = "compacts",
            name = "compacts",
            buttons = {
                { name = "Blista", costs = 15000, description = {}, model = "blista" },
                { name = "Brioso R/A", costs = 85000, description = {}, model = "brioso" },
                { name = "Dilettante", costs = 25000, description = {}, model = "Dilettante" },
                { name = "Issi", costs = 18000, description = {}, model = "issi2" },
                { name = "Panto", costs = 55000, description = {}, model = "panto" },
                { name = "Prairie", costs = 30000, description = {}, model = "prairie" },
                { name = "Rhapsody", costs = 43000, description = {}, model = "rhapsody" },
            }
        },
        ["coupes"] = {
            title = "coupes",
            name = "coupes",
            buttons = {
                { name = "Cognoscenti Cabrio", costs = 180000, description = {}, model = "cogcabrio" },
                { name = "Exemplar", costs = 200000, description = {}, model = "exemplar" },
                { name = "F620", costs = 80000, description = {}, model = "f620" },
                { name = "Felon", costs = 90000, description = {}, model = "felon" },
                { name = "Felon GT", costs = 95000, description = {}, model = "felon2" },
                { name = "Jackal", costs = 60000, description = {}, model = "jackal" },
                { name = "Oracle", costs = 80000, description = {}, model = "oracle" },
                { name = "Oracle XS", costs = 82000, description = {}, model = "oracle2" },
                { name = "Sentinel", costs = 90000, description = {}, model = "sentinel" },
                { name = "Sentinel XS", costs = 60000, description = {}, model = "sentinel2" },
                { name = "Windsor", costs = 800000, description = {}, model = "windsor" },
                { name = "Windsor Drop", costs = 850000, description = {}, model = "windsor2" },
                { name = "Zion", costs = 60000, description = {}, model = "zion" },
                { name = "Zion Cabrio", costs = 65000, description = {}, model = "zion2" },
            }
        },
        ["sports"] = {
            title = "sports",
            name = "sports",
            buttons = {
                { name = "9F", costs = 120000, description = {}, model = "ninef" },
                { name = "9F Cabrio", costs = 130000, description = {}, model = "ninef2" },
                { name = "Alpha", costs = 150000, description = {}, model = "alpha" },
                { name = "Banshee", costs = 105000, description = {}, model = "banshee" },
                { name = "Bestia GTS", costs = 260000, description = {}, model = "bestiagts" },
                { name = "Blista Compact", costs = 27000, description = {}, model = "blista2" },
                { name = "Buffalo", costs = 35000, description = {}, model = "buffalo" },
                { name = "Buffalo S", costs = 96000, description = {}, model = "buffalo2" },
                { name = "Carbonizzare", costs = 195000, description = {}, model = "carbonizzare" },
                { name = "Comet", costs = 100000, description = {}, model = "comet2" },
                { name = "Coquette", costs = 138000, description = {}, model = "coquette" },
                { name = "Drift Tampa", costs = 175000, description = {}, model = "tampa2" },
                { name = "Elegy", costs = 195000, description = {}, model = "elegy" },
                { name = "Feltzer", costs = 130000, description = {}, model = "feltzer2" },
                { name = "Furore GT", costs = 274000, description = {}, model = "furoregt" },
                { name = "Fusilade", costs = 36000, description = {}, model = "fusilade" },
                { name = "Futo", costs = 26000, description = {}, model = "futo" },
                { name = "GoGo Monkey", costs = 18000, description = {}, model = "blista3" },
                { name = "Jester", costs = 240000, description = {}, model = "jester" },
                { name = "Jester(Racecar)", costs = 350000, description = {}, model = "jester2" },
                { name = "Khamelion", costs = 100000, description = {}, model = "khamelion" },
                { name = "Kuruma", costs = 95000, description = {}, model = "kuruma" },
                { name = "Lynx", costs = 197000, description = {}, model = "lynx" },
                { name = "Massacro", costs = 275000, description = {}, model = "massacro" },
                { name = "Massacro(Racecar)", costs = 385000, description = {}, model = "massacro2" },
                { name = "Omnis", costs = 335000, description = {}, model = "omnis" },
                { name = "Penumbra", costs = 24000, description = {}, model = "penumbra" },
                { name = "Rapid GT", costs = 140000, description = {}, model = "rapidgt" },
                { name = "Rapid GT Convertible", costs = 150000, description = {}, model = "rapidgt2" },
                { name = "Ruston", costs = 346000, description = {}, model = "ruston" },
                { name = "Schafter V12", costs = 140000, description = {}, model = "schafter3" },
                { name = "Specter", costs = 334000, description = {}, model = "specter" },
                { name = "Specter Custom", costs = 392000, description = {}, model = "specter2" },
                { name = "Seven 70", costs = 1120000, description = {}, model = "seven70" },
                { name = "Sultan", costs = 32000, description = {}, model = "sultan" },
                { name = "Surano", costs = 110000, description = {}, model = "surano" },
                { name = "Tropos", costs = 188000, description = {}, model = "tropos" },
                { name = "Verlierer", costs = 403000, description = {}, model = "verlierer2" },
            }
        },
        ["sportsclassics"] = {
            title = "sports classics",
            name = "sportsclassics",
            buttons = {
                { name = "Ardent", costs = 389000, description = {}, model = "ardent" },
                { name = "Casco", costs = 340000, description = {}, model = "casco" },
                { name = "Comet Classic", costs = 387000, description = {}, model = "comet3" },
                { name = "Coquette Classic", costs = 337000, description = {}, model = "coquette2" },
                { name = "Franken Stange", costs = 240000, description = {}, model = "btype2" },
                { name = "Infernus Classic", costs = 420000, description = {}, model = "infernus2" },
                { name = "JB 700", costs = 350000, description = {}, model = "jb700" },
                { name = "Manana", costs = 77000, description = {}, model = "manana" },
                { name = "Monroe", costs = 330000, description = {}, model = "monroe" },
                { name = "Pigalle", costs = 80000, description = {}, model = "pigalle" },
                { name = "Stinger", costs = 425000, description = {}, model = "stinger" },
                { name = "Stinger GT", costs = 445000, description = {}, model = "stingergt" },
                { name = "Stirling GT", costs = 485000, description = {}, model = "feltzer3" },
                { name = "Torero", costs = 356000, description = {}, model = "torero" },
                { name = "Tornado", costs = 185000, description = {}, model = "tornado" },
                { name = "Tornado RR", costs = 185000, description = {}, model = "tornado6" },
                { name = "Turismo Classic", costs = 548000, description = {}, model = "turismo2" },
                { name = "Z-Type", costs = 447000, description = {}, model = "ztype" },
            }
        },
        ["super"] = {
            title = "super",
            name = "super",
            buttons = {
                { name = "Pfister 811", costs = 375000, description = {}, model = "pfister811" },
                { name = "Adder", costs = 1000000, description = {}, model = "adder" },
                { name = "Banshee 900R", costs = 497000, description = {}, model = "banshee2" },
                { name = "Bullet", costs = 355000, description = {}, model = "bullet" },
                { name = "Cheetah", costs = 650000, description = {}, model = "cheetah" },
                { name = "Entity XF", costs = 795000, description = {}, model = "entityxf" },
                { name = "ETR1", costs = 1599500, description = {}, model = "sheava" },
                { name = "FMJ", costs = 1750000, description = {}, model = "fmj" },
                { name = "GP1", costs = 1840000, description = {}, model = "gp1" },
                { name = "Itali GTB", costs = 560000, description = {}, model = "italigtb" },
                { name = "Itali GTB Custom", costs = 666000, description = {}, model = "italigtb" },
                { name = "Infernus", costs = 440000, description = {}, model = "infernus" },
                { name = "Nero", costs = 1200000, description = {}, model = "nero" },
                { name = "Nero Custom", costs = 1680000, description = {}, model = "nero2" },
                { name = "Penetrator", costs = 840000, description = {}, model = "penetrator" },
                { name = "Osiris", costs = 997000, description = {}, model = "osiris" },
                { name = "RE-7B", costs = 1875000, description = {}, model = "le7b" },
                { name = "Reaper", costs = 1595000, description = {}, model = "reaper" },
                { name = "Sultan RS", costs = 795000, description = {}, model = "sultanrs" },
                { name = "T20", costs = 1200000, description = {}, model = "t20" },
                { name = "Tempesta", costs = 910000, description = {}, model = "tempesta" },
                { name = "Turismo R", costs = 500000, description = {}, model = "turismor" },
                { name = "Tyrus", costs = 2550000, description = {}, model = "tyrus" },
                { name = "Vacca", costs = 240000, description = {}, model = "vacca" },
                { name = "Vagner", costs = 1680000, description = {}, model = "vagner" },
                { name = "Voltic", costs = 325000, description = {}, model = "voltic" },
                { name = "X80 Proto", costs = 2700000, description = {}, model = "prototipo" },
                { name = "XA21", costs = 985000, description = {}, model = "xa21" },
                { name = "Zentorno", costs = 725000, description = {}, model = "zentorno" },
            }
        },
        ["muscle"] = {
            title = "muscle",
            name = "muscle",
            buttons = {
                { name = "Blade", costs = 43000, description = {}, model = "blade" },
                { name = "Buccaneer", costs = 29000, description = {}, model = "buccaneer" },
                { name = "Chino", costs = 60000, description = {}, model = "chino" },
                { name = "Coquette BlackFin", costs = 225000, description = {}, model = "coquette3" },
                { name = "Dominator", costs = 35000, description = {}, model = "dominator" },
                { name = "Dukes", costs = 62000, description = {}, model = "dukes" },
                { name = "Gauntlet", costs = 32000, description = {}, model = "gauntlet" },
                { name = "Hotknife", costs = 90000, description = {}, model = "hotknife" },
                { name = "Faction", costs = 36000, description = {}, model = "faction" },
                { name = "Moonbeam", costs = 56000, description = {}, model = "moonbeam" },
                { name = "Nightshade", costs = 127000, description = {}, model = "nightshade" },
                { name = "Phoenix", costs = 35500, description = {}, model = "phoenix" },
                { name = "Picador", costs = 9000, description = {}, model = "picador" },
                { name = "Ruiner", costs = 29000, description = {}, model = "ruiner" },
                { name = "Sabre Turbo", costs = 15000, description = {}, model = "sabregt" },
                { name = "Tampa", costs = 99000, description = {}, model = "tampa" },
                { name = "Virgo", costs = 110000, description = {}, model = "virgo" },
                { name = "Vigero", costs = 21000, description = {}, model = "vigero" },
            }
        },
        ["offroad"] = {
            title = "off-road",
            name = "off-road",
            buttons = {
                { name = "Bifta", costs = 32000, description = {}, model = "bifta" },
                { name = "Blazer", costs = 8000, description = {}, model = "blazer" },
                { name = "Brawler", costs = 112000, description = {}, model = "brawler" },
                { name = "Bubsta 6x6", costs = 249000, description = {}, model = "dubsta3" },
                { name = "Dune Buggy", costs = 20000, description = {}, model = "dune" },
                { name = "Kalahari", costs = 2500, description = {}, model = "Kalahari" },
                { name = "Mesa", costs = 25000, description = {}, model = "mesa" },
                { name = "Rebel", costs = 22000, description = {}, model = "rebel2" },
                { name = "Sandking", costs = 38000, description = {}, model = "sandking2" },
                { name = "Sandking XL", costs = 38000, description = {}, model = "sandking" },
                { name = "The Liberator", costs = 550000, description = {}, model = "monster" },
                { name = "Trophy Truck", costs = 225000, description = {}, model = "trophytruck" },
            }
        },
        ["suvs"] = {
            title = "suvs",
            name = "suvs",
            buttons = {
                { name = "Baller", costs = 90000, description = {}, model = "baller" },
                { name = "BeeJay", costs = 94000, description = {}, model = "bjxl" },
                { name = "Cavalcade", costs = 60000, description = {}, model = "cavalcade" },
                { name = "Contender", costs = 69000, description = {}, model = "contender" },
                { name = "Dubsta", costs = 75000, description = {}, model = "dubsta2" },
                { name = "Granger", costs = 35000, description = {}, model = "granger" },
                { name = "Habanero", costs = 39000, description = {}, model = "habanero" },
                { name = "Huntley S", costs = 195000, description = {}, model = "huntley" },
                { name = "Landstalker", costs = 58000, description = {}, model = "landstalker" },
                { name = "Patriot", costs = 95000, description = {}, model = "patriot" },
                { name = "Radius", costs = 32000, description = {}, model = "radi" },
                { name = "Rocoto", costs = 85000, description = {}, model = "rocoto" },
                { name = "Serrano", costs = 45000, description = {}, model = "serrano" },
                { name = "Seminole", costs = 30000, description = {}, model = "seminole" },
                { name = "XLS", costs = 117000, description = {}, model = "xls" },
            }
        },
        ["vans"] = {
            title = "vans",
            name = "vans",
            buttons = {
                { name = "Bison", costs = 30000, description = {}, model = "bison" },
                { name = "Bobcat XL", costs = 23000, description = {}, model = "bobcatxl" },
                { name = "Gang Burrito", costs = 65000, description = {}, model = "gburrito" },
                { name = "Camper", costs = 135000, description = {}, model = "camper" },
                { name = "Journey", costs = 15000, description = {}, model = "journey" },
                { name = "Minivan", costs = 30000, description = {}, model = "minivan" },
                { name = "Paradise", costs = 25000, description = {}, model = "paradise" },
                { name = "Rumpo", costs = 13000, description = {}, model = "rumpo" },
                { name = "Speedo", costs = 38000, description = {}, model = "speedo" },
                { name = "Surfer", costs = 11000, description = {}, model = "surfer" },
                { name = "Youga", costs = 16000, description = {}, model = "youga" },
            }
        },
        ["sedans"] = {
            title = "sedans",
            name = "sedans",
            buttons = {
                { name = "Asea", costs = 5000, description = {}, model = "asea" },
                { name = "Asterope", costs = 14000, description = {}, model = "asterope" },
                { name = "Cognoscenti", costs = 167000, description = {}, model = "cognoscenti" },
                { name = "Fugitive", costs = 24000, description = {}, model = "fugitive" },
                { name = "Glendale", costs = 200000, description = {}, model = "glendale" },
                { name = "Ingot", costs = 9000, description = {}, model = "ingot" },
                { name = "Intruder", costs = 16000, description = {}, model = "intruder" },
                { name = "Premier", costs = 10000, description = {}, model = "premier" },
                { name = "Primo", costs = 9000, description = {}, model = "primo" },
                { name = "Primo Custom", costs = 9500, description = {}, model = "primo2" },
                { name = "Regina", costs = 5000, description = {}, model = "regina" },
                { name = "Romero", costs = 48000, description = {}, model = "romero" },
                { name = "Schafter", costs = 65000, description = {}, model = "schafter2" },
                { name = "Stanier", costs = 10000, description = {}, model = "stanier" },
                { name = "Stratum", costs = 10000, description = {}, model = "stratum" },
                { name = "Stretch", costs = 30000, description = {}, model = "stretch" },
                { name = "Super Diamond", costs = 250000, description = {}, model = "superd" },
                { name = "Surge", costs = 38000, description = {}, model = "surge" },
                { name = "Tailgater", costs = 55000, description = {}, model = "tailgater" },
                { name = "Warrener", costs = 12000, description = {}, model = "warrener" },
                { name = "Washington", costs = 15000, description = {}, model = "washington" },
            }
        },
        ["motorcycles"] = {
            title = "MOTORCYCLES",
            name = "motorcycles",
            buttons = {
                { name = "Akuma", costs = 9000, description = {}, model = "AKUMA" },
                { name = "Avarus", costs = 14800, description = {}, model = "avarus" },
                { name = "Bagger", costs = 5000, description = {}, model = "bagger" },
                { name = "Bati 801", costs = 15000, description = {}, model = "bati" },
                { name = "Bati 801RR", costs = 15000, description = {}, model = "bati2" },
                -- {name = "BF400", costs = 95000, description = {}, model = "bf400"}, -- Reserved for Secret Services --
                { name = "Carbon RS", costs = 35000, description = {}, model = "carbonrs" },
                --{name = "Chimera", costs = 15200, description = {}, model = "chimera"},
                { name = "Cliffhanger", costs = 48000, description = {}, model = "cliffhanger" },
                { name = "Daemon", costs = 10900, description = {}, model = "daemon2" },
                { name = "Daemon (Lost)", costs = 10900, description = {}, model = "daemon" },
                { name = "Defiler", costs = 18700, description = {}, model = "defiler" },
                { name = "Double T", costs = 12000, description = {}, model = "double" },
                { name = "Enduro", costs = 8500, description = {}, model = "enduro" },
                { name = "Esskey", costs = 17500, description = {}, model = "esskey" },
                { name = "Faggio", costs = 4000, description = {}, model = "faggio2" },
                { name = "Gargoyle", costs = 120000, description = {}, model = "gargoyle" },
                { name = "Hakuchou", costs = 82000, description = {}, model = "hakuchou" },
                { name = "Hexer", costs = 15000, description = {}, model = "hexer" },
                { name = "Innovation", costs = 27000, description = {}, model = "innovation" },
                { name = "Lectro", costs = 13500, description = {}, model = "lectro" },
                { name = "Nemesis", costs = 12000, description = {}, model = "nemesis" },
                { name = "Nightblade", costs = 28000, description = {}, model = "nightblade" },
                { name = "Manchez", costs = 8900, description = {}, model = "manchez" },
                { name = "PCJ-600", costs = 9000, description = {}, model = "pcj" },
                { name = "Ruffian", costs = 9000, description = {}, model = "ruffian" },
                { name = "Rat Bike", costs = 9000, description = {}, model = "ratbike" },
                { name = "Sanchez", costs = 7000, description = {}, model = "sanchez" },
                { name = "Sanctus", costs = 2900000, description = {}, model = "sanctus" },
                { name = "Shotaro", costs = 370000, description = {}, model = "shotaro" },
                { name = "Sovereign", costs = 90000, description = {}, model = "sovereign" },
                { name = "Thrust", costs = 75000, description = {}, model = "thrust" },
                { name = "Vader", costs = 9000, description = {}, model = "vader" },
                { name = "Vindicator", costs = 95000, description = {}, model = "vindicator" },
                { name = "Wolfsbane", costs = 16800, description = {}, model = "wolfsbane" },
                { name = "Zombie Bobber", costs = 16800, description = {}, model = "zombiea" },
                { name = "Zombie Chopper", costs = 16750, description = {}, model = "zombieb" },
            }
        },
    }
}

local fakecar = { model = '', car = nil }
local vehshop_locations = { { entering = { -33.803, -1102.322, 25.422 }, inside = { -46.56327, -1097.382, 25.99875, 120.1953 }, outside = { -31.849, -1090.648, 25.998, 322.345 } } }
local vehshop_blips = {}
local inrangeofvehshop = false
local currentlocation = nil
local boughtcar = false
local vehicle_price = 0
local backlock = false
local firstspawn = 0



--[[Functions]]--

function LocalPed()
    return GetPlayerPed(-1)
end

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function IsPlayerInRangeOfVehshop()
    return inrangeofvehshop
end

function ShowVehshopBlips(bool)
    if bool and #vehshop_blips == 0 then
        for station, pos in pairs(vehshop_locations) do
            local loc = pos
            pos = pos.entering
            local blip = AddBlipForCoord(pos[1], pos[2], pos[3])
            -- 60 58 137
            SetBlipSprite(blip, 326)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Concessionnaire')
            EndTextCommandSetBlipName(blip)
            SetBlipColour(blip, 69)
            SetBlipAsShortRange(blip, true)
            SetBlipAsMissionCreatorBlip(blip, true)
            table.insert(vehshop_blips, { blip = blip, pos = loc })
        end
        Citizen.CreateThread(function()
            while #vehshop_blips > 0 do
                Citizen.Wait(0)
                local inrange = false
                for i, b in ipairs(vehshop_blips) do
                    DrawMarker(1, b.pos.entering[1], b.pos.entering[2], b.pos.entering[3], 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
                    if vehshop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and GetDistanceBetweenCoords(b.pos.entering[1], b.pos.entering[2], b.pos.entering[3], GetEntityCoords(LocalPed())) < 5 then
                        drawTxt('Appuyer sur ~g~Entrée~s~ pour accéder au menu d\'achat', 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)
                        currentlocation = b
                        inrange = true
                    end
                end
                inrangeofvehshop = inrange
            end
        end)
    elseif bool == false and #vehshop_blips > 0 then
        for i, b in ipairs(vehshop_blips) do
            if DoesBlipExist(b.blip) then
                SetBlipAsMissionCreatorBlip(b.blip, false)
                Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
            end
        end
        vehshop_blips = {}
    end
end

function f(n)
    return n + 0.0001
end

function try(f, catch_f)
    local status, exception = pcall(f)
    if not status then
        catch_f(exception)
    end
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function OpenCreator()
    boughtcar = false
    local ped = LocalPed()
    local pos = currentlocation.pos.inside
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false)
    local g = Citizen.InvokeNative(0xC906A7DAB05C8D2B, pos[1], pos[2], pos[3], Citizen.PointerValueFloat(), 0)
    SetEntityCoords(ped, pos[1], pos[2], g)
    SetEntityHeading(ped, pos[4])
    vehshop.currentmenu = "main"
    vehshop.opened = true
    vehshop.selectedbutton = 0
end

function CloseCreator(name, veh, price)
    Citizen.CreateThread(function()
        local ped = LocalPed()
        if not boughtcar then
            local pos = currentlocation.pos.entering
            SetEntityCoords(ped, pos[1], pos[2], pos[3])
            FreezeEntityPosition(ped, false)
            SetEntityVisible(ped, true)
        else
            local name = name
            local vehicle = veh
            local price = price
            local veh = GetVehiclePedIsUsing(ped)
            local model = GetEntityModel(veh)
            local colors = table.pack(GetVehicleColours(veh))
            local extra_colors = table.pack(GetVehicleExtraColours(veh))

            local mods = {}
            for i = 0, 24 do
                mods[i] = GetVehicleMod(veh, i)
            end
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(veh))
            local pos = currentlocation.pos.outside

            FreezeEntityPosition(ped, false)
            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(0)
            end
            personalVehicle = CreateVehicle(model, pos[1], pos[2], pos[3], pos[4], true, false)
            SetModelAsNoLongerNeeded(model)
            for i, mod in pairs(mods) do
                SetVehicleModKit(personalVehicle, 0)
                SetVehicleMod(personalVehicle, i, mod)
            end
            SetVehicleOnGroundProperly(personalVehicle)
            local plate = GetVehicleNumberPlateText(personalVehicle)
            SetVehicleHasBeenOwnedByPlayer(personalVehicle, true)
            local id = NetworkGetNetworkIdFromEntity(personalVehicle)
            SetNetworkIdCanMigrate(id, true)
            Citizen.InvokeNative(0x629BFA74418D6239, Citizen.PointerValueIntInitialized(personalVehicle))
            SetVehicleColours(personalVehicle, colors[1], colors[2])
            SetVehicleExtraColours(personalVehicle, extra_colors[1], extra_colors[2])
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), personalVehicle, -1)
            TriggerEvent("garages:setPersonalVehicle", personalVehicle)
            SetEntityVisible(ped, true)
            local primarycolor = colors[1]
            local secondarycolor = colors[2]
            local pearlescentcolor = extra_colors[1]
            local wheelcolor = extra_colors[2]
            TriggerServerEvent('BuyForVeh', name, vehicle, price, plate, primarycolor, secondarycolor, pearlescentcolor, wheelcolor)
        end
        vehshop.opened = false
        vehshop.menu.from = 1
        vehshop.menu.to = 10
    end)
end

function drawMenuButton(button, x, y, selected)
    local menu = vehshop.menu
    SetTextFont(menu.font)
    SetTextProportional(0)
    SetTextScale(menu.scale, menu.scale)
    if selected then
        SetTextColour(0, 0, 0, 255)
    else
        SetTextColour(255, 255, 255, 255)
    end
    SetTextCentre(0)
    SetTextEntry("STRING")
    AddTextComponentString(button.name)
    if selected then
        DrawRect(x, y, menu.width, menu.height, 255, 255, 255, 255)
    else
        DrawRect(x, y, menu.width, menu.height, 0, 0, 0, 150)
    end
    DrawText(x - menu.width / 2 + 0.005, y - menu.height / 2 + 0.0028)
end

function drawMenuInfo(text)
    local menu = vehshop.menu
    SetTextFont(menu.font)
    SetTextProportional(0)
    SetTextScale(0.45, 0.45)
    SetTextColour(255, 255, 255, 255)
    SetTextCentre(0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawRect(0.675, 0.95, 0.65, 0.050, 0, 0, 0, 150)
    DrawText(0.365, 0.934)
end

function drawMenuRight(txt, x, y, selected)
    local menu = vehshop.menu
    SetTextFont(menu.font)
    SetTextProportional(0)
    SetTextScale(menu.scale, menu.scale)
    SetTextRightJustify(1)
    if selected then
        SetTextColour(0, 0, 0, 255)
    else
        SetTextColour(255, 255, 255, 255)
    end
    SetTextCentre(0)
    SetTextEntry("STRING")
    AddTextComponentString(txt)
    DrawText(x + menu.width / 2 - 0.03, y - menu.height / 2 + 0.0028)
end

function drawMenuTitle(txt, x, y)
    local menu = vehshop.menu
    SetTextFont(2)
    SetTextProportional(0)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    AddTextComponentString(txt)
    DrawRect(x, y, menu.width, menu.height, 0, 0, 0, 150)
    DrawText(x - menu.width / 2 + 0.005, y - menu.height / 2 + 0.0028)
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function drawNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function DoesPlayerHaveVehicle(model, button, y, selected)
    local t = false
    --TODO:check if player own car
    if t then
        drawMenuRight("OWNED", vehshop.menu.x, y, selected)
    else
        drawMenuRight(button.costs .. "$", vehshop.menu.x, y, selected)
    end
end

function stringstarts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function round(num, idp)
    if idp and idp > 0 then
        local mult = 10 ^ idp
        return math.floor(num * mult + 0.5) / mult
    end
    return math.floor(num + 0.5)
end

function ButtonSelected(button)
    local ped = GetPlayerPed(-1)
    local this = vehshop.currentmenu
    local btn = button.name
    if this == "main" then
        if btn == "Vehicles" then
            OpenMenu('vehicles')
        elseif btn == "Motorcycles" then
            OpenMenu('motorcycles')
        end
    elseif this == "vehicles" then
        if btn == "Sports" then
            OpenMenu('sports')
        elseif btn == "Sedans" then
            OpenMenu('sedans')
        elseif btn == "Compacts" then
            OpenMenu('compacts')
        elseif btn == "Coupes" then
            OpenMenu('coupes')
        elseif btn == "Sports Classics" then
            OpenMenu("sportsclassics")
        elseif btn == "Super" then
            OpenMenu('super')
        elseif btn == "Muscle" then
            OpenMenu('muscle')
        elseif btn == "Off-Road" then
            OpenMenu('offroad')
        elseif btn == "SUVs" then
            OpenMenu('suvs')
        elseif btn == "Vans" then
            OpenMenu('vans')
        end
    elseif this == "compacts" or this == "coupes" or this == "sedans" or this == "sports" or this == "sportsclassics" or this == "super" or this == "muscle" or this == "offroad" or this == "suvs" or this == "vans" or this == "industrial" or this == "cycles" or this == "motorcycles" then
        TriggerServerEvent('CheckMoneyForVeh', button.name, button.model, button.costs)
    end
end

function OpenMenu(menu)
    fakecar = { model = '', car = nil }
    vehshop.lastmenu = vehshop.currentmenu
    if menu == "vehicles" then
        vehshop.lastmenu = "main"
    elseif menu == "bikes" then
        vehshop.lastmenu = "main"
    elseif menu == 'race_create_objects' then
        vehshop.lastmenu = "main"
    elseif menu == "race_create_objects_spawn" then
        vehshop.lastmenu = "race_create_objects"
    end
    vehshop.menu.from = 1
    vehshop.menu.to = 10
    vehshop.selectedbutton = 0
    vehshop.currentmenu = menu
end

function Back()
    if backlock then
        return
    end
    backlock = true
    if vehshop.currentmenu == "main" then
        CloseCreator()
    elseif vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
        if DoesEntityExist(fakecar.car) then
            Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
        end
        fakecar = { model = '', car = nil }
        OpenMenu(vehshop.lastmenu)
    else
        OpenMenu(vehshop.lastmenu)
    end
end

--[[Citizen]]--

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(1, 201) and IsPlayerInRangeOfVehshop() then
            if vehshop.opened then
                CloseCreator()
            else
                OpenCreator()
            end
        end
        if vehshop.opened then
            local ped = LocalPed()
            local menu = vehshop.menu[vehshop.currentmenu]
            drawTxt(vehshop.title, 1, 1, vehshop.menu.x, vehshop.menu.y, 1.0, 255, 255, 255, 255)
            drawMenuTitle(menu.title, vehshop.menu.x, vehshop.menu.y + 0.08)
            drawTxt(vehshop.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, vehshop.menu.x + vehshop.menu.width / 2 - 0.0385, vehshop.menu.y + 0.067, 0.4, 255, 255, 255, 255)
            local y = vehshop.menu.y + 0.12
            buttoncount = tablelength(menu.buttons)
            local selected = false

            for i, button in pairs(menu.buttons) do
                if i >= vehshop.menu.from and i <= vehshop.menu.to then

                    if i == vehshop.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button, vehshop.menu.x, y, selected)
                    if button.costs ~= nil then
                        if vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
                            DoesPlayerHaveVehicle(button.model, button, y, selected)
                        else
                            drawMenuRight(button.costs .. "$", vehshop.menu.x, y, selected)
                        end
                    end
                    y = y + 0.04
                    if vehshop.currentmenu == "compacts" or vehshop.currentmenu == "coupes" or vehshop.currentmenu == "sedans" or vehshop.currentmenu == "sports" or vehshop.currentmenu == "sportsclassics" or vehshop.currentmenu == "super" or vehshop.currentmenu == "muscle" or vehshop.currentmenu == "offroad" or vehshop.currentmenu == "suvs" or vehshop.currentmenu == "vans" or vehshop.currentmenu == "industrial" or vehshop.currentmenu == "cycles" or vehshop.currentmenu == "motorcycles" then
                        if selected then
                            if fakecar.model ~= button.model then
                                if DoesEntityExist(fakecar.car) then
                                    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(fakecar.car))
                                end
                                local pos = currentlocation.pos.inside
                                local hash = GetHashKey(button.model)
                                RequestModel(hash)
                                while not HasModelLoaded(hash) do
                                    Citizen.Wait(0)
                                    drawTxt("~b~Loading...", 0, 1, 0.5, 0.5, 1.5, 255, 255, 255, 255)
                                end
                                local veh = CreateVehicle(hash, pos[1], pos[2], pos[3], pos[4], false, false)
                                while not DoesEntityExist(veh) do
                                    Citizen.Wait(0)
                                    drawTxt("~b~Loading...", 0, 1, 0.5, 0.5, 1.5, 255, 255, 255, 255)
                                end
                                FreezeEntityPosition(veh, true)
                                SetEntityInvincible(veh, true)
                                SetVehicleDoorsLocked(veh, 4)
                                --SetEntityCollision(veh,false,false)
                                TaskWarpPedIntoVehicle(LocalPed(), veh, -1)
                                for i = 0, 24 do
                                    SetVehicleModKit(veh, 0)
                                    RemoveVehicleMod(veh, i)
                                end
                                fakecar = { model = button.model, car = veh }
                            end
                        end
                    end
                    if selected and IsControlJustPressed(1, 201) then
                        ButtonSelected(button)
                    end
                end
            end
        end
        if vehshop.opened then
            if IsControlJustPressed(1, 202) then
                Back()
            end
            if IsControlJustReleased(1, 202) then
                backlock = false
            end
            if IsControlJustPressed(1, 188) then
                if vehshop.selectedbutton > 1 then
                    vehshop.selectedbutton = vehshop.selectedbutton - 1
                    if buttoncount > 10 and vehshop.selectedbutton < vehshop.menu.from then
                        vehshop.menu.from = vehshop.menu.from - 1
                        vehshop.menu.to = vehshop.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1, 187) then
                if vehshop.selectedbutton < buttoncount then
                    vehshop.selectedbutton = vehshop.selectedbutton + 1
                    if buttoncount > 10 and vehshop.selectedbutton > vehshop.menu.to then
                        vehshop.menu.to = vehshop.menu.to + 1
                        vehshop.menu.from = vehshop.menu.from + 1
                    end
                end
            end
        end
    end
end)

AddEventHandler('FinishMoneyCheckForVeh', function(name, vehicle, price)
    local name = name
    local vehicle = vehicle
    local price = price
    boughtcar = true
    CloseCreator(name, vehicle, price)
end)

AddEventHandler('playerSpawned', function(spawn)
    if firstspawn == 0 then
        --326 car blip 227 225
        ShowVehshopBlips(true)
        firstspawn = 1
    end
end)

AddEventHandler('vehshop:addFreeVehicle', function()
    TriggerServerEvent('vehshop:addFreeVehicle')
    TriggerEvent('showNotify', "Le gouvernement vous a mis un ~b~véhicule~w~ à disposition dans un ~b~garage~w~.")
end)

AddEventHandler('vehshop:spawnVehicle', function(v)
    local car = GetHashKey(v)
    local playerPed = GetPlayerPed(-1)
    if playerPed and playerPed ~= -1 then
        RequestModel(car)
        while not HasModelLoaded(car) do
            Citizen.Wait(0)
        end
        local playerCoords = GetEntityCoords(playerPed)
        veh = CreateVehicle(car, playerCoords, 0.0, true, false)
        TaskWarpPedIntoVehicle(playerPed, veh, -1)
        SetEntityInvincible(veh, true)
    end
end)

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
    if firstspawn == 0 then
        RemoveIpl('v_carshowroom')
        RemoveIpl('shutter_open')
        RemoveIpl('shutter_closed')
        RemoveIpl('shr_int')
        RemoveIpl('csr_inMission')
        RequestIpl('v_carshowroom')
        RequestIpl('shr_int')
        RequestIpl('shutter_closed')
        firstspawn = 1
    end
end)
