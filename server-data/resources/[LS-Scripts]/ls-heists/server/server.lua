LSCore = exports['ls-core']:GetCoreObject()

-- Code

LSCore.Functions.CreateCallback("ls-heists:server:get:config", function(source, cb)
    cb(Config)
end)