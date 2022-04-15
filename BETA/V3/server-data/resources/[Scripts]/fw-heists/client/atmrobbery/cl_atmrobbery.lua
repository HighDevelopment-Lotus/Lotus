local LSCore = exports['fw-base']:GetCoreObject()


RegisterNetEvent('fw-heists:client:atmrobbery:start')
AddEventHandler('fw-heists:client:atmrobbery:start', function()
    local Player = PlayerPedId()

    if CurrentCops >= Config.ATMRobbery['Options']['MinimalCops'] then
        if not Config.ATMRobbery['Options']['ATMExploded'] then
            
        else
            LSCore.Functions.Notify('Hmm... Actie op dit moment niet mogelijk..', 'error')
        end
    else
        LSCore.Functions.Notify('Hmm... Actie op dit moment niet mogelijk..', 'error')
    end


end)