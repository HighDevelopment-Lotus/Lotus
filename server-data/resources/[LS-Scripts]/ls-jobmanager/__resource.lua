resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "html/index.html"

client_scripts {
    'client/client.lua',
    'client/hunting.lua',
    'client/mining.lua',
    'client/trash.lua',
    'client/taxi.lua',
    'client/tow.lua',
    'config.lua',
}

server_scripts {
    'server/server.lua',
    'config.lua',
}

exports {
    'IsNearHunting',
}

files {
    'html/index.html',
    'html/js/script.js',
    'html/css/style.css',
    'html/img/meter.png',
}