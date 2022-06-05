fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "DokaDoka"
description "DokaDoka's Brown Thunder"
version "0.5.0"

dependencies {
	'oxmysql',
	'ox_core',
	'ox_lib',
}

shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    '@ox_core/imports/server.lua',
	'server/*.lua',
}

client_scripts {
    '@ox_core/imports/client.lua',
	'client/*.lua',
}
