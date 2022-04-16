local table = lib.table

local data = {
	id = 'vigilante_missions',
	title = 'Vigilante Missions'
}

local options = Config.missions
local vehicles = Config.settings.vehicles
for k, v in pairs(options) do
	v.menu = 'mission_vehicle' .. v.name
	data[#data + 1] = {
		id = v.menu,
		menu = data.id,
		title = 'Mission Vehicle',
		options = table.deepclone(vehicles)
	}
	for k2, v2 in pairs(data[#data].options) do
		v2.serverEvent = 'brownThunder:nextRound'
		v2.args = {mission = v.name, vehicle = v2.vehicle, round = 1}
	end
end

options.Cancel = {event = 'brownThunder:cancelMission'}
data.options = options

lib.registerContext(data)

RegisterCommand('btMenu', function()
    lib.showContext('vigilante_missions')
end)

RegisterKeyMapping('btMenu', 'Open Menu', 'keyboard', 'i')
