local missions = {}
for k, v in pairs(Config.missions) do
	missions[#missions + 1] = {
		value = k, label = k
	}
end

table.sort(missions, function(a, b)
	return a.label < b.label
end)

local vehicles = {}
for i = 1, #Config.settings.vehicles do
	local vehicle = Config.settings.vehicles[i]
	vehicles[i] = {
		value = vehicle,
		label = vehicle:gsub('^%l', string.upper)
	}
end

RegisterCommand('btMenu', function()
	local data = lib.inputDialog('Mission Settings', {
		{
			type = 'select',
			label = 'Mission',
			options = missions
		},
		{
			type = 'select',
			label = 'Vehicle',
			options = vehicles
		},
	})

	if data[1] and data[2] then
		data = {
			mission = data[1],
			vehicle = data[2],
			round = 1
		}
		TriggerServerEvent('brownThunder:nextRound', data)
	else
		TriggerServerEvent('brownThunder:cancelMission')
	end
end)

RegisterKeyMapping('btMenu', 'Open Menu', 'keyboard', 'i')