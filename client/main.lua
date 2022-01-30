local vehicleOffset = {}
local currentTargets = {
	vehicles = {},
	peds = {}
}

local mode
local vectors = {}
local entities = {}

local stats = {
	kills = 0,
	level = 0
}

function getSpawnPoint(coords, vector)
	local plyPed, space, retrieval, outPosition, outHeading = PlayerPedId(), 2
	while not retrieval do
		Wait(0)
		local plyPos = GetEntityCoords(plyPed)
		local x, y, z in (coords or plyPos)
		local direction = vector or plyPos
		retrieval, outPosition, outHeading = GetNthClosestVehicleNodeFavourDirection(x, y, z, direction.x, direction.y, direction.z, vector and space or 2000, 1, 0x40400000, 0)
		for i = 1, #vectors do
			if vectors[i] == outPosition.xyz then
				space += 2
				retrieval = nil
			end
		end
	end
	vectors[#vectors + 1] = outPosition.xyz
	return vec(outPosition.xyz, outHeading)
end

function getModels(targets)
	for i = 1, #targets do
		lib.requestModel(targets[i].model or Config.defaultTarget, 5000)
	end
	if next(mode.peds.models) then
		for i = 1, #mode.peds.models do
			lib.requestModel(mode.peds.models[i], 5000)
		end
	else
		lib.requestModel(Config.defaultPed, 5000)
	end
end

function spawnTarget(vehicle, coords, previousVehicle)
	local driver

	local vehicle = spawnVehicle(vehicle.model or Config.defaultTarget, coords, false)
	local seats = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) - 2
	for i = -1, seats do
		local ped = CreatePedInsideVehicle(vehicle, 0, mode.peds.models[math.random(#mode.peds.models)] or Config.defaultPed, i, true, false)
		driver = driver or ped

		SetPedHasAiBlip(ped, true)
		SetPedAiBlipForcedOn(ped, true)
		SetPedAiBlipHasCone(ped, false)

		for j = 1, #mode.peds.weapons do
			GiveWeaponToPed(ped, mode.peds.weapons[j], 10000, false, true)
		end

		SetPedArmour(ped, mode.peds.armour)

		SetPedRelationshipGroupHash(ped, `PRISONER`)

		currentTargets.peds[#currentTargets.peds + 1] = ped
		entities[#entities + 1] = ped

		if i + 2 == mode.peds.number then
			break
		end
	end

	entities[#entities + 1] = vehicle

	if not previousVehicle then
		TaskVehicleDriveWander(driver, vehicle, Config.defaultSpeed, 956)
		SetTaskVehicleChaseBehaviorFlag(driver, 32, true)
	else
		TaskVehicleEscort(driver, vehicle, previousVehicle, -1, Config.defaultSpeed, 956, 10.0, 0, 5.0)
		SetTaskVehicleChaseBehaviorFlag(driver, 32, true)
	end
	return vehicle, GetEntityForwardVector(vehicle)
end

RegisterNetEvent('brownThunder:spawnVehicle', function(vehicle)
	spawnVehicle(vehicle.model, false, true)
end)

function perRound()
	activeMode = true
	local plyPed = PlayerPedId()

	if mode.playerHealth == 'standard' then
		SetEntityHealth(plyPed, 200)
	elseif mode.playerHealth == 'armour' then
		SetEntityHealth(plyPed, 200)
		SetPedArmour(plyPed, 100)
	end

	if mode.vehicleHealth == 'standard' then
		local vehicle = GetVehiclePedIsIn(plyPed)
		if vehicle ~= 0 then
			SetEntityHealth(vehicle, GetEntityHealth(vehicle) + 1000)
			SetVehicleEngineHealth(vehicle, GetVehicleEngineHealth(vehicle) + 1000)
			SetVehiclePetrolTankHealth(vehicle, GetVehiclePetrolTankHealth(vehicle) + 1000)
			SetVehicleBodyHealth(vehicle, GetVehicleBodyHealth(vehicle) + 1000)
			SetVehicleBodyHealth(vehicle, GetVehicleBodyHealth(vehicle) + 1000)
			SetHeliMainRotorHealth(vehicle, GetHeliMainRotorHealth(vehicle) + 1000)
			SetHeliTailRotorHealth(vehicle, GetHeliTailRotorHealth(vehicle) + 1000)
			SetVehicleTyresCanBurst(vehicle, false)
		end
	end
end

function endRound(delete)
	activeMode = false
	currentTargets = {vehicles = {}, peds = {}}
	for i = 1, #entities do
		if delete then
			DeleteEntity(entities[i])
		else
			SetEntityAsNoLongerNeeded(entities[i])
		end
		entities[i] = nil
	end
end

function endMode()
	endRound(true)
	mode = nil
	Player(GetPlayerServerId(PlayerId())).state:set('nextTargets', nil, true)
	stats.kills = 0
	stats.level = 0
end

RegisterNetEvent('brownThunder:startRound', function(modeNumber, vehicle, targets, nextTargets)
	sendLocal({'^1BROWN THUNDER', 'starting level ' .. stats.level + 1})
	mode = GlobalState['Modes'][modeNumber]
	getModels(targets)
	if vehicle then
		spawnVehicle(vehicle.model, false, true)
	end
	local spawnPoint = getSpawnPoint()
	local previousVehicle, forwardVector = spawnTarget(targets[1], spawnPoint)
	if #targets > 1 then
		for i = 2, #targets do
			spawnPoint = getSpawnPoint(spawnPoint, forwardVector)
			previousVehicle, forwardVector = spawnTarget(targets[i], spawnPoint, previousVehicle)
		end
	end
	vectors = {}
	if mode.weapons then
		local plyPed = PlayerPedId()
		for k, v in pairs(Config.weapons) do
			GiveWeaponToPed(plyPed, joaat(k), 1000, false, false)
		end
	end

	SetRelationshipGroupDontAffectWantedLevel(`PRISONER`, false)
	SetRelationshipBetweenGroups(5, `PRISONER`, `COP`)
	SetRelationshipBetweenGroups(5, `COP`, `PRISONER`)
	SetRelationshipBetweenGroups(5, `PRISONER`, `ARMY`)
	SetRelationshipBetweenGroups(5, `ARMY`, `PRISONER`)
	SetRelationshipBetweenGroups(5, `PRISONER`, `SECURITY_GUARD`)
	SetRelationshipBetweenGroups(5, `SECURITY_GUARD`, `PRISONER`)
	SetRelationshipBetweenGroups(5, `PRISONER`, `PRIVATE_SECURITY`)
	SetRelationshipBetweenGroups(5, `PRIVATE_SECURITY`, `PRISONER`)
	getModels(nextTargets)
end)

CreateThread(function()
	while true do
		Wait(0)
		if activeMode then
			if next(currentTargets.peds) then				
				local kills = stats.kills
				currentTargets.vehicles = {}
				for k, v in pairs(currentTargets.peds) do
					if IsPedDeadOrDying(v) then
						currentTargets.peds[k] = nil
						stats.kills += 1
						mode.onKill()
					else
						local vehicle = GetVehiclePedIsIn(v)
						if vehicle == 0 then
							local pedPos = GetEntityCoords(v)
							DrawMarker(2, pedPos.xy, pedPos.z + 1.5, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, true, true, 2, false, false, false, false)
						elseif not currentTargets.vehicles[vehicle] then
							currentTargets.vehicles[vehicle] = true
							local model = GetEntityModel(vehicle)
							local offset = vehicleOffset[model]
							if not offset then
								local minVec, maxVec = GetModelDimensions(model)
								offset = vec(0, 0, math.max(minVec.z, maxVec.z) + 1)
								vehicleOffset[model] = offset
							end
							local vehPos = GetEntityCoords(vehicle)
							DrawMarker(2, vehPos + offset, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, true, true, 2, false, false, false, false)
						end
					end
				end
				if stats.kills ~= kills then
					sendLocal({'^1BROWN THUNDER', stats.kills .. ' dead'})
				end
			else
				stats.level += 1
				sendLocal({'^1BROWN THUNDER', 'level ' .. stats.level .. ' passed'})
				TriggerServerEvent('brownThunder:nextRound')
				endRound()
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1000)
		SetPlayerHomingRocketDisabled(PlayerId(), true)
		if activeMode then
			local plyPed = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(plyPed)

			if mode.playerHealth == 'invincible' then
				SetEntityInvincible(plyPed, true)
			end

			if vehicle ~= 0 then
				if mode.vehicleHealth == 'invincible' then
					SetEntityInvincible(vehicle, true)
					SetHeliMainRotorHealth(vehicle, 5000)
					SetHeliTailRotorHealth(vehicle, 5000)
				elseif mode.vehicleHealth == 'standard' then
					SetVehicleTyresCanBurst(vehicle, false)
				end
			end
		end
	end
end)

function spawnVehicle(name, coords, set)
	local ped = PlayerPedId()
	local model = lib.requestModel(name, 5000)
	if model then
		local oldVeh, oldVehCoords, oldVehHeading, velocity, forwardVelocity, rotation
		if set then
			oldVeh = GetVehiclePedIsIn(ped)
			if oldVeh ~= 0 then
				oldVehCoords = GetEntityCoords(oldVeh)
				oldVehHeading = GetEntityHeading(oldVeh)
				velocity = GetEntityVelocity(oldVeh)
				local forwardVector = GetEntityForwardVector(oldVeh)
				forwardVelocity = #(forwardVector * velocity)
				rotation = GetEntityRotation(oldVeh)
				DeleteEntity(oldVeh)
			end
		end

		local vector = coords and coords.xyz or oldVehCoords or GetEntityCoords(ped)
		local heading = coords and coords.w or oldVehHeading or GetEntityHeading(ped)

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
			SetPedIntoVehicle(ped, vehicle, -1)
		end
		return vehicle
	else
		sendLocal({'^1BROWN THUNDER', 'Unable to load vehicle model - ' .. name})
	end
end

function sendLocal(args)
	TriggerEvent('chat:addMessage', {args = args})
end

--[[
0000000000000000000001110111100
FLAG ENABLED - CONVERTED INTEGER - DESCRIPTION
00000000000000000000000000000001 - 1 - stop before vehicles
00000000000000000000000000000010 - 2 - stop before peds
00000000000000000000000000000100 - 4 - avoid vehicles
00000000000000000000000000001000 - 8 - avoid empty vehicles
00000000000000000000000000010000 - 16 - avoid peds
00000000000000000000000000100000 - 32 - avoid objects
00000000000000000000000001000000 - 64 - ?
00000000000000000000000010000000 - 128 - stop at traffic lights
00000000000000000000000100000000 - 256 - use blinkers
00000000000000000000001000000000 - 512 - allow going wrong way (only does it if the correct lane is full, will try to reach the correct lane again as soon as possible)
00000000000000000000010000000000 - 1024 - go in reverse gear (backwards)
00000000000000000000100000000000 - 2048 - ?
00000000000000000001000000000000 - 4096 - ?
00000000000000000010000000000000 - 8192 - ?
00000000000000000100000000000000 - 16384 - ?
00000000000000001000000000000000 - 32768 - ?
00000000000000010000000000000000 - 65536 - ?
00000000000000100000000000000000 - 131072 - ?
00000000000001000000000000000000 - 262144 - Take shortest path (Removes most pathing limits, the driver even goes on dirtroads)
00000000000010000000000000000000 - 524288 - Probably avoid offroad?
00000000000100000000000000000000 - 1048576 - ?
00000000001000000000000000000000 - 2097152 - ?
00000000010000000000000000000000 - 4194304 - Ignore roads (Uses local pathing, only works within 200~ meters around the player)
00000000100000000000000000000000 - 8388608 - ?
00000001000000000000000000000000 - 16777216 - Ignore all pathing (Goes straight to destination)
00000010000000000000000000000000 - 33554432 - ?
00000100000000000000000000000000 - 67108864 - ?
00001000000000000000000000000000 - 134217728 - ?
00010000000000000000000000000000 - 268435456 - ?
00100000000000000000000000000000 - 536870912 - avoid highways when possible (will use the highway if there is no other way to get to the destination)
01000000000000000000000000000000 - 1073741824 - ?
--]]