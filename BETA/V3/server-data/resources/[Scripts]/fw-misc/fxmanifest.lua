fx_version "adamant"

game "gta5"

description 'QuackCity Misc'
author 'ItzHighNL'
version '1.0'


client_scripts {
    'config.lua',
      'client/client.lua',
      'client/modus.lua',
      'client/dansjes.lua',
}
  
server_scripts {
      'server/server.lua',
      'config.lua',
}

ui_page('html/index.html')

files({
  'html/index.html',
  'html/script.js',
  'html/style.css',
  'html/cursor.png',
  'html/header.png',
})
