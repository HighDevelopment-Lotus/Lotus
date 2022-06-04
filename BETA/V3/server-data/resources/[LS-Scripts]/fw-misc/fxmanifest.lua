fx_version "adamant"

game "gta5"

description 'Lotus Misc'
author 'ItzHighNL'
version '1.0'


client_scripts {
    'config.lua',
      'client/client.lua',
      'client/paintball.lua',
      -- 'client/modus.lua',
      'client/blackout.lua',
      'client/dansjes.lua',
}
  
server_scripts {
      'server/server.lua',
      'config.lua',
}

exports {
  'IsNearStore',
  'GetStoreNumber',
  'GetBlackoutStatus',
 }
 
ui_page('html/index.html')

files({
  'html/index.html',
  'html/script.js',
  'html/style.css',
  'html/cursor.png',
  'html/header.png',
})
