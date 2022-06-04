resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
 "config.lua",
 "client/client.lua",
 "client/rental.lua",
 "client/nitro.lua",
 "client/fuel.lua",
 "client/carwash.lua",
 "client/failure.lua",
 "client/keys.lua",
 "client/wheelchair.lua",
}

server_scripts {
 "config.lua",
 "server/server.lua",
}

exports {
 'HasVehicleNosActive',
 'GetFuelLevel',
 'SetFuelLevel',
 'NearGasPump',
 'SetVehicleKeys',
}