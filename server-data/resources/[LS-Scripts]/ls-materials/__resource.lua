resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
 'config.lua',
 'client/client.lua',
 'client/recycle.lua',
 'client/scrapyard.lua',
 'client/trashcans.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua',
}

exports {
 'IsNearScrapYard',
 'InsideRecycle',
}

server_exports {
 'GetRecycleCrafting',
}