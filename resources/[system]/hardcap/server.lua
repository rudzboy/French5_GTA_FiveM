local playerCount = 0
local list = {}

RegisterServerEvent('hardcap:playerActivated')

AddEventHandler('hardcap:playerActivated', function()
    if not list[source] then
        playerCount = playerCount + 1
        list[source] = true
    end
end)

AddEventHandler('playerDropped', function()
    if list[source] then
        playerCount = playerCount - 1
        list[source] = nil
    end
end)

AddEventHandler('playerConnecting', function(name, setReason)
    local cv = 32

    print('Connection en cours: ' .. name)

    if playerCount >= cv then
        print('Complet. :(')

        setReason('Le serveur est complet (max ' .. tostring(cv) .. ' joueurs).')
        CancelEvent()
    end
end)
