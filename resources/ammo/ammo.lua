function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

local ammoPickups = {
    { x = -765.315, y = 327.121, z = 211.397 },
    { x = -783.947, y = 330.639, z = 207.630 },
    { x = 976.950, y = -104.076, z = 74.845 }
}

Citizen.CreateThread(function()
    while true do
        Wait(0)
        for _, item in pairs(ammoPickups) do
            DrawMarker(1, item.x, item.y, item.z - 1, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.55, 0.55, 1.0, 0, 0, 0, 30, false, true, 2, false, false, false, false)
        end

        for _, item in pairs(ammoPickups) do
            local player = GetPlayerPed(-1)
            local playerLoc = GetEntityCoords(player, true)
            local inAnyVehicle = IsPedInAnyVehicle(GetPlayerPed(-1), false)
            local ammoDistance = Vdist(item.x, item.y, item.z, playerLoc['x'], playerLoc['y'], playerLoc['z'])
            if (ammoDistance < 1 and not inAnyVehicle) then
                RequestAnimDict('oddjobs@shop_robbery@rob_till')
                while not HasAnimDictLoaded('oddjobs@shop_robbery@rob_till') do
                    Citizen.Wait(0)
                end
                ShowInfo("Pressez ~INPUT_CONTEXT~ pour faire le plein de munitions.", 0)
                local weaponList = { "WEAPON_KNIFE", "WEAPON_NIGHTSTICK", "WEAPON_HAMMER", "WEAPON_BAT", "WEAPON_GOLFCLUB", "WEAPON_CROWBAR", "WEAPON_BOTTLE", "WEAPON_DAGGER", "WEAPON_HATCHET", "WEAPON_KNUCKLE", "WEAPON_MACHETE", "WEAPON_FLASHLIGHT", "WEAPON_SWITCHBLADE", "WEAPON_PISTOL", "WEAPON_COMBATPISTOL", "WEAPON_APPISTOL", "WEAPON_PISTOL50", "WEAPON_SNSPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_VINTAGEPISTOL", "WEAPON_FLAREGUN", "WEAPON_MARKSMANPISTOL", "WEAPON_STUNGUN", "WEAPON_REVOLVER", "WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_ASSAULTSMG", "WEAPON_COMBATPDW", "WEAPON_MACHINEPISTOL", "WEAPON_ASSAULTRIFLE", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE", "WEAPON_SPECIALCARBINE", "WEAPON_BULLPUPRIFLE", "WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_GUSENBERG", "WEAPON_PUMPSHOTGUN", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_ASSAULTSHOTGUN", "WEAPON_BULLPUPSHOTGUN", "WEAPON_MUSKET", "WEAPON_HEAVYSHOTGUN", "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_MARKSMANRIFLE", "WEAPON_GRENADELAUNCHER", "WEAPON_GRENADELAUNCHER_SMOKE", "WEAPON_RPG", "WEAPON_MINIGUN", "WEAPON_HOMINGLAUNCHER", "WEAPON_RAILGUN", "WEAPON_GRENADE", "WEAPON_STICKYBOMB", "WEAPON_SMOKEGRENADE", "WEAPON_BZGAS", "WEAPON_MOLOTOV", "WEAPON_FIREEXTINGUISHER", "WEAPON_PETROLCAN", "WEAPON_PROXMINE", "WEAPON_SNOWBALL", "WEAPON_FIREWORK", "WEAPON_BALL", "WEAPON_FLARE" }
                if IsControlPressed(1, 38) then
                    TaskPlayAnim(GetPlayerPed(-1), 'oddjobs@shop_robbery@rob_till', 'loop', 1.0, -1.0, 1000, 0, 1, true, true, true)
                    for k, weap in pairs(weaponList) do
                        AddAmmoToPed(GetPlayerPed(-1), weap, 1000)
                    end
                end
                if IsControlJustPressed(1, 38) then
                    PlaySound(-1, "LOCAL_PLYR_CASH_COUNTER_INCREASE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0, 0, 1)
                    ShowNotification('Vous avez fait le plein de munitions!')
                end
            end
        end
    end
end)