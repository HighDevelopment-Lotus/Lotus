fx_version 'cerulean'
game 'gta5'

author 'BerkieB'
description 'bt-target rewritten with the help of contributors to make the best interaction system for FiveM whilst keeping the best optimization possible!'
version '2.6.1'

ui_page 'html/index.html'

client_scripts {
	'@PolyZone/client/client.lua',
	'@PolyZone/client/BoxZone.lua',
	'@PolyZone/client/EntityZone.lua',
	'@PolyZone/client/CircleZone.lua',
	'@PolyZone/client/ComboZone.lua',
	'client/*.lua',
}

files {
	'config.lua',
	'html/*.html',
	'html/css/*.css',
	'html/js/*.js'
}

dependencies {
	"PolyZone",
}