fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "DokaDoka"
description "DokaDoka's Brown Thunder"
version "0.1.0"

dependencies {
	'ox_lib',
	'vein',
}

shared_scripts {
	'@ox_lib/init.lua',
	'shared/*.lua',
}

server_scripts {
	'server/*.lua',
}

client_scripts {
	'client/*.lua',
}
