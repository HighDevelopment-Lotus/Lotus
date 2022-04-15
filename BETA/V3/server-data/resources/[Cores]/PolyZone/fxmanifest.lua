games {'gta5'}

fx_version 'cerulean'

author "AwayFromKane (#0001)"
description "Polyzone"

ui_page { 'html/copy.html' }

client_scripts {
  'client/client.lua',
  'client/BoxZone.lua',
  'client/EntityZone.lua',
  'client/CircleZone.lua',
  'client/ComboZone.lua',
  'client/creation/*.lua'
}

server_scripts {
  'server/creation_sv.lua',
  'server/server.lua'
}

exports {
  'AddCircleZone',
  'AddBoxZone',
  'AddPolyzone',
  'AddZone',
  'GetCreatedZone',
  'GetLastCreatedZone',
  'GetLastCreatedZoneType',
}

files {
	'html/copy.html',
}