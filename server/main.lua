local table = lib.table
local vehicleSets = {}
local instances = {}

function getTargets(mission, targets, round)
	vehicleSets[mission] = vehicleSets[mission] or {}
	local vehicles = {}
	for i = 1, #targets do
		local target = targets[i]
		if type(target) == 'table' then
			local vehicleSet = vehicleSets[mission][i]
			if not vehicleSet then
				local column, values = next(target)
				vehicleSet = MySQL.query.await('SELECT model FROM vehicle_data WHERE ?? IN (?)', {column, values})
				vehicleSets[mission][i] = vehicleSet
			end
			vehicles[i] = vehicleSet[math.random(#vehicleSet)]
		elseif target == 'repeat' then
			local vehicleSet
			for j = 1, #targets do
				vehicleSet = vehicleSets[mission][i - j]
				if vehicleSet then
					vehicles[i] = vehicleSet[math.random(#vehicleSet)]
					break
				end
			end
		elseif target == 'copy' then
			vehicles[i] = table.deepclone(vehicles[i - 1])
		end
	end
	return vehicles
end

RegisterServerEvent('brownThunder:nextRound', function(data)
	local source = source
	instances[source] = instances[source] or {}
	local instance = instances[source]

	if data?.round and instance.round then
		TriggerClientEvent('brownThunder:cancelMission', source, data)
		return
	end

	local round = data?.round or instance.round + 1
	local missionData = Config.missions[data?.mission or instance.mission]
	local targets = getTargets(missionData.name, missionData.targets, round)

	instance.round = round
	instance.mission = missionData.name
	instance.vehicle = instance.vehicle or data?.vehicle

	TriggerClientEvent('brownThunder:startRound', source, missionData, round, targets, data?.vehicle)
end)

RegisterServerEvent('brownThunder:endMission', function(kills)
	local instance = instances[source]
	local player = instance(source)

	if instance.round > 1 then
		MySQL.insert('INSERT INTO scores (charid, name, round, kills, mission, vehicle) VALUES (?, ?, ?, ?, ?, ?)', {player.charid, player.firstname .. ' ' .. player.lastname, instance.round, kills, instance.mission, instance.vehicle})
	end
	instance.round = nil
	instance.mission = nil
	instance.vehicle = nil
end)

RegisterNetEvent('ox:playerDeath', function(dead)
	if dead then
		TriggerClientEvent('brownThunder:cancelMission', source)
	end
end)