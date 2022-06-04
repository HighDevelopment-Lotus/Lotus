resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

ui_page {'html/index.html'}

client_scripts {
 'client/client.lua',
}

server_scripts {
 'server/server.lua',
}

exports {
'SendAlert',
}

files {
 'html/index.html',
 'html/css/style.css',
 'html/js/script.js',
}