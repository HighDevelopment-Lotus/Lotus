resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

server_scripts {
    "config.lua",
    "server/server.lua",
}

client_scripts {
    "config.lua",
    "client/client.lua",
    "client/oxyruns.lua",
    "client/weed.lua",
}

exports {
    'CanDeliverOxyBox',
    'CanStartOxy',
    'NearNpc'
}