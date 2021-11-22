resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    'config.lua',
    'client/client.lua',
    'client/peds.lua',
    'client/items.lua',
    'client/yoga.lua',
    'client/selling.lua',
}

server_scripts {
    'server/server.lua',
    'config.lua',
}

exports {
    'NearInteractNpc',
}