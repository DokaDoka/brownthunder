fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "DokaDoka"
description "DokaDoka's Brown Thunder"
version "0.2.1"

dependencies {
	'oxmysql',
	'ox_core',
	'ox_lib',
}

shared_scripts {
	'@ox_core/imports.lua',
	'@ox_lib/init.lua',
	'shared/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/*.lua',
}

client_scripts {
	'client/*.lua',
}
