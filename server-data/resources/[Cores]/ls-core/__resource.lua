resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

shared_scripts {
 "shared.lua",
 "shared_vehicles.lua",
} 

server_scripts {
 "config.lua",
 "server/server.lua",
 "server/functions.lua",
 "server/player.lua",
 "server/events.lua",
 "server/commands.lua",
}

client_scripts {
 "config.lua",
 "client/client.lua",
 "client/functions.lua",
 "client/loops.lua",
 "client/events.lua",
}

exports { 
 'GetCoreObject'
}

server_exports { 
 'GetCoreObject'
}