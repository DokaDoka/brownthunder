fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author "DokaDoka"
description "DokaDoka's Brown Thunder"
version "0.1.0"

dependencies {
	'pe-lualib',
	'vein',
}

shared_scripts {
	'@pe-lualib/init.lua',
	'shared/*.lua',
}

server_scripts {
	'server/*.lua',
}

client_scripts {
	'client/*.lua',
}
