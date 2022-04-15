local LSCore = exports['fw-base']:GetCoreObject()

RegisterNetEvent('fw-heists:server:atmrobbery:client:config:wrapper')
AddEventHandler('fw-heists:server:atmrobbery:client:config:wrapper', function(Data, Data2, Data3, Data4)
    local src = source
    local Player = LSCore.Functions.GetPlayer(src)

    if Data4 ~= nil then
        Config.ATMRobbery[Data][Data2][Data3] = Data4
    else
        Config.ATMRobbery[Data][Data2] = Data3
    end


end)