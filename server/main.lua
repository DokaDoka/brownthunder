local instances = {}

local function getTargets(targets, round, cluster)
	local vehicles = {}
	for i = 1, #targets do
		vehicles[i] = targets[i][math.random(#targets[i])]
	end

	return vehicles
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(Config.missions) do
			v.getTargets = v.getTargets or getTargets
			for i = 1, #v.targets do
				local targetData = v.targets[i]
				local targetPool = {}

				for k, v in pairs(targetData.allow) do
					targetPool[k] = {
						allow = true,
						data = v
					}
					if targetData.deny and targetData.deny[k] then
						targetData.deny[k] = nil
					end
				end

				if targetData.deny then
					for k, v in pairs(targetData.deny) do
						targetPool[k] = {
							allow = false,
							data = v
						}
					end
				end

				local query = {'SELECT * FROM vehicle_data', ' WHERE'}
				local parameters = {}

				for k2, v2 in pairs(targetPool) do
					if k2 == 'price' or k2 == 'doors' or k2 == 'seats' then
						if v2.allow then
							query[#query + 1] = (' %s BETWEEN ? AND ?'):format(k2)
							parameters[#parameters + 1] = v2.data[1]
							parameters[#parameters + 1] = v2.data[2]
						else
							query[#query + 1] = (' %s NOT BETWEEN ? AND ?'):format(k2)
							parameters[#parameters + 1] = v2.data[1]
							parameters[#parameters + 1] = v2.data[2]
						end
					elseif type(v2.data) == 'table' then
						if v2.allow then
							if #v2.data > 1 then
								query[#query + 1] = (' %s IN (?)'):format(k2)
								parameters[#parameters + 1] = v2.data
							elseif #v2.data > 0 then
								query[#query + 1] = (' %s = ?'):format(k2)
								parameters[#parameters + 1] = v2.data[1]
							end
						else
							if #v2 > 1 then
								query[#query + 1] = (' %s NOT IN (?)'):format(k2)
								parameters[#parameters + 1] = v2.data
							elseif #v2.data > 0 then
								query[#query + 1] = (' %s != ?'):format(k2)
								parameters[#parameters + 1] = v2.data[1]
							end
						end
					elseif v2.allow then
						query[#query + 1] = (' %s = ?'):format(k2)
						parameters[#parameters + 1] = v2.data
					else
						query[#query + 1] = (' %s != ?'):format(k2)
						parameters[#parameters + 1] = v2.data
					end

					if #query > 3 then
						query[#query] = ' AND' .. query[#query]
					end
				end

				if not next(parameters) then
					query[2] = nil
				end

				v.targets[i] = MySQL.query.await(table.concat(query), parameters)
			end
		end
	end
end)

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

	local targets = missionData.getTargets(missionData.targets, round, missionData.clusterSize)

	instance.round = round
	instance.mission = missionData.name
	instance.vehicle = instance.vehicle or data?.vehicle

	TriggerClientEvent('brownThunder:startRound', source, missionData, round, targets, data?.vehicle)
end)

RegisterServerEvent('brownThunder:endMission', function(kills)
	local instance = instances[source]
	local player = lib.getPlayer(source)

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