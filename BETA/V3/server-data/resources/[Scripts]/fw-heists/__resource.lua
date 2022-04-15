resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
 'config.lua',
 'client/client.lua',
 'client/trollys.lua',
 'client/bank/bank-client.lua',
 'client/bank/bank-doors.lua',
 'client/bank/bank-vault.lua',
 'client/bank/bank-small.lua',
 'client/bobcat/bobcat-client.lua',
 'client/store/storerob-client.lua',
 'client/jewel/jewelrob-client.lua',
 'client/meter/meter-client.lua',
 'client/copper/copper-client.lua',
 'client/containers/container-client.lua',
 'client/banktruck/banktruck-client.lua',
 'client/atmrobbery/cl_atmrobbery.lua',
--  'client/humane/humane.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua',
 'server/trollys.lua',
 'server/bank/bankrob-server.lua',
 'server/bobcat/bobcat-server.lua',
 'server/jewel/jewelrob-server.lua',
 'server/store/storerob-server.lua',
 'server/meter/meter-server.lua',
 'server/copper/copper-server.lua',
 'server/containers/container-server.lua',
 'server/banktruck/banktruck-server.lua',
 'server/atmrobbery/sv_atmrobbery.lua',
--  'server/humane/humane-server.lua',
}

exports {
 'IsNearStoreRob',
 'CanRobVitrine',
 'IsNearVent',
 'IsInsideJewel',
 'CanDisableAlarm',
 'GetStoreNumber',
 'IsInsideBobcat',
 'CreateTrolly',
 'CreateCrate',
}