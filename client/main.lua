local glm = require 'glm'
local vehicleOffset = {}
local units, clusterLeads = {}, {}
local roundEnded
local kills = 0
local heartbeat, updateAi

local spawns, focus = {}

function setRelationships()
	AddRelationshipGroup('HOMIES')
	AddRelationshipGroup('TARGET')

	SetRelationshipGroupDontAffectWantedLevel(`HOMIES`, false)
	SetRelationshipGroupDontAffectWantedLevel(`TARGET`, false)

	SetRelationshipBetweenGroups(0, `HOMIES`, `PLAYER`)
	SetRelationshipBetweenGroups(0, `PLAYER`, `HOMIES`)

	SetRelationshipBetweenGroups(5, `TARGET`, `PLAYER`)
	SetRelationshipBetweenGroups(5, `PLAYER`, `TARGET`)

	SetRelationshipBetweenGroups(5, `HOMIES`, `TARGET`)
	SetRelationshipBetweenGroups(5, `TARGET`, `HOMIES`)

	SetRelationshipBetweenGroups(5, `HOMIES`, `COP`)
	SetRelationshipBetweenGroups(5, `TARGET`, `COP`)
	SetRelationshipBetweenGroups(5, `COP`, `HOMIES`)
	SetRelationshipBetweenGroups(5, `COP`, `TARGET`)
	SetRelationshipBetweenGroups(5, `HOMIES`, `ARMY`)
	SetRelationshipBetweenGroups(5, `TARGET`, `ARMY`)
	SetRelationshipBetweenGroups(5, `ARMY`, `HOMIES`)
	SetRelationshipBetweenGroups(5, `ARMY`, `TARGET`)
	SetRelationshipBetweenGroups(5, `HOMIES`, `SECURITY_GUARD`)
	SetRelationshipBetweenGroups(5, `TARGET`, `SECURITY_GUARD`)
	SetRelationshipBetweenGroups(5, `SECURITY_GUARD`, `HOMIES`)
	SetRelationshipBetweenGroups(5, `SECURITY_GUARD`, `TARGET`)
	SetRelationshipBetweenGroups(5, `HOMIES`, `PRIVATE_SECURITY`)
	SetRelationshipBetweenGroups(5, `TARGET`, `PRIVATE_SECURITY`)
	SetRelationshipBetweenGroups(5, `PRIVATE_SECURITY`, `HOMIES`)
	SetRelationshipBetweenGroups(5, `PRIVATE_SECURITY`, `TARGET`)
end
setRelationships()

local extremes = {min = vec(-3428, -3578), max = vec(3983, 7240)}

function getSpawnPoint(mission, round)
	local plyPed = PlayerPedId()
	local point, heading = focus

	while not point do
		point = vec(math.random(extremes.min.x, extremes.max.x), math.random(extremes.min.y, extremes.max.y), 0)
		local plyPos = GetEntityCoords(plyPed)
		local distance = #(plyPos - point)
		if distance > mission.distance[1] and distance < mission.distance[2] then
			_, point, heading = GetClosestVehicleNodeWithHeading(point.x, point.y, point.z, 1, 3.0, 0)
			distance = #(plyPos - point)
			if distance < mission.distance[1] and distance > mission.distance[2] then
				point = nil
			end
		else
			point = nil
		end
	end

	if mission.clusterSize ~= 1 then
		focus = point
		point = nil
		local offset = round * 10
		while not point do
			point = focus + vec(math.random(-offset, offset), math.random(-offset, offset), 0)
			_, point, heading = GetClosestVehicleNodeWithHeading(point.x, point.y, point.z, 1, 3.0, 0)
			for i = 1, #spawns do
				if #(spawns[i] - point) < 5 then
					point = nil
					break
				end
			end
			offset += 1
		end
	end

	spawns[#spawns + 1] = point

	return vec(point.xyz, heading)
end

function getModels(targets, mission)
	for i = 1, #targets do
		lib.requestModel(targets[i].model, 1000)
	end

	for i = 1, #Config.peds[mission.targetPeds] do
		local ped = Config.peds[mission.targetPeds][i]
		lib.requestModel(ped)
	end

	for i = 1, #Config.peds[Config.settings.homies] do
		local ped = Config.peds[Config.settings.homies][i]
		lib.requestModel(ped)
	end
end

function fillVehicleWithPeds(vehicle, target, mission)
	local peds = target and Config.peds[mission.targetPeds] or Config.peds[Config.settings.homies]
	local members = {}

	local seats = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) - 2
	for i = -1, seats do
		local member = {alive = true}

		if IsVehicleSeatFree(vehicle, i) then
			member.ped = CreatePedInsideVehicle(vehicle, 0, peds[math.random(#peds)], i, true, false)
		else
			member.ped = GetPedInVehicleSeat(vehicle, i)
		end
		member.player = IsPedAPlayer(member.ped)

		members[#members + 1] = member
	end
	return members
end

function createUnit(unit, mission, round)
	local target = unit.target > 0

	unit.vehicle = spawnVehicle(unit.model, target and getSpawnPoint(mission, round), not target)
	unit.members = fillVehicleWithPeds(unit.vehicle, target, mission)
	unit.relationship = target and `TARGET` or `HOMIES`
	unit.group = unit.members[1].player and GetPedGroupIndex(unit.members[1].ped) or CreateGroup()

	for i = 1, #unit.members do
		local member = unit.members[i]

		SetEntityHealth(member.ped, GetPedMaxHealth(member.ped))
		SetPedArmour(member.ped, 100)

		if i == 1 then
			member.leader = true
			unit.leader = member

			SetPedAsGroupLeader(member.ped, unit.group)
		else
			SetPedAsGroupMember(member.ped, unit.group)
		end
		SetPedNeverLeavesGroup(member.ped, true)

		if not member.player then
 			SetPedRelationshipGroupHash(member.ped, unit.relationship)

			SetPedAccuracy(member.ped, 60)
			if target then
				for j = 1, #mission.targetWeapons do
					GiveWeaponToPed(member.ped, mission.targetWeapons[j], 10000, false, true)
				end

				SetPedHasAiBlip(member.ped, true)
				SetPedAiBlipForcedOn(member.ped, true)
				SetPedAiBlipHasCone(member.ped, false)
			else
				for j = 1, #Config.settings.homieWeapons do
					GiveWeaponToPed(member.ped, Config.settings.homieWeapons[j], 10000, false, true)
				end
			end
		end
	end

	unit.active = true
	units[#units + 1] = unit
end

function endRound(cancel)
	roundEnded = true
	ClearInterval(heartbeat)
	ClearInterval(updateAi)
	for k, v in pairs(units) do
		if v.target > 0 then
			SetEntityAsNoLongerNeeded(v.vehicle)
			for i = 1, #v.members do
				local member = v.members[i]
				SetEntityAsNoLongerNeeded(member.ped)
			end
			clusterLeads[v.cluster] = nil
			units[k] = nil
		else
			if cancel then
				SetEntityAsNoLongerNeeded(v.vehicle)
				for i = 1, #v.members do
					local member = v.members[i]
					if not member.player then
						DeleteEntity(member.ped)
					end
				end
				units[k] = nil
			else
				for i = 1, #v.members do
					local member = v.members[i]
					if member.alive then
						SetEntityHealth(member.ped, GetPedMaxHealth(member.ped))
						SetPedArmour(member.ped, 100)
					end
				end

				local vehicle = GetVehiclePedIsIn(v.leader.ped)
				if vehicle ~= 0 then
					local extraHealth = Config.settings.vehicleHealthPerRound * 10
					SetEntityHealth(vehicle, GetEntityHealth(vehicle) + extraHealth)
					SetVehicleEngineHealth(vehicle, GetVehicleEngineHealth(vehicle) + extraHealth)
					SetVehiclePetrolTankHealth(vehicle, GetVehiclePetrolTankHealth(vehicle) + extraHealth)
					SetVehicleBodyHealth(vehicle, GetVehicleBodyHealth(vehicle) + extraHealth)
					SetVehicleBodyHealth(vehicle, GetVehicleBodyHealth(vehicle) + extraHealth)
					SetHeliMainRotorHealth(vehicle, GetHeliMainRotorHealth(vehicle) + extraHealth)
					SetHeliTailRotorHealth(vehicle, GetHeliTailRotorHealth(vehicle) + extraHealth)
					SetVehicleTyresCanBurst(vehicle, false)
				end
			end
		end
	end

	if cancel then
		TriggerServerEvent('brownThunder:endMission', kills)
		units = {}
		kills = 0
		SetMaxWantedLevel(0)
	else
		TriggerServerEvent('brownThunder:nextRound')
	end
end

RegisterNetEvent('brownThunder:cancelMission', function(data)
	if next(units) then
		endRound(true)
		if data then
			Wait(1000)
			TriggerServerEvent('brownThunder:nextRound', data)
		end
	end
end)

function setClusterBehavior(cluster)
	for i = 1, #units do
		local unit = units[i]
		if unit.active and unit.cluster == cluster then
			if unit.target > 0 then
				if not clusterLeads[unit.cluster] then
					unit.clusterLead = true
					clusterLeads[unit.cluster] = unit
				end

				if unit.clusterLead then
					TaskVehicleDriveWander(unit.leader.ped, unit.vehicle, 50.0, 956)
				else
					TaskVehicleEscort(unit.leader.ped, unit.vehicle, clusterLeads[cluster].vehicle, -1, 50.0, 956, 5.0, 0, 1.0)
				end
				SetTaskVehicleChaseBehaviorFlag(unit.leader.ped, 32, true)
			end
		end
	end
end

function setAppropriateFiringPattern(ped)
	local vehicle = GetVehiclePedIsIn(ped)
	if ControlMountedWeapon(ped) then
		SetPedFiringPattern(ped, -957453492)
	elseif vehicle ~= 0 then
		if IsPedInAnyHeli(ped) then
			SetPedFiringPattern(ped, -1857128337)
		else
			SetPedFiringPattern(ped, -753768974)
		end
	else
		SetPedFiringPattern(ped, -957453492)
	end
end

RegisterNetEvent('brownThunder:startRound', function(missionData, round, targets, vehicle)
	getModels(targets, missionData)

	if vehicle then
		createUnit({
			target = 0,
			cluster = 0,
			model = vehicle,
		}, missionData, round)
	end

	PlaySoundFrontend(-1, 'Checkpoint_Hit', 'GTAO_FM_Events_Soundset', 0)
	SetMaxWantedLevel(5)
	SetPlayerHomingRocketDisabled(PlayerId(), true)

	lib.notify({
		title = missionData.name .. ' - Round ' .. round .. ' started',
		description = 'Happy hunting',
		duration = 5000,
		position = 'top'
	})

	local cluster = 1
	for i = 1, #targets do
		local target = targets[i]
		createUnit({
			target = i,
			cluster = cluster,
			model = target.model,
		}, missionData, round)

		if missionData.clusterSize > 0 and i % missionData.clusterSize == 0 then
			cluster += 1
			focus = nil
		end
	end
	focus = nil

	for i = 1, cluster do
		setClusterBehavior(i)
	end

	roundEnded = false
	heartbeat = SetInterval(function()
		local vehicles = {}
		local targetsRemaining = 0
		local homies = 0
		local aliveHomies = 0
		local activeRound = false
		local plyPed = PlayerPedId()
		for k, v in pairs(units) do
			if v.active then
				local target = v.target > 0
				activeRound = activeRound or target
				local r = target and 255 or 0
				local g = target and 0 or 255
				local activeUnit = false
				for i = 1, #v.members do
					local member = v.members[i]
					if not target and not member.player then
						homies += 1
					end

					if member.ped ~= plyPed and member.alive then
						if IsPedDeadOrDying(member.ped) or IsPedFatallyInjured(member.ped) then
							member.alive = false
							if target then
								kills += 1
								PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
							end
						else
							activeUnit = true
							if target then
								targetsRemaining += 1
							else
								aliveHomies += 1
							end

							local vehicle = GetVehiclePedIsIn(member.ped)
							if vehicle == 0 then
								local pedPos = GetEntityCoords(member.ped)
								DrawMarker(2, pedPos.xy, pedPos.z + 1.5, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, r, g, 0, 100, true, true, 2, false, false, false, false)
							elseif not vehicles[vehicle] then
								vehicles[vehicle] = true
								local model = GetEntityModel(vehicle)
								local offset = vehicleOffset[model]
								if not offset then
									local minVec, maxVec = GetModelDimensions(model)
									offset = vec(0, 0, math.max(minVec.z, maxVec.z) + 1)
									vehicleOffset[model] = offset
								end
								local vehPos = GetEntityCoords(vehicle)
								DrawMarker(2, vehPos + offset, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 1.0, 1.0, 1.0, r, g, 0, 100, true, true, 2, false, false, false, false)
							end
						end
					end
				end
				v.active = activeUnit
				if not v.active and v.clusterLead then
					v.clusterLead = false
					clusterLeads[v.cluster] = false
					setClusterBehavior(v.cluster)
				end
			end
		end
		if not activeRound and not roundEnded then
			roundEnded = true
			endRound()
		end

		local vehicleHealth = math.ceil(GetVehicleEngineHealth(GetVehiclePedIsIn(plyPed))/10)
		SetTextFont(0)
		SetTextProportional(1)
		SetTextScale(0.0, 0.5)
		SetTextColour(128, 128, 128, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(missionData.name .. '\nRound: ' .. round .. '\nKills: ' .. kills .. '\nTargets Remaining: ' .. targetsRemaining .. '\nHomies: ' .. aliveHomies .. '/' .. homies .. '\nVehicle Health: ' .. vehicleHealth .. '%')
		DrawText(0.8, 0.5)
	end)

	updateAi = SetInterval(function()
		for k, v in pairs(units) do
			for i = 1, #v.members do
				local member = v.members[i]
				if member.alive and not member.player then
					setAppropriateFiringPattern(member.ped)
				end
			end
		end
	end, 1000)
end)

function spawnVehicle(name, coords, set)
	local plyPed = PlayerPedId()
	local model = lib.requestModel(name, 1000)
	if model then
		local oldVeh, oldVehCoords, oldVehHeading, velocity, forwardVelocity, rotation
		local peds = {[-1] = plyPed}
		if set then
			oldVeh = GetVehiclePedIsIn(plyPed)
			if oldVeh ~= 0 then
				local seats = GetVehicleModelNumberOfSeats(GetEntityModel(oldVeh)) - 2
				for i = -1, seats do
					peds[i] = GetPedInVehicleSeat(oldVeh, i)
				end
				oldVehCoords = GetEntityCoords(oldVeh)
				oldVehHeading = GetEntityHeading(oldVeh)
				velocity = GetEntityVelocity(oldVeh)
				forwardVelocity = #(GetEntityForwardVector(oldVeh) * velocity)
				rotation = GetEntityRotation(oldVeh)
				DeleteEntity(oldVeh)
			end
		end

		local vector = coords and coords.xyz or oldVehCoords or GetEntityCoords(plyPed)
		local heading = coords and coords.w or oldVehHeading or GetEntityHeading(plyPed)

		RequestCollisionAtCoord(vector)

		local vehicle = CreateVehicle(model, vector, heading, true, false)
		SetModelAsNoLongerNeeded(model)

		if set then
			if oldVeh ~= 0 then
				if forwardVelocity > 0 then
					SetVehicleForwardSpeed(vehicle, forwardVelocity)
				end
				SetEntityVelocity(vehicle, velocity)
				SetEntityRotation(vehicle, rotation)
			end
			SetVehicleHasBeenOwnedByPlayer(vehicle, true)
			SetVehicleNeedsToBeHotwired(vehicle, false)
			SetVehRadioStation(vehicle, 'OFF')
			SetVehicleEngineOn(vehicle, true, true, true)
			for i = -1, #peds do
				SetPedIntoVehicle(peds[i], vehicle, i)
			end
		end
		return vehicle
	else
		lib.notify({
			description = 'Unable to load vehicle model - ' .. name
		})
	end
end

RegisterCommand('bigMap', function()
	if not IsBigmapActive() then
		SetBigmapActive(true, false)
	elseif not IsBigmapFull() then
		SetBigmapActive(true, true)
	else
		SetBigmapActive(false, false)
	end
end)

RegisterKeyMapping('bigMap', 'Toggle Map', 'keyboard', 'z')
