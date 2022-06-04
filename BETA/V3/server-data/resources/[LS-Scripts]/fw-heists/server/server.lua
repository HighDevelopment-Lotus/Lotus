LSCore = exports['fw-base']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback("framework-heists:server:get:config", function(source, cb)
    cb(Config)
end)

LSCore.Functions.CreateCallback('framework-humanelabs:server:get:config', function(source, cb)
    cb(Config)
end)