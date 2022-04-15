local LSCore = exports['fw-base']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback('framework-stores:server:GetConfig', function(source, cb)
    cb(Config)
end)