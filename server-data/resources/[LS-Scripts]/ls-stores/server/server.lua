local LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('ls-stores:server:GetConfig', function(source, cb)
    cb(Config)
end)