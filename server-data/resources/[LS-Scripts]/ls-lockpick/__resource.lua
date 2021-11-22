resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/index.html'

client_scripts {
 'client/client.lua',
}

server_scripts {
 'server/server.lua',
}

files {
 'html/index.html',
 'html/script.js',
 'html/style.css',
 'html/reset.css',
 'html/cylinder.png',
 'html/driver.png',
 'html/pinBott.png',
 'html/pinTop.png',
 'html/collar.png',
}

exports {
 'OpenLockpickGame',
 'GetLockPickStatus',
}