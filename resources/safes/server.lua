require "resources/mysql-async/lib/MySQL"

local requiredJobId = 2

function s_checkIsCop(identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM police WHERE identifier = @identifier",
        { ['@identifier'] = identifier })
    if (not result[1]) then
        return "nil"
    else
        return result[1].rank
    end
end

function idJob(player)
    return MySQL.Sync.fetchScalar("SELECT job_id FROM users LEFT JOIN jobs ON jobs.job_id = users.job WHERE users.identifier = @identifier",
        { ['@identifier'] = player })
end

function updateCoffre(player, prixavant, prixtotal, prixajoute)
    MySQL.Async.execute("UPDATE safes SET `solde`=@prixtotal , identifier = @identifier , lasttransfert = @prixajoute WHERE solde = @prixavant AND safe_job = @safe_job",
        { ['@prixtotal'] = prixtotal, ['@identifier'] = player, ['@prixajoute'] = prixajoute, ['@prixavant'] = prixavant, ['@safe_job'] = requiredJobId })
end

function GetSolde()
    return MySQL.Sync.fetchScalar("SELECT solde FROM safes WHERE safe_job = @safe_job",
        { ['@safe_job'] = requiredJobId })
end

function ajoutAmendeToCoffre(amount)
    MySQL.Async.execute("UPDATE safes SET `solde`=@amount WHERE safe_job = @safe_job ",
        { ['@amount'] = amount, ['@safe_job'] = requiredJobId })
end

RegisterServerEvent('safes:amendecoffre')
AddEventHandler('safes:amendecoffre', function(amount)
    local solde = GetSolde()
    local amount = amount
    local total = amount + solde
    ajoutAmendeToCoffre(total)
    TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Coffre", false, "$~g~" .. amount .. " ~w~ ont été ajoutés au coffre.")
end)

RegisterServerEvent('safes:getsolde')
AddEventHandler('safes:getsolde', function()
    TriggerEvent('es:getPlayerFromId', source, function(user)
        if (idJob(user.identifier) == requiredJobId) then
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Coffre", false, "Solde restant : $~b~" .. GetSolde() .. "~w~.")
        else
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Vous n'avez pas la permission !")
        end
    end)
end)

RegisterServerEvent('safes:ajoutsolde')
AddEventHandler('safes:ajoutsolde', function(ajout)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local idjob = idJob(player)

        if (idjob == requiredJobId) then
            local prixavant = GetSolde()
            local prixajoute = ajout
            local prixtotal = prixavant + prixajoute

            if ((user.money - prixajoute) >= 0) then
                user:removeMoney((prixajoute))
                updateCoffre(player, prixavant, prixtotal, prixajoute)
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Coffre", false, "Vous avez ajouté $~g~" .. prixajoute .. "~w~ au coffre.")
            else
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Vous n\'avez pas assez d'argent !")
            end
        else
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Vous n\'avez pas la permission !")
        end
    end)
end)

RegisterServerEvent('safes:retirersolde')
AddEventHandler('safes:retirersolde', function(ajout)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local idjob = idJob(player)
        -- Here change id Job (allowed to withdraw/deposit )
        if (idjob == requiredJobId) then

            local prixavant = GetSolde()
            local prixenleve = ajout
            local prixtotal = prixavant - prixenleve

            if (prixtotal < -1) then
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Coffre vide !")
            else
                updateCoffre(player, prixavant, prixtotal, prixenleve)
                user:addMoney((prixenleve))
                TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Coffre", false, "Vous avez retiré $~r~" .. prixenleve .. "~w~ du coffre.")
            end
        else
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Vous n\'avez pas la permission !")
        end
    end)
end)