---------------------------------- VAR ----------------------------------

local changeYourJob = {
    { name = "Pôle Emploi", colour = 81, id = 407, x = -266.94, y = -960.744, z = 31.2231 },
}

local jobs = {
    { name = "Chômeur", id = 1 },
    { name = "Chauffeur de taxi", id = 5 },
    { name = "Pêcheur", id = 6 },
    { name = "Mineur", id = 4 },
    { name = "Bétonneur", id = 7 },
    { name = "Éboueur", id = 8 },
    { name = "Conducteur citernier", id = 9 },
    { name = "Livreur de bois", id = 10 },
    { name = "Pilote Hélicoptère", id = 12 },
    { name = "Pilote Avion", id = 13 },
    --{name="Ambulancier", id=11},
    --{name="Policier", id=2},
    --{name="Pompier", id=3},
    --{name="Dépanneur Mécanicien", id=14},
}

local currentPlayerJobId = false

---------------------------------- FUNCTIONS ----------------------------------
function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function IsNearJobs()
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    for _, item in pairs(changeYourJob) do
        local distance = GetDistanceBetweenCoords(item.x, item.y, item.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
        if (distance <= 10) then
            return true
        end
    end
end

function menuJobs()
    MenuTitle = "Jobs"
    ClearMenu()
    for _, item in pairs(jobs) do
        local nameJob = item.name
        local idJob = item.id
        Menu.addButton(nameJob, "changeJob", idJob)
    end
end

function changeJob(id)
    TriggerServerEvent("jobssystem:jobs", id)
    Menu.hidden = true
end

---------------------------------- CITIZEN ----------------------------------

Citizen.CreateThread(function()
    for _, item in pairs(changeYourJob) do
        item.blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(item.blip, item.id)
        SetBlipAsShortRange(item.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.name)
        EndTextCommandSetBlipName(item.blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsNearJobs() == true then
            if Menu.hidden == true then
                ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour accéder aux métiers disponibles.')
                if IsControlJustPressed(1, 38) then
                    Menu.hidden = false
                    menuJobs()
                end
            else
                ShowInfo('Appuyez sur ~INPUT_CONTEXT~ pour fermer le menu.\nAppuyez sur ~b~Entrée~w~ pour choisir un métier.')
                if IsControlJustPressed(1, 38) then
                    Menu.hidden = true
                end
            end
        else
            Menu.hidden = true
        end
        Menu.renderGUI()
    end
end)

RegisterNetEvent('jobssystem:updateClientJob')
AddEventHandler('jobssystem:updateClientJob', function(id)
    currentPlayerJobId = id
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('jobssystem:getPlayerJobId')
end)