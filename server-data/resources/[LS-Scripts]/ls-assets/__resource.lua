resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

data_file 'HANDLING_FILE' 'misc/handling.meta'
data_file 'FIVEM_LOVES_YOU_341B23A2F0E0F131' 'misc/popgroups.ymt'

client_scripts {
 'config.lua',
 'client/anims.lua',
 'client/holster.lua',
 'client/seatbelt.lua',
 'client/props.lua',
 'client/client.lua',
 'client/loops.lua',
 'client/density.lua',
 'client/playerid.lua',
 'client/limiter.lua',
 'client/trunk.lua',
 'client/dui.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua',
}

files {
 "html/index.html",
 'misc/handling.meta',
 'misc/popgroups.ymt',
 'misc/visualsettings.dat',
}

exports {
 'AddProp',
 'RemoveProp',
 'GetPropStatus',
 'RequestAnimationDict',
 'RequestAnimSetEvent',
 'RequestModelHash',
 'GetInTrunkState',
 'SetLoopState',
 'SetDensity',
 'GenerateNewDui',
 'DeactivateDui',
 'ActivateDui',
 'ReleaseDui',
 'GetDuiData',
}