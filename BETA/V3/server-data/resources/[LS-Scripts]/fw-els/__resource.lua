resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

ui_page "html/index.html"

client_script {
 'config.lua',
 'client/client.lua',
}

server_scripts {
 'config.lua',
 'server/server.lua',
}

files {
 "html/index.html",
 "html/js/script.js",
 "html/css/style.css",
 "html/img/*.png",
}

exports {
 'SetupEmergencyVehicle',
}