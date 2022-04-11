local table = lib.table

Data = {}
Indexed = {}

function data(name)
	local func, err = load(LoadResourceFile('dd_society', 'data/'..name..'.lua'), name, 't')
	assert(func, err == nil or '\n^1'..err..'^7')
	return func()
end

Data.Vehicles = data('vehicles')
Indexed.Vehicles = {}
for i = 1, #Data.Vehicles do
	Indexed.Vehicles[Data.Vehicles[i].model] = Data.Vehicles[i]
end

setmetatable(Config.vehicles, {
	__index = function (table, key)
		return {Indexed.Vehicles[key].model or key}
  	end
})

for i = 1, #Config.modes do
	local mode = Config.modes[i]
	for j = 1, #mode.vehicle do
		if type(mode.vehicle[j]) == 'string' then
			mode.vehicle[j] = Config.vehicles[mode.vehicle[j]]
			if mode.vehicle[j].build then
				mode.options = mode.options or {}
				mode.options[j] = table.deepclone(mode.vehicle[j])
				mode.options[j].build = nil
				mode.vehicle[j] = {}
			end
		end
	end
	for j = 1, #mode.targets do
		local target = mode.targets[j]
		if type(target) == 'table' then
			for l = 1, #target do
				target[l] = Config.vehicles[target[l]]
				if target[l].build then
					mode.targets[j].options = mode.targets[j].options or {}
					mode.targets[j].options[l] = table.deepclone(target[l])
					mode.targets[j].options[l].build = nil
					target[l] = {}
				end
			end
		end
	end
end

for i = 1, #Data.Vehicles do
	local vehicle = Data.Vehicles[i]
	for j = 1, #Config.modes do
	local mode = Config.modes[j]
		if mode.options then
			for l = 1, #mode.options do
				local round = mode.options[l]
				for m = 1, #round do
					local option = round[m]
					for k, v in pairs(vehicle) do
						if v == option then
							mode.vehicle[l][#mode.vehicle[l] + 1] = vehicle.model
							break
						end
					end
				end
			end 
		end
		for l = 1, #mode.targets do
			local target = mode.targets[l]
			if target?.options then
				for m = 1, #target.options do
					local round = target.options[m]
					for n = 1, #round do
						local option = round[n]
						for k, v in pairs(vehicle) do
							if v == option then
								target[m][#target[m] + 1] = vehicle.model
								break
							end
						end
					end
				end
			end
		end
	end
end

for i = 1, #Config.modes do
	local mode = Config.modes[i]
	for j = 1, #mode.targets do
		local target = mode.targets[j]
		if target == 'repeat' then
			mode.targets[j] = table.deepclone(mode.targets[j - 1])
		end
	end
end

lib.AddCommand('builtin.everyone', {'car', 'veh'}, function(source, args)
	TriggerClientEvent('brownThunder:spawnVehicle', source, getVehicle(args.vehicle))
end, {'vehicle:?string'})

function getVehicle(vehicle)
	if not vehicle or vehicle == 'random' then
		return Data.Vehicles[math.random(#Data.Vehicles)]
	end
	return Indexed.Vehicles[vehicle]
end

RegisterServerEvent('brownThunder:nextRound', function(modeNumber, round)
	local plyState = Player(source).state
	local mode = Config.modes[modeNumber or plyState.mode]
	local round = round or plyState.round + 1
	local vehicle = false

	if mode.vehicle[round] then
		vehicle = getVehicle(mode.vehicle[round][math.random(#mode.vehicle[round])])
	else
		if #mode.vehicle > 1 then
			local round = round % #mode.vehicle
			if round == 0 then
				round = #mode.vehicle
			end
			if mode.vehicle[round] then
				vehicle = getVehicle(mode.vehicle[round][math.random(#mode.vehicle[round])])
			end
		end
	end

	local targets = plyState.nextTargets or mode.getTargets(mode.targets, round)
	plyState.nextTargets = mode.getTargets(mode.targets, round + 1)
	plyState.round = round
	plyState.mode = modeNumber or plyState.mode

	TriggerClientEvent('brownThunder:startRound', source, plyState.mode, vehicle, targets, plyState.nextTargets)
end)
