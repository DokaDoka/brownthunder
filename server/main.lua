local AddCommand = import 'commands'
local table = import 'table'

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

for i = 1, #Data.Vehicles do
	local vehicle = Data.Vehicles[i]
	for j = 1, #Config.modes do
	local mode = Config.modes[j]
		if mode.vehicleOptions then
			for l = 1, #mode.vehicleOptions do
				local round = mode.vehicleOptions[l]
				for m = 1, #round do
					local option = round[m]
					for k, v in pairs(vehicle) do
						if v == option then
							mode.vehicleModels[l][#mode.vehicleModels[l] + 1] = vehicle.model
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
								target.models[m][#target.models[m] + 1] = vehicle.model
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
	setmetatable(mode, {__index = Config.defaultMode})
	for k, v in pairs(mode) do
		if type(v) == 'table' then
			setmetatable(mode[k], {__index = Config.defaultMode[k]})
			for k2, v2 in pairs(mode) do
				if type(v2) == 'table' then
					setmetatable(mode[k2], {__index = Config.defaultMode[k2]})
				end
			end
		end
	end
end

GlobalState['Modes'] = Config.modes

AddCommand('builtin.everyone', {'car', 'veh'}, function(source, args)
	TriggerClientEvent('brownThunder:spawnVehicle', source, getVehicle(args.vehicle))
end, {'vehicle:?string'})

function getVehicle(vehicle)
	if not vehicle then
		return Indexed.Vehicles[Config.defaultVehicle]
	elseif vehicle == 'random' then
		return Data.Vehicles[math.random(#Data.Vehicles)]
	else
		return Indexed.Vehicles[vehicle]
	end
end

RegisterServerEvent('brownThunder:nextRound', function(modeNumber, round)
	local plyState = Player(source).state
	local mode = Config.modes[modeNumber or plyState.mode]
	local round = round or plyState.round + 1
	local vehicle = false

	if mode.vehicleModels[round] then
		vehicle = getVehicle(mode.vehicleModels[round][math.random(#mode.vehicleModels[round])])
	else
		if #mode.vehicleModels > 1 then
			local round = round % #mode.vehicleModels
			if round == 0 then
				round = #mode.vehicleModels
			end
			if mode.vehicleModels[round] then
				vehicle = getVehicle(mode.vehicleModels[round][math.random(#mode.vehicleModels[round])])
			end
		end
	end

	local targets = plyState.nextTargets or mode.getTargets(mode.targets, round)
	plyState.nextTargets = mode.getTargets(mode.targets, round + 1)
	plyState.round = round
	plyState.mode = modeNumber or plyState.mode

	TriggerClientEvent('brownThunder:startRound', source, plyState.mode, vehicle, targets, plyState.nextTargets)
end)
