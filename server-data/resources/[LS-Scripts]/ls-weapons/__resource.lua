resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/index.html'

data_file 'WEAPONINFO_FILE_PATCH' 'metas/weaponheavypistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapons_snspistol_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapons_pistol_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapon_navyrevolver.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapongusenberg.meta'

data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapons.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weaponvintagepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weaponmachinepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapons_taser.meta'

data_file 'WEAPONINFO_FILE_PATCH' 'metas/weapon_ceramicpistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weaponswitchblade.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weaponhatchet.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'metas/weaponwrench.meta'

client_scripts {
    'config.lua',
    'client/client.lua',
    'client/recoil.lua',
}

server_scripts {
    'config.lua',
    'server/server.lua',
}

files {
    'metas/weaponswitchblade.meta',
    'metas/weaponhatchet.meta',
    'metas/weaponwrench.meta',
    'metas/weapons_taser.meta',
    'metas/weaponheavypistol.meta',
    'metas/weapon_navyrevolver.meta',
    'metas/weapons_snspistol_mk2.meta',
    'metas/weapons_pistol_mk2.meta',
    'metas/weapon_ceramicpistol.meta',
    'metas/weaponmachinepistol.meta',
    'metas/weaponvintagepistol.meta',
    'metas/weapongusenberg.meta',
    'metas/weapons.meta',
    'html/index.html',
    'html/js/script.js',
    'html/css/style.css',
}

exports {
    'GetWeaponList',
    'GetAmmoType',
}

server_exports {
    'GetWeaponList',
}