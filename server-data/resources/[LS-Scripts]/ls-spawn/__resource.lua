resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

ui_page "html/index.html"

client_script {
 "config.lua",
 "client/client.lua"
}

server_script {
 "config.lua",
 "server/server.lua"
}

files {
 "html/index.html",
 "html/css/style.css",
 "html/js/script.js",
 "html/img/map.png",
}