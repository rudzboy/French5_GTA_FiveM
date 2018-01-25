--PNJ-Strores--
local pedweapshop = {
    { type = 6, hash = 0x9E08633D, x = 1692.8857421875, y = 3762.1149902344, z = 33.705307006836, a = 210.0 },
    { type = 6, hash = 0x9E08633D, x = -330.76327514648, y = 6086.203125, z = 30.45475769043, a = 210.0 },
    { type = 6, hash = 0x9E08633D, x = 253.68670654297, y = -51.988189697266, z = 68.941040039063, a = 80.0 },
    { type = 6, hash = 0x9E08633D, x = -1304.3062744141, y = -396.08514404297, z = 35.695755004883, a = 80.0 },
    { type = 6, hash = 0x9E08633D, x = -661.00720214844, y = -933.48706054688, z = 20.829212188721, a = 210.0 },
    { type = 6, hash = 0x9E08633D, x = 808.77386474609, y = -2159.1823730469, z = 28.619020462036, a = 355.0 },
    { type = 6, hash = 0x9E08633D, x = 23.830430984497, y = -1105.7766113281, z = 28.797031402588, a = 160.0 },
    { type = 6, hash = 0x9E08633D, x = -1118.1455078125, y = 2700.6569824219, z = 17.554151535034, a = 210.0 },
    { type = 6, hash = 0x9E08633D, x = 841.23712158203, y = -1035.4903564453, z = 27.19486618042, a = 0.0 },
    { type = 6, hash = 0x9E08633D, x = 2566.7258300781, y = 292.41482543945, z = 107.73485565186, a = 0.0 },
    { type = 6, hash = 0x9E08633D, x = -3173.2248535156, y = 1089.5948486328, z = 19.838748931885, a = 240.0 },
}
Citizen.CreateThread(function()

    RequestModel(0x9E08633D)
    while not HasModelLoaded(0x9E08633D) do
        Wait(1)
    end
    -- Spawn the peds in the shops
    for _, item in pairs(pedweapshop) do
        pedweapshop = CreatePed(item.type, item.hash, item.x, item.y, item.z, item.a, false, true)
        SetPedCombatAttributes(pedweapshop, 46, true)
        SetPedFleeAttributes(pedweapshop, 0, 0)
        SetPedArmour(pedweapshop, 500)
        SetPedMaxHealth(pedweapshop, 500)
        SetPedCanRagdoll(pedweapshop, true)
        SetPedDiesWhenInjured(pedweapshop, true)
        SetBlockingOfNonTemporaryEvents(pedweapshop, false)
    end
end)
----------------------

local weashop = {
    opened = false,
    title = "Armurerie",
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
                { title = "Armes de mêlée", name = "Melee", description = "" },
                { title = "Pistolets", name = "Pistolets", description = "" },
                { title = "Mitrailleuses", name = "MachineGuns", description = "" },
                { title = "Fusils à pompe", name = "Shotguns", description = "" },
                { title = "Fusils d\'assault", name = "AssaultRifles", description = "" },
                { title = "Fusils de précision", name = "SniperRifles", description = "" },
                -- { title = "Armes lourdes", name = "HeavyWeapons", description = "" },
                { title = "Armes de lancer", name = "ThrownWeapons", description = "" },
            }
        },
        ["Melee"] = {
            title = "Armes de melee",
            name = "Melee",
            buttons = {
                { title = "Couteau", name = "Knife", costs = 150, description = {}, model = "WEAPON_Knife" },
                --	{title = "Nightstick", name = "Nightstick", costs = 25000, description = {}, model = "WEAPON_Nightstick"},
                { title = "Marteau", name = "Hammer", costs = 75, description = {}, model = "WEAPON_HAMMER" },
                { title = "Batte de baseball", name = "Bat", costs = 50, description = {}, model = "WEAPON_Bat" },
                { title = "Pied-de-biche", name = "Crowbar", costs = 100, description = {}, model = "WEAPON_Crowbar" },
                { title = "Club de golf", name = "Golfclub", costs = 150, description = {}, model = "WEAPON_Golfclub" },
                --	{title = "Bottle", name = "Bottle", costs = 120000, description = {}, model = "WEAPON_Bottle"},
                { title = "Dague antique", name = "Dagger", costs = 500, description = {}, model = "WEAPON_Dagger" },
                { title = "Hachette", name = "Hatchet", costs = 100, description = {}, model = "WEAPON_Hatchet" },
                { title = "Machette", name = "Machete", costs = 100, description = {}, model = "WEAPON_Machete" },
                --{title = "Flashlight", name = "Flashlight", costs = 20, description = {}, model = "WEAPON_Flashlight"},
                { title = "Cran d\'arrêt", name = "SwitchBlade", costs = 60, description = {}, model = "WEAPON_SwitchBlade" },
                --{title = "Poolcue", name = "Poolcue", costs = 120000, description = {}, model = "WEAPON_Poolcue"},
                --{title = "Wrench", name = "Wrench", costs = 120000, description = {}, model = "WEAPON_Wrench"},
                --{title = "Battleaxe", name = "Battleaxe", costs = 120000, description = {}, model = "WEAPON_Battleaxe"},
            }
        },
        ["Pistolets"] = {
            title = "Pistolets",
            name = "Pistolets",
            buttons = {
                { title = "Pistolet", name = "Pistol", costs = 1000, description = {}, model = "WEAPON_Pistol" },
                { title = "Pistolet de combat", name = "CombatPistol", costs = 1500, description = {}, model = "WEAPON_CombatPistol" },
                { title = "Pistol cal .50", name = "Pistol50", costs = 2750, description = {}, model = "WEAPON_PISTOL50" },
                { title = "Pétoire", name = "SNSPistol", costs = 1750, description = {}, model = "WEAPON_SNSPistol" },
                { title = "Pistolet lourd", name = "HeavyPistol", costs = 2500, description = {}, model = "WEAPON_HeavyPistol" },
                { title = "Pistolet vintage", name = "VintagePistol", costs = 2500, description = {}, model = "WEAPON_VintagePistol" },
                { title = "Pistolet de précision", name = "MarksmanPistol", costs = 2250, description = {}, model = "WEAPON_MarksmanPistol" },
                { title = "Revolver lourd", name = "Revolver", costs = 2150, description = {}, model = "WEAPON_Revolver" },
                { title = "Pistolet perforant", name = "APPistol", costs = 5000, description = {}, model = "WEAPON_APPistol" },
                --{title = "Stun Gun", name = "StunGun", costs = 18000, description = {}, model = "WEAPON_StunGun"},
                { title = "Pistolet de détresse", name = "FlareGun", costs = 4000, description = {}, model = "WEAPON_FlareGun" },
            }
        },
        ["MachineGuns"] = {
            title = "Mitrailleuses",
            name = "MachineGuns",
            buttons = {
                { title = "Pistolet-mitrailleur", name = "MicroSMG", costs = 3450, description = {}, model = "WEAPON_MicroSMG" },
                --{title = "Machine Pistol", name = "MachinePistol", costs = 155000, description = {}, model = "WEAPON_MachinePistol"},
                --{title = "SMG", name = "SMG", costs = 25000, description = {}, model = "WEAPON_SMG"},
                --{title = "Assault SMG", name = "AssaultSMG", costs = 18000, description = {}, model = "WEAPON_AssaultSMG"},
                --{title = "Combat PDW", name = "CombatPDW", costs = 85000, description = {}, model = "WEAPON_CombatPDW"},
                { title = "Mitrailleuse", name = "MG", costs = 3920, description = {}, model = "WEAPON_MG" },
                { title = "Mitrailleuse de combat", name = "CombatMG", costs = 4100, description = {}, model = "WEAPON_CombatMG" },
                --{title = "Gusenberg", name = "Gusenberg", costs = 120000, description = {}, model = "WEAPON_Gusenberg"},
            }
        },
        ["Shotguns"] = {
            title = "Fusils a pompe",
            name = "Shotgun",
            buttons = {
                { title = "Fusil à pompe", name = "PumpShotgun", costs = 2200, description = {}, model = "WEAPON_PumpShotgun" },
                { title = "Fusil à canon scié", name = "SawnoffShotgun", costs = 2400, description = {}, model = "WEAPON_SawnoffShotgun" },
                { title = "Fusil à pompe bullpup", name = "BullpupShotgun", costs = 3500, description = {}, model = "WEAPON_BullpupShotgun" },
                { title = "Fusil à pompe d\'assaut", name = "AssaultShotgun", costs = 4700, description = {}, model = "WEAPON_AssaultShotgun" },
                --{title = "Musket", name = "Musket", costs = 850000, description = {}, model = "WEAPON_Musket"},
                { title = "Fusil à pompe lourd", name = "HeavyShotgun", costs = 5370, description = {}, model = "WEAPON_HeavyShotgun" },
                --{title = "Auto Shotgun", name = "Autoshotgun", costs = 450000, description = {}, model = "WEAPON_Autoshotgun"},
            }
        },
        ["AssaultRifles"] = {
            title = "Fusils assault",
            name = "Assault Rifles",
            buttons = {
                { title = "Fusil d\'assault", name = "AssaultRifle", costs = 7450, description = {}, model = "WEAPON_AssaultRifle" },
                { title = "Carabine", name = "CarbineRifle", costs = 8200, description = {}, model = "WEAPON_CarbineRifle" },
                --{title = "Advanced Rifle", name = "AdvancedRifle", costs = 300000, description = {}, model = "WEAPON_AdvancedRifle"},
                --{title = "Special Carbine", name = "SpecialCarbine", costs = 310000, description = {}, model = "WEAPON_SpecialCarbine"},
                --{title = "Bullpup Rifle", name = "BullpupRifle", costs = 350000, description = {}, model = "WEAPON_BullpupRifle"},
                --{title = "FCompact Rifle", name = "CompactRifle", costs = 400000, description = {}, model = "WEAPON_CompactRifle"},
            }
        },
        ["SniperRifles"] = {
            title = "Fusils de precision",
            name = "Sniper Rifles",
            buttons = {
                { title = "Fusil de précision", name = "SniperRifle", costs = 12800, description = {}, model = "WEAPON_SniperRifle" },
                --{title = "Heavy Sniper", name = "HeavySniper", costs = 800000, description = {}, model = "WEAPON_HeavySniper"},
                --{title = "Marksman Rifle", name = "MarksmanRifle", costs = 1000000, description = {}, model = "WEAPON_MarksmanRifle"},
            }
        },
        ["HeavyWeapons"] = {
            title = "Armes lourdes",
            name = "HeavyWeapons",
            buttons = {
                { title = "Lance-grenades", name = "GrenadeLauncher", costs = 12540, description = {}, model = "WEAPON_GrenadeLauncher" },
                { title = "Lance-roquettes", name = "RPG", costs = 32800, description = {}, model = "WEAPON_RPG" },
                --{title = "Minigun", name = "Minigun", costs = 274000, description = {}, model = "WEAPON_Minigun"},
                --{title = "Firework", name = "Firework", costs = 117000, description = {}, model = "WEAPON_Firework"},
                -- {title = "Railgun", name = "Railgun", costs = 999999999, description = {}, model = "WEAPON_Railgun"},
                -- {title = "Homing Launcher", name = "HomingLauncher", costs = 1000000, description = {}, model = "WEAPON_HomingLauncher"},
                --{title = "Compact Launcher", name = "CompactLauncher", costs = 100000, description = {}, model = "WEAPON_CompactLauncher"},
            }
        },
        ["ThrownWeapons"] = {
            title = "Armes de lancer",
            name = "ThrownWeapons",
            buttons = {
                { title = "Extincteur", name = "FireExtinguisher", costs = 100, description = {}, model = "WEAPON_FireExtinguisher" },
                { title = "Fusée de détresse", name = "Flare", costs = 150, description = {}, model = "WEAPON_Flare" },
                { title = "Balle", name = "Ball", costs = 20, description = {}, model = "WEAPON_Ball" },
                { title = "Bombes collantes", name = "StickyBomb", costs = 29200, description = {}, model = "WEAPON_StickyBomb" },
                --{title = "Proximity Mine", name = "ProximityMine", costs = 25000, description = {}, model = "WEAPON_ProximityMine"},
                --{title = "BZ Gas", name = "BZGas", costs = 15000, description = {}, model = "WEAPON_BZGas"},
                --{title = "Cocktail Molotov", name = "Molotov", costs = 9500, description = {}, model = "WEAPON_Molotov"},
                --{title = "Petrol Can", name = "PetrolCan", costs = 100, description = {}, model = "WEAPON_PetrolCan"},
                --{title = "Snowball", name = "Snowball", costs = 120, description = {}, model = "WEAPON_Snowball"},
                { title = "Grenade fumigène", name = "SmokeGrenade", costs = 1700, description = {}, model = "WEAPON_SmokeGrenade" },
                --{title = "Bombe artisanale", name = "Pipebomb", costs = 3000, description = {}, model = "WEAPON_Pipebomb"},
                --{title = "Grenade explosive", name = "Grenade", costs = 17400, description = {}, model = "WEAPON_Grenade"},
            }
        }
    }
}

local fakeWeapon = ''
local weashop_locations = {
    { entering = { 1692.379, 3758.194, 33.71 }, inside = { 1692.379, 3758.194, 33.71 }, outside = { 1692.379, 3758.194, 33.71 } },
    { entering = { 252.915, -48.186, 68.941 }, inside = { 252.915, -48.186, 69.941 }, outside = { 252.915, -48.186, 69.941 } },
    { entering = { 844.352, -1033.517, 27.094 }, inside = { 844.352, -1033.517, 28.194 }, outside = { 844.352, -1033.517, 28.194 } },
    { entering = { -331.487, 6082.348, 30.354 }, inside = { -331.487, 6082.348, 31.454 }, outside = { -331.487, 6082.348, 31.454 } },
    { entering = { -664.268, -935.479, 20.729 }, inside = { -664.268, -935.479, 21.829 }, outside = { -664.268, -935.479, 21.829 } },
    { entering = { -1305.427, -392.428, 35.595 }, inside = { -1305.427, -392.428, 36.695 }, outside = { -1305.427, -392.428, 36.695 } },
    { entering = { -1119.146, 2697.061, 17.454 }, inside = { -1119.146, 2697.061, 18.554 }, outside = { -1119.146, 2697.061, 18.554 } },
    { entering = { 2569.978, 294.472, 107.634 }, inside = { 2569.978, 294.472, 108.734 }, outside = { 2569.978, 294.472, 108.734 } },
    { entering = { -3172.584, 1085.858, 19.738 }, inside = { -3172.584, 1085.858, 20.838 }, outside = { -3172.584, 1085.858, 20.838 } },
    { entering = { 20.0430, -1106.469, 28.697 }, inside = { 20.0430, -1106.469, 29.797 }, outside = { 20.0430, -1106.469, 29.797 } },
    { entering = { 812.279, -2155.9, 28.619 }, inside = { 812.279, -2155.9, 28.619 }, outside = { 812.279, -2155.9, 28.619 } },
}

local weashop_blips = {}
local inrangeofweashop = false
local currentlocation = nil

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

function IsPlayerInRangeOfweashop()
    return inrangeofweashop
end

function ShowWeashopBlips(bool)
    if bool and #weashop_blips == 0 then
        for station, pos in pairs(weashop_locations) do
            local loc = pos
            pos = pos.entering
            local blip = AddBlipForCoord(pos[1], pos[2], pos[3])
            -- 60 58 137
            SetBlipSprite(blip, 110)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('Armurerie')
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip, true)
            SetBlipAsMissionCreatorBlip(blip, true)
            table.insert(weashop_blips, { blip = blip, pos = loc })
        end
        Citizen.CreateThread(function()
            while #weashop_blips > 0 do
                Citizen.Wait(0)
                local inrange = false
                for i, b in ipairs(weashop_blips) do
                    if IsPlayerWantedLevelGreater(GetPlayerIndex(), 0) == false and weashop.opened == false and IsPedInAnyVehicle(LocalPed(), true) == false and GetDistanceBetweenCoords(b.pos.entering[1], b.pos.entering[2], b.pos.entering[3], GetEntityCoords(LocalPed())) < 5 then
                        DrawMarker(1, b.pos.entering[1], b.pos.entering[2], b.pos.entering[3], 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
                        ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour acheter des armes', 0)
                        currentlocation = b
                        inrange = true
                    end
                end
                inrangeofweashop = inrange
            end
        end)
    elseif bool == false and #weashop_blips > 0 then
        for i, b in ipairs(weashop_blips) do
            if DoesBlipExist(b.blip) then
                SetBlipAsMissionCreatorBlip(b.blip, false)
                Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(b.blip))
            end
        end
        weashop_blips = {}
    end
end

function f(n)
    return n + 0.0001
end

function LocalPed()
    return GetPlayerPed(-1)
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

--local veh = nil
function OpenCreator()
    weashop.currentmenu = "main"
    weashop.opened = true
    weashop.selectedbutton = 0
end

function CloseCreator()
    weashop.opened = false
    weashop.menu.from = 1
    weashop.menu.to = 10
end

function drawMenuButton(button, x, y, selected)
    local menu = weashop.menu
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
    AddTextComponentString(button.title)
    if selected then
        DrawRect(x, y, menu.width, menu.height, 255, 255, 255, 255)
    else
        DrawRect(x, y, menu.width, menu.height, 0, 0, 0, 150)
    end
    DrawText(x - menu.width / 2 + 0.005, y - menu.height / 2 + 0.0028)
end

function drawMenuInfo(text)
    local menu = weashop.menu
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
    local menu = weashop.menu
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
    local menu = weashop.menu
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

function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function DoesPlayerHaveWeapon(model, button, y, selected, source)
    local t = false
    local hash = GetHashKey(model)
    --t = HAS_PED_GOT_WEAPON(source,hash,false) --Check if player already has selected weapon !!!! THIS DOES NOT WORK !!!!!
    if t then
        drawMenuRight("OWNED", weashop.menu.x, y, selected)
    else
        drawMenuRight(button.costs .. " $", weashop.menu.x, y, selected)
    end
end

local backlock = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- IF INPUT_PICKUP Is pressed
        if IsControlJustPressed(1, 38) and IsPlayerInRangeOfweashop() then
            if weashop.opened then
                CloseCreator()
            else
                OpenCreator()
            end
        end

        if weashop.opened then

            local ped = LocalPed()
            local menu = weashop.menu[weashop.currentmenu]
            drawTxt(weashop.title, 1, 1, weashop.menu.x, weashop.menu.y, 1.0, 255, 255, 255, 255)
            drawMenuTitle(menu.title, weashop.menu.x, weashop.menu.y + 0.08)
            drawTxt(weashop.selectedbutton .. "/" .. tablelength(menu.buttons), 0, 0, weashop.menu.x + weashop.menu.width / 2 - 0.0385, weashop.menu.y + 0.067, 0.4, 255, 255, 255, 255)
            local y = weashop.menu.y + 0.12
            buttoncount = tablelength(menu.buttons)
            local selected = false

            for i, button in pairs(menu.buttons) do
                if i >= weashop.menu.from and i <= weashop.menu.to then

                    if i == weashop.selectedbutton then
                        selected = true
                    else
                        selected = false
                    end
                    drawMenuButton(button, weashop.menu.x, y, selected)
                    if button.costs ~= nil then
                        DoesPlayerHaveWeapon(button.model, button, y, selected, ped)
                    end
                    y = y + 0.04
                    if selected and IsControlJustPressed(1, 201) then
                        ButtonSelected(button)
                    end
                end
            end

            if IsControlJustPressed(1, 202) then
                Back()
            end
            if IsControlJustReleased(1, 202) then
                backlock = false
            end
            if IsControlJustPressed(1, 188) then
                if weashop.selectedbutton > 1 then
                    weashop.selectedbutton = weashop.selectedbutton - 1
                    if buttoncount > 10 and weashop.selectedbutton < weashop.menu.from then
                        weashop.menu.from = weashop.menu.from - 1
                        weashop.menu.to = weashop.menu.to - 1
                    end
                end
            end
            if IsControlJustPressed(1, 187) then
                if weashop.selectedbutton < buttoncount then
                    weashop.selectedbutton = weashop.selectedbutton + 1
                    if buttoncount > 10 and weashop.selectedbutton > weashop.menu.to then
                        weashop.menu.to = weashop.menu.to + 1
                        weashop.menu.from = weashop.menu.from + 1
                    end
                end
            end

            if not isInClosestGunStoreRange() then
                CloseCreator()
            end
        end
    end
end)

function isInClosestGunStoreRange()
    for _, pos in pairs(weashop_locations) do
        if GetDistanceBetweenCoords(pos.entering[1], pos.entering[2], pos.entering[3], GetEntityCoords(LocalPed())) < 5 then
            return true
        end
    end
    return false
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
    local this = weashop.currentmenu
    local btn = button.name
    if this == "main" then
        if btn == "Melee" then
            OpenMenu('Melee')
        elseif btn == "Pistolets" then
            OpenMenu('Pistolets')
        elseif btn == "MachineGuns" then
            OpenMenu('MachineGuns')
        elseif btn == "Shotguns" then
            OpenMenu('Shotguns')
        elseif btn == "AssaultRifles" then
            OpenMenu('AssaultRifles')
        elseif btn == "SniperRifles" then
            OpenMenu('SniperRifles')
        elseif btn == "HeavyWeapons" then
            OpenMenu('HeavyWeapons')
        elseif btn == "ThrownWeapons" then
            OpenMenu('ThrownWeapons')
        end
    else
        fakeWeapon = button.model
        TriggerServerEvent('CheckMoneyForWea', button.model, button.costs)
    end
end

function OpenMenu(menu)
    weashop.lastmenu = weashop.currentmenu
    weashop.menu.from = 1
    weashop.menu.to = 10
    weashop.selectedbutton = 0
    weashop.currentmenu = menu
end

function Back()
    if backlock then
        return
    end
    backlock = true
    if weashop.currentmenu == "main" then
        CloseCreator()
    else
        OpenMenu(weashop.lastmenu)
    end
end

function stringstarts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
    if firstspawn == 0 then
        ShowWeashopBlips(true)
        firstspawn = 1
    end
    TriggerServerEvent("weaponshop:playerSpawned")
end)

function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

RegisterNetEvent('giveWeapon')
AddEventHandler('giveWeapon', function(name, delay)
    Citizen.CreateThread(function()
        local weapon = GetHashKey(name)
        Wait(delay)
        local hash = GetHashKey(name)
        GiveWeaponToPed(GetPlayerPed(-1), weapon, 1000, 0, false)
    end)
end)
