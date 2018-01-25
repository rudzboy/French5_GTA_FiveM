Citizen.CreateThread(function()
    while true do
        Citizen.Wait(720000) -- Modifier cette valeur pour la fréquence des salaires (720000 = 12 minutes)
        TriggerServerEvent('paycheck:salary')
    end
end)

RegisterNetEvent('paycheck:depositSalary')
AddEventHandler('paycheck:depositSalary', function(amount)
    TriggerServerEvent('bank:depositSalary', amount)
end)

