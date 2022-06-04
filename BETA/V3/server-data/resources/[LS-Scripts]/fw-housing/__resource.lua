resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

ui_page "html/index.html"

client_scripts {
 'config.lua',
 'client/client.lua',
 'client/decorate.lua',
 'client/garages.lua',
 'client/appartments.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua'
}

files {
  'html/index.html',
  'html/reset.css',
  'html/style.css',
  'html/script.js',
}

exports {
  'GetGarageCoords',
  'HasEnterdHouse',
  'EnterNearHouse',
  'GetClosesBuyHouse',
  'IsInsideDepot',
  'IsPlayerOnAParkingSpot',
  'GetAppartmentName',
  'IsNearHouse'
}