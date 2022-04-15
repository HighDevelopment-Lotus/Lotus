resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

ui_page {'html/index.html'}

client_scripts {
 'config.lua',
 'shared_items.lua',
 'client/client.lua',
}

server_scripts {
 'config.lua',
 'shared_items.lua',
 'server/server.lua'
}

exports {
 'CanOpenInventory',
 'HasEnoughOfItem',
 'GetItemData',
}

server_exports {
 'GetItemData',
 'SetInventoryItems',
 'GetInventoryItems',
}

files {
 'html/index.html',
 'html/js/*.js',
 'html/css/*.css',
 'html/img/*.png',
 'html/img/*.svg',
 'html/img/items/*.png',
}