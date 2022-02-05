local table = import 'table'

Config = {
	peds = {
		['armenians'] = {
			`g_m_m_armboss_01`,
			`g_m_m_armgoon_01`,
			`g_m_m_armlieut_01`,
			`g_m_y_armgoon_02`,
		},
		['ballas'] = {
			`csb_ballasog`,
			`g_f_y_ballas_01`,
			`g_m_y_ballaeast_01`,
			`g_m_y_ballaorig_01`,
			`g_m_y_ballasout_01`,
		},
		['bodyguard'] = {
			`s_m_m_highsec_01`,
			`s_m_m_highsec_02`,
			`s_m_y_clubbar_01`,
			`s_m_y_devinsec_01`,
			`s_m_y_doorman_01`,
			`s_m_y_casino_01`,
			`s_m_y_westsec_01`,
			`u_m_m_jewelsec_01`,
			`u_m_m_jewelthief`,
		},
		['business'] = {
			`a_f_m_business_02`,
			`a_f_y_business_01`,
			`a_f_y_business_02`,
			`a_f_y_business_03`,
			`a_f_y_business_04`,
			`a_m_m_business_01`,
			`a_m_y_business_01`,
			`a_m_y_business_02`,
			`a_m_y_business_03`,
		},
		['cult'] = {
			`a_m_m_acult_01`,
			`a_m_o_acult_01`,
			`a_m_o_acult_02`,
			`a_m_y_acult_01`,
			`a_m_y_acult_02`,
		},
		['default'] = {
			`s_m_m_mariachi_01`,
		},
		['epsilon'] = {
			`a_f_y_epsilon_01`,
			`a_m_y_epsilon_01`,
			`a_m_y_epsilon_02`,
		},
		['families'] = {
			`g_f_y_families_01`,
			`g_m_y_famca_01`,
			`g_m_y_famdnf_01`,
			`g_m_y_famfor_01`,
		},
		['kkangpae'] = {
			`g_m_m_korboss_01`,
			`g_m_y_korean_01`,
			`g_m_y_korean_02`,
			`g_m_y_korlieut_01`,
		},
		['lost'] = {
			`g_f_y_lost_01`,
			`g_m_y_lost_01`,
			`g_m_y_lost_02`,
			`g_m_y_lost_03`,
		},
		['merryweather'] = {
			`s_m_y_blackops_01`,
			`s_m_y_blackops_02`,
			`s_m_y_blackops_03`,
		},
		['mexican'] = {
			`a_m_y_mexthug_01`,
			`g_m_m_mexboss_01`,
			`g_m_m_mexboss_02`,
			`g_m_y_mexgang_01`,
			`g_m_y_mexgoon_01`,
			`g_m_y_mexgoon_02`,
			`g_m_y_mexgoon_03`,
		},
		['military'] = {
			`s_m_m_marine_01`,
			`s_m_m_marine_02`,
			`s_m_y_armymech_01`,
			`s_m_y_marine_01`,
			`s_m_y_marine_02`,
			`s_m_y_marine_03`,
		},
		['prisoners'] = {
			`s_m_y_prismuscl_01`,
			`s_m_y_prisoner_01`,
			`u_m_y_prisoner_01`,
		},
		['triads'] = {
			`csb_chin_goon`,
			`g_m_m_chiboss_01`,
			`g_m_m_chicold_01`,
			`g_m_m_chigoon_01`,
			`g_m_m_chigoon_02`,
		},
	},
	vehicles = {
		['copy'] = 'copy',
		['repeat'] = 'repeat',
		['attackHelicopters'] = {'hunter', 'savage', 'buzzard'},
		['emergency'] = {'ambulance', 'fbi', 'fbi2', 'firetruk', 'lguard', 'pbus', 'police1', 'police2', 'police3', 'police4', 'policeb', 'policeold1', 'policeold2', 'policet', 'pranger', 'riot', 'riot2', 'sheriff', 'sheriff2'},
		['lightlyArmoured'] = {'cog552', 'cognoscenti2', 'schafter5', 'schafter6', 'baller5', 'baller6', 'xls2', 'limo2'},
		['attack'] = {'hunter', 'savage', 'buzzard', 'rhino', 'khanjali', 'ruiner2'},
		['military'] = {'apc', 'barracks', 'barracks2', 'barrage', 'crusader', 'dune3', 'halftrack', 'manchez2', 'rhino', 'squaddie', 'verus', 'vetir', 'winky'},
		['merryweather'] = {'boxville5', 'caracara', 'insurgent', 'insurgent2', 'insurgent3', 'menacer', 'mesa3', 'nightshark', 'technical', 'technical2', 'technical3', 'khanjali', 'tampa3'},
		['ground'] = {build = true, 'Compact', 'Sedan', 'SUV', 'Utility', 'Coupe', 'Muscle', 'Sports Classic', 'Sports', 'Super', 'Motorcycle', 'Off Road', 'Truck', 'Van', 'Open Wheel'},
	},
	weapons = {
		['all'] = {
			`WEAPON_ADVANCEDRIFLE`,
			`WEAPON_APPISTOL`,
			`WEAPON_ASSAULTRIFLE`,
			`WEAPON_ASSAULTRIFLE_MK2`,
			`WEAPON_ASSAULTSHOTGUN`,
			`WEAPON_ASSAULTSMG`,
			`WEAPON_AUTOSHOTGUN`,
			`WEAPON_BAT`,
			`WEAPON_BALL`,
			`WEAPON_BATTLEAXE`,
			`WEAPON_BOTTLE`,
			`WEAPON_BULLPUPRIFLE`,
			`WEAPON_BULLPUPRIFLE_MK2`,
			`WEAPON_BULLPUPSHOTGUN`,
			`WEAPON_BZGAS`,
			`WEAPON_CARBINERIFLE`,
			`WEAPON_CARBINERIFLE_MK2`,
			`WEAPON_COMBATMG`,
			`WEAPON_COMBATMG_MK2`,
			`WEAPON_COMBATPDW`,
			`WEAPON_COMBATPISTOL`,
			`WEAPON_COMPACTLAUNCHER`,
			`WEAPON_COMPACTRIFLE`,
			`WEAPON_CROWBAR`,
			`WEAPON_DAGGER`,
			`WEAPON_DBSHOTGUN`,
			`WEAPON_DOUBLEACTION`,
			`WEAPON_FIREEXTINGUISHER`,
			`WEAPON_FIREWORK`,
			`WEAPON_FLARE`,
			`WEAPON_FLAREGUN`,
			`WEAPON_FLASHLIGHT`,
			`WEAPON_GOLFCLUB`,
			`WEAPON_GRENADE`,
			`WEAPON_GRENADELAUNCHER`,
			`WEAPON_GUSENBERG`,
			`WEAPON_HAMMER`,
			`WEAPON_HEAVYPISTOL`,
			`WEAPON_HEAVYSHOTGUN`,
			`WEAPON_HEAVYSNIPER`,
			`WEAPON_HEAVYSNIPER_MK2`,
			`WEAPON_HOMINGLAUNCHER`,
			`WEAPON_KNIFE`,
			`WEAPON_KNUCKLE`,
			`WEAPON_MACHETE`,
			`WEAPON_MACHINEPISTOL`,
			`WEAPON_MARKSMANPISTOL`,
			`WEAPON_MARKSMANRIFLE`,
			`WEAPON_MARKSMANRIFLE_MK2`,
			`WEAPON_MG`,
			`WEAPON_MICROSMG`,
			`WEAPON_MINIGUN`,
			`WEAPON_MINISMG`,
			`WEAPON_MOLOTOV`,
			`WEAPON_MUSKET`,
			`WEAPON_NIGHTSTICK`,
			`WEAPON_PETROLCAN`,
			`WEAPON_PIPEBOMB`,
			`WEAPON_PISTOL`,
			`WEAPON_PISTOL50`,
			`WEAPON_PISTOL_MK2`,
			`WEAPON_POOLCUE`,
			`WEAPON_PROXMINE`,
			`WEAPON_PUMPSHOTGUN`,
			`WEAPON_PUMPSHOTGUN_MK2`,
			`WEAPON_RAILGUN`,
			`WEAPON_REVOLVER`,
			`WEAPON_REVOLVER_MK2`,
			`WEAPON_RPG`,
			`WEAPON_SAWNOFFSHOTGUN`,
			`WEAPON_SMG`,
			`WEAPON_SMG_MK2`,
			`WEAPON_SMOKEGRENADE`,
			`WEAPON_SNIPERRIFLE`,
			`WEAPON_SNOWBALL`,
			`WEAPON_SNSPISTOL`,
			`WEAPON_SNSPISTOL_MK2`,
			`WEAPON_SPECIALCARBINE`,
			`WEAPON_SPECIALCARBINE_MK2`,
			`WEAPON_STICKYBOMB`,
			`WEAPON_STUNGUN`,
			`WEAPON_SWITCHBLADE`,
			`WEAPON_VINTAGEPISTOL`,
			`WEAPON_WRENCH`,
			`WEAPON_RAYPISTOL`,
			`WEAPON_RAYCARBINE`,
			`WEAPON_RAYMINIGUN`,
			`WEAPON_STONE_HATCHET`,
		},
		['bodyguard'] = {
			`WEAPON_APPISTOL`,
			`WEAPON_CARBINERIFLE`,
		},
		['cop'] = {
			`WEAPON_PISTOL`,
			`WEAPON_PUMPSHOTGUN`,
		},
		['default'] = {
			`WEAPON_ASSAULTRIFLE`,
			`WEAPON_COMPACTRIFLE`,
			`WEAPON_MICROSMG`,
			`WEAPON_SAWNOFFSHOTGUN`,
		},
		['military'] = {
			`WEAPON_MICROSMG`,
			`WEAPON_MILITARYRIFLE`,
		},
	},
}

local functions = {
	getTargets = {
		['static'] = function(targets, round)
			local vehicles = {}
			for i = 1, #targets do
				local target = targets[i]
				if type(target) == 'table' then
					vehicles[i] = getVehicle(target[1][math.random(#target[1])])
				elseif target == 'copy' then
					vehicles[i] = table.deepclone(vehicles[i - 1])
				end
			end
			return vehicles
		end,
		['cycle'] = function(targets, round)
			local vehicles = {}
			for i = 1, #targets do
				local round = round
				local target = targets[i]
				if type(target) == 'table' then
					if target[round] ~= false then
						round = round % #target
						if round == 0 then
							round = #target
						end
					end
					if target[round] then
						vehicles[i] = getVehicle(target[round][math.random(#target[round])])
					end
				elseif target == 'copy' then
					vehicles[i] = table.deepclone(vehicles[i - 1])
				end
			end
			return vehicles
		end,
		['escalation'] = function(targets, round)
			local vehicles = {getVehicle(targets[1][1][math.random(#targets[1][1])])}
			if round > 1 then
				for i = 2, round do
					if targets[1][2] == 'copy' then
						vehicles[i] = table.deepclone(vehicles[i - 1])
					elseif targets[1][2] == 'repeat' then
						vehicles[i] = getVehicle(targets[1][1][math.random(#targets[1][1])])
					end
				end
			end
			return vehicles
		end,
	},
	onRoundStart = {
		['default'] = function(mode, homies)
			PlaySoundFrontend(-1, "Checkpoint_Hit", "GTAO_FM_Events_Soundset", 0)

			local plyPed = PlayerPedId()
			if mode.playerHealth == 'health' then
				SetEntityHealth(plyPed, GetPedMaxHealth(plyPed))
				if mode.homiehealth == 'mirrorPlayer' then
					for i = 1, #homies do
						local homie = homies[i]
						SetEntityHealth(homie, GetPedMaxHealth(homie))
					end
				end
			elseif mode.playerHealth == 'armour' then
				SetEntityHealth(plyPed, GetPedMaxHealth(plyPed))
				SetPedArmour(plyPed, 100)
				if mode.homiehealth == 'mirrorPlayer' then
					for i = 1, #homies do
						local homie = homies[i]
						SetEntityHealth(homie, GetPedMaxHealth(homie))
						SetPedArmour(homie, 100)
					end
				end
			end
		
			for j = 1, #mode.playerWeapons do
				GiveWeaponToPed(plyPed, mode.playerWeapons[j], 10000, false, true)
			end

			if mode.extraVehicleHealth ~= 0 then
				local vehicle = GetVehiclePedIsIn(plyPed)
				if vehicle ~= 0 then
					local extraHealth = mode.extraVehicleHealth * 10
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
		end,
	},
	onKill = {
		['default'] = function()
			PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
		end,
	},
}

local defaultMode = {
	name = 'No Mode Name Set',
	description = 'No Mode Description Set',

	playerHealth = 'armour',
	playerWeapons = 'cop',

	vehicle = {'attackHelicopters'},
	extraVehicleHealth = 100,

	homiePeds = 'business',
	homieWeapons = 'all',
	homiehealth = 'mirrorPlayer',

	targetPeds = 'prisoners',
	targetWeapons = 'default',
	targetArmour = 100,

	targets = {
		{
			'random',
		},
	},

	getTargets = 'static',
	onRoundStart = 'default',
	onKill = 'default',
}

Config.modes = {
	{
		name = 'Brown Thunder',
		description = 'Hunt a triplet of random targets from an attack helicopter',

		targets = {
			{
				'ground',
			},
			'copy',
			'copy',
		}
	},
	{
		name = 'Motorcade',
		description = 'Hunt 3 armoured targets in an emergency vehicle',

		vehicle = {'emergency'},

		targetPeds = 'bodyguard',
		targetWeapons = 'bodyguard',

		targets = {
			{
				'lightlyArmoured',
			},
			'repeat',
			'repeat',
		},
	},
	{
		name = 'Random',
		description = 'New vehicle and 3 random targets every round',

		vehicle = {
			'attack',
			'attack',
		},

		targets = {
			{
				'ground',
			},
			'repeat',
			'repeat',
		},
	},
	{
		name = 'Rhino Hunting',
		description = 'Exactly what it sounds like, be warned',

		targetPeds = 'military',
		targetWeapons = 'military',

		targets = {
			{
				'rhino',
				'copy',
			},
		},

		getTargets = 'escalation',
	},
	{
		name = 'Military Convoy',
		description = 'A random assortment of military vehicles',

		targetPeds = 'military',
		targetWeapons = 'military',
		
		targets = {
			{
				'military',
				'repeat',
			},
		},

		getTargets = 'escalation',
	},
	{
		name = 'Merryweather Convoy',
		description = 'A random assortment of paramilitary vehicles',

		targetPeds = 'merryweather',
		targetWeapons = 'military',

		targets = {
			{
				'merryweather',
				'repeat',
			},
		},

		getTargets = 'escalation',
	},
}

textModes = {}
for i = 1, #Config.modes do
	setmetatable(Config.modes[i], {__index = defaultMode})

	textModes[i] = {}
	for k, v in pairs(defaultMode) do
		textModes[i][k] = Config.modes[i][k]
	end
end
textModes = table.deepclone(textModes)

for i = 1, #Config.modes do
	for k, v in pairs(defaultMode) do
		if functions[k] then
			Config.modes[i][k] = functions[k][Config.modes[i][k]]
		elseif (k == 'playerWeapons' or k == 'homieWeapons' or k == 'targetWeapons') and Config.weapons[Config.modes[i][k]] then
			Config.modes[i][k] = Config.weapons[Config.modes[i][k]]
		elseif (k == 'homiePeds' or k == 'targetPeds') and Config.peds[Config.modes[i][k]] then
			Config.modes[i][k] = Config.peds[Config.modes[i][k]]
		end
	end
end
