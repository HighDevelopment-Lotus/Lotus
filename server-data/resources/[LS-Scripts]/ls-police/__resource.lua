resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    'config.lua',
    'client/cams.lua',
    'client/disco.lua',
    'client/client.lua',
    'client/alerts.lua',
    'client/evidence.lua',
    'client/vehicles.lua',
    'client/functions.lua',
    'client/interactions.lua',
}

server_scripts {
    'config.lua',
    'server/server.lua',
}

exports {
    'IsNearGarage',
    'IsNearHeli',
}