Config = {
	defaultVehicle = 'ruiner2',
	defaultTarget = 'kuruma2',
	defaultSpeed = 50.0,
}

Config.peds = {
	default = {
		`s_m_m_mariachi_01`,
	},
	arm = {
		`g_m_m_armboss_01`,
		`g_m_m_armgoon_01`,
		`g_m_m_armlieut_01`,
		`g_m_y_armgoon_02`,
	},
	ballas = {
		`csb_ballasog`,
		`g_f_y_ballas_01`,
		`g_m_y_ballaeast_01`,
		`g_m_y_ballaorig_01`,
		`g_m_y_ballasout_01`,
	},
	chinese = {
		`csb_chin_goon`,
		`g_m_m_chiboss_01`,
		`g_m_m_chicold_01`,
		`g_m_m_chigoon_01`,
		`g_m_m_chigoon_02`,
	},
	families = {
		`g_f_y_families_01`,
		`g_m_y_famca_01`,
		`g_m_y_famdnf_01`,
		`g_m_y_famfor_01`,
	},
	korean = {
		`g_m_m_korboss_01`,
		`g_m_y_korean_01`,
		`g_m_y_korean_02`,
		`g_m_y_korlieut_01`,
	},
	lost = {
		`g_f_y_lost_01`,
		`g_m_y_lost_01`,
		`g_m_y_lost_02`,
		`g_m_y_lost_03`,
	},
	mexican = {
		`a_m_y_mexthug_01`,
		`g_m_m_mexboss_01`,
		`g_m_m_mexboss_02`,
		`g_m_y_mexgang_01`,
		`g_m_y_mexgoon_01`,
		`g_m_y_mexgoon_02`,
		`g_m_y_mexgoon_03`,
	},
	business = {
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
	cult = {
		`a_m_m_acult_01`,
		`a_m_o_acult_01`,
		`a_m_o_acult_02`,
		`a_m_y_acult_01`,
		`a_m_y_acult_02`,
	},
	epsilon = {
		`a_f_y_epsilon_01`,
		`a_m_y_epsilon_01`,
		`a_m_y_epsilon_02`,
	},
	bodyguard = {
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
	military = {
		`s_m_m_marine_01`,
		`s_m_m_marine_02`,
		`s_m_y_armymech_01`,
		`s_m_y_marine_01`,
		`s_m_y_marine_02`,
		`s_m_y_marine_03`,
	},
	merryweather = {
		`s_m_y_blackops_01`,
		`s_m_y_blackops_02`,
		`s_m_y_blackops_03`,
	},
	prisoners = {
		`s_m_y_prismuscl_01`,
		`s_m_y_prisoner_01`,
		`u_m_y_prisoner_01`,
	},
}

Config.weapons = {
	default = {
		`WEAPON_MICROSMG`,
		`WEAPON_ASSAULTRIFLE`,
		`WEAPON_COMPACTRIFLE`,
		`WEAPON_SAWNOFFSHOTGUN`,
	},
	bodyguard = {
		`WEAPON_APPISTOL`,
		`WEAPON_CARBINERIFLE`,
	},
	military = {
		`WEAPON_MICROSMG`,
		`WEAPON_MILITARYRIFLE`,
	},
}

Config.functions = {
	getTargetsRepeat = function(targets, round)
		local vehicles = {}
		local target = targets[1]
		for i = 1, round do
			vehicles[i] = getVehicle(target.models[1][math.random(#target.models[1])])
		end
		return vehicles
	end,
	getTargetsCopy = function(targets, round)
		local vehicles = {getVehicle(targets[1].models[1][math.random(#targets[1].models[1])])}
		if round > 1 then
			for i = 2, round do
				vehicles[i] = table.deepclone(vehicles[i - 1])
			end
		end
		return vehicles
	end,
}

Config.defaultMode = {
	name = 'No Mode Name Set',
	description = 'No Mode Description Set',
	vehicleModels = {{'hunter', 'savage', 'buzzard'}},
	playerHealth = 'standard',
	vehicleHealth = 'standard',
	weapons = false,
	peds = {
		models = Config.peds.prisoners,
		number = false,
		armour = 100,
		weapons = Config.weapons.default,
	},
	targets = {
		{
			models = {{'random'}},
		},
	},
	onRoundStart = function(mode)
		PlaySoundFrontend(-1, "Checkpoint_Hit", "GTAO_FM_Events_Soundset", 0)
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
	end,
	onKill = function()
		PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
	end,
	getTargets = function(targets, round)
		local vehicles = {}
		for i = 1, #targets do
			local round = round
			local target = targets[i]
			if type(target) == 'table' then
				if target.models[round] ~= false then
					round = round % #target.models
					if round == 0 then
						round = #target.models
					end
				end
				if target.models[round] then
					vehicles[i] = getVehicle(target.models[round][math.random(#target.models[round])])
				end
			elseif target == 'copy' then
				vehicles[i] = table.deepclone(vehicles[i - 1])
			end
		end
		return vehicles
	end,
}

Config.modes = {
	{
		name = 'Brown Thunder',
		structure = 'Static',
		description = 'Hunt a triplet of random targets from an attack helicopter',
		targets = {
			{
				models = {{}},
				options = {{'Compact', 'Sedan', 'SUV', 'Utility', 'Coupe', 'Muscle', 'Sports Classic', 'Sports', 'Super', 'Motorcycle', 'Off Road', 'Truck', 'Van', 'Open Wheel'}},
			},
			'copy',
			'copy',
		},
	},
	{
		name = 'Motorcade',
		structure = 'Static',
		description = 'Hunt 3 armoured targets in an emergency vehicle',
		vehicleModels = {{}},
		vehicleOptions = {{'Restricted'}},
		playerHealth = 'armour',
		peds = {
			models = Config.peds.bodyguard,
			weapons = Config.weapons.bodyguard,
		},
		targets = {
			{
				models = {{'cog552', 'cognoscenti2', 'schafter5', 'schafter6', 'baller5', 'baller6', 'xls2', 'limo2'}},
			},
			'repeat',
			'repeat',
		},
	},
	{
		name = 'Random',
		structure = 'Static',
		description = 'New vehicle and 3 random targets every round',
		vehicleModels = {
			{'hunter', 'savage', 'buzzard', 'rhino', 'khanjali', 'ruiner2'},
			{'hunter', 'savage', 'buzzard', 'rhino', 'khanjali', 'ruiner2'},
		},
		targets = {
			{
				models = {{}},
				options = {{'Compact', 'Sedan', 'SUV', 'Utility', 'Coupe', 'Muscle', 'Sports Classic', 'Sports', 'Super', 'Motorcycle', 'Off Road', 'Truck', 'Van', 'Open Wheel'}},
			},
			'repeat',
			'repeat',
		},
	},
	{
		name = 'Rhino Hunting',
		structure = 'Escalation',
		description = 'Exactly what it sounds like, be warned',
		peds = {
			models = Config.peds.military,
			weapons = Config.weapons.military,
		},
		targets = {
			{
				models = {{'rhino'}},
			},
		},
		getTargets = Config.functions.getTargetsCopy,
	},
}

Config.weapons = {
	['WEAPON_ADVANCEDRIFLE'] = {
		label = 'Advanced Rifle',
		weight = 3180,
		durability = 0.6,
		ammoname = 'ammo-rifle',
	},

	['WEAPON_APPISTOL'] = {
		label = 'AP Pistol',
		weight = 1220,
		durability = 0.4,
		ammoname = 'ammo-9',
	},

	['WEAPON_ASSAULTRIFLE'] = {
		label = 'Assault Rifle',
		weight = 3470,
		durability = 0.8,
		ammoname = 'ammo-rifle2',
	},

	['WEAPON_ASSAULTRIFLE_MK2'] = {
		label = 'Assault Rifle MK2',
		weight = 3300,
		durability = 0.6,
		ammoname = 'ammo-rifle2',
	},

	['WEAPON_ASSAULTSHOTGUN'] = {
		label = 'Assault Shotgun',
		weight = 3100,
		ammoname = 'ammo-shotgun'
	},

	['WEAPON_ASSAULTSMG'] = {
		label = 'Assault SMG',
		weight = 2850,
		durability = 0.6,
		ammoname = 'ammo-rifle'
	},

	['WEAPON_BALL'] = {
		label = 'Ball',
		weight = 149,
		throwable = true,
	},

	['WEAPON_BAT'] = {
		label = 'Bat',
		weight = 1134,
		durability = 1.0,
	},

	['WEAPON_BATTLEAXE'] = {
		label = 'Battle Axe',
		weight = 1200,
		durability = 5.0,
	},

	['WEAPON_BOTTLE'] = {
		label = 'Bottle',
		weight = 350,
		durability = 5.0,
	},

	['WEAPON_BULLPUPRIFLE'] = {
		label = 'Bullpup Rifle',
		weight = 2900,
		durability = 0.9,
		ammoname = 'ammo-rifle'
	},

	['WEAPON_BULLPUPRIFLE_MK2'] = {
		label = 'Bullpup Rifle MK2',
		weight = 2900,
		durability = 0.7,
		ammoname = 'ammo-rifle'
	},

	['WEAPON_BULLPUPSHOTGUN'] = {
		label = 'Bullpup Shotgun',
		weight = 3100,
		ammoname = 'ammo-shotgun'
	},

	['WEAPON_BZGAS'] = {
		label = 'BZ Gas',
		weight = 600,
		throwable = true,
	},

	['WEAPON_CARBINERIFLE'] = {
		label = 'Carbine Rifle',
		weight = 3100,
		durability = 0.8,
		ammoname = 'ammo-rifle'
	},

	['WEAPON_CARBINERIFLE_MK2'] = {
		label = 'Carbine Rifle MK2',
		weight = 3000,
		durability = 0.7,
		ammoname = 'ammo-rifle'
	},

	['WEAPON_CERAMICPISTOL'] = {
		label = 'Ceramic Pistol',
		weight = 700,
		ammoname = 'ammo-9'
	},

	['WEAPON_COMBATMG'] = {
		label = 'Combat MG',
		weight = 10000,
		ammoname = 'ammo-rifle'
	},

	['WEAPON_COMBATMG_MK2'] = {
		label = 'Combat MG MK2',
		weight = 10500,
		ammoname = 'ammo-rifle2'
	},

	['WEAPON_COMBATPDW'] = {
		label = 'Combat PDW',
		weight = 2700,
		durability = 3.0,
		ammoname = 'ammo-9'
	},

	['WEAPON_COMBATPISTOL'] = {
		label = 'Combat Pistol',
		weight = 970,
		durability = 0.5,
		ammoname = 'ammo-9'
	},

	['WEAPON_COMBATSHOTGUN'] = {
		label = 'Combat Shotgun',
		weight = 4400,
		ammoname = 'ammo-shotgun'
	},

	['WEAPON_COMPACTRIFLE'] = {
		label = 'Compact Rifle',
		weight = 2700,
		durability = 0.7,
		ammoname = 'ammo-rifle2'
	},

	['WEAPON_CROWBAR'] = {
		label = 'Crowbar',
		weight = 2500,
		durability = 1.0,
	},

	['WEAPON_DAGGER'] = {
		label = 'Dagger',
		weight = 800,
		durability = 1.0,
	},

	['WEAPON_DBSHOTGUN'] = {
		label = 'Double Barrel Shotgun',
		weight = 3175,
		ammoname = 'ammo-shotgun'
	},

	['WEAPON_DOUBLEACTION'] = {
		label = 'Double Action Revolver',
		weight = 940,
		durability = 0.8,
		ammoname = 'ammo-38'
	},

	['WEAPON_FIREEXTINGUISHER'] = {
		label = 'Fire Extinguisher',
		weight = 8616,
	},

	['WEAPON_FIREWORK'] = {
		label = 'Firework Launcher',
		weight = 1000,
	},

	['WEAPON_FLARE'] = {
		label = 'Flare',
		weight = 235,
		throwable = true,
	},

	['WEAPON_FLAREGUN'] = {
		label = 'Flare Gun',
		weight = 1000,
		durability = 1.0,
		ammoname = 'ammo-flare'
	},

	['WEAPON_FLASHLIGHT'] = {
		label = 'Flashlight',
		weight = 125,
		durability = 1.0,
	},

	['WEAPON_GOLFCLUB'] = {
		label = 'Golf Club',
		weight = 330,
		durability = 1.0,
	},

	['WEAPON_GRENADE'] = {
		label = 'Grenade',
		weight = 600,
		throwable = true,
	},

	['WEAPON_GUSENBERG'] = {
		label = 'Gusenberg',
		weight = 4900,
		durability = 0.8,
		ammoname = 'ammo-45'
	},

	['WEAPON_HAMMER'] = {
		label = 'Hammer',
		weight = 1200,
		durability = 1.0,
	},

	['WEAPON_HATCHET'] = {
		label = 'Hatchet',
		weight = 1000,
		durability = 1.0,
	},

	['WEAPON_HAZARDCAN'] = {
		label = 'Hazard Can',
		weight = 12000,
	},

	['WEAPON_HEAVYPISTOL'] = {
		label = 'Heavy Pistol',
		weight = 1100,
		durability = 0.6,
		ammoname = 'ammo-45'
	},

	['WEAPON_HEAVYSHOTGUN'] = {
		label = 'Heavy Shotgun',
		weight = 3600,
		ammoname = 'ammo-shotgun'
	},

	['WEAPON_HEAVYSNIPER'] = {
		label = 'Heavy Sniper',
		weight = 14000,
		ammoname = 'ammo-heavysniper'
	},

	['WEAPON_HEAVYSNIPER_MK2'] = {
		label = 'Heavy Sniper MK2',
		weight = 10432,
		ammoname = 'ammo-heavysniper'
	},

	['WEAPON_KNIFE'] = {
		label = 'Knife',
		weight = 300,
		durability = 1.0,
	},

	['WEAPON_KNUCKLE'] = {
		label = 'Knuckle Dusters',
		weight = 300,
		durability = 1.0,
	},

	['WEAPON_MACHETE'] = {
		label = 'Machete',
		weight = 1000,
		durability = 1.0,
	},

	['WEAPON_MACHINEPISTOL'] = {
		label = 'Machine Pistol',
		weight = 1400,
		durability = 0.7,
		ammoname = 'ammo-9'
	},

	['WEAPON_MARKSMANPISTOL'] = {
		label = 'Marksman Pistol',
		weight = 1588,
		durability = 4.0,
		ammoname = 'ammo-22'
	},

	['WEAPON_MARKSMANRIFLE'] = {
		label = 'Marksman Rifle',
		weight = 7500,
		ammoname = 'ammo-sniper'
	},

	['WEAPON_MARKSMANRIFLE_MK2'] = {
		label = 'Marksman Rifle',
		weight = 4000,
		ammoname = 'ammo-sniper'
	},

	['WEAPON_MG'] = {
		label = 'Machine Gun',
		weight = 9000,
		ammoname = 'ammo-rifle2'
	},

	['WEAPON_MICROSMG'] = {
		label = 'Micro SMG',
		weight = 4000,
		durability = 0.6,
		ammoname = 'ammo-45'
	},

	['WEAPON_MILITARYRIFLE'] = {
		label = 'Military Rifle',
		weight = 3600,
		ammoname = 'ammo-rifle'
	},

	['WEAPON_MINISMG'] = {
		label = 'Mini SMG',
		weight = 2770,
		durability = 0.6,
		ammoname = 'ammo-9'
	},

	['WEAPON_MOLOTOV'] = {
		label = 'Molotov',
		weight = 1800,
		throwable = true,
	},

	['WEAPON_MUSKET'] = {
		label = 'Musket',
		weight = 4500,
		durability = 1.0,
		ammoname = 'ammo-musket'
	},

	['WEAPON_NAVYREVOLVER'] = {
		label = 'Navy Revolver',
		weight = 2000,
		ammoname = 'ammo-44'
	},

	['WEAPON_NIGHTSTICK'] = {
		label = 'Nightstick',
		weight = 1000,
		durability = 1.0,
	},

	['WEAPON_PETROLCAN'] = {
		label = 'Gas Can',
		weight = 12000,
	},

	['WEAPON_PIPEBOMB'] = {
		label = 'Pipe Bomb',
		weight = 1800,
		throwable = true,
	},

	['WEAPON_PISTOL'] = {
		label = 'Pistol',
		weight = 970,
		durability = 0.6,
		ammoname = 'ammo-9',
	},

	['WEAPON_PISTOL50'] = {
		label = 'Pistol .50',
		weight = 2000,
		durability = 0.8,
		ammoname = 'ammo-50'
	},

	['WEAPON_PISTOL_MK2'] = {
		label = 'Pistol MK2',
		weight = 970,
		durability = 0.5,
		ammoname = 'ammo-9'
	},

	['WEAPON_POOLCUE'] = {
		label = 'Pool Cue',
		weight = 146,
	},

	['WEAPON_PROXMINE'] = {
		label = 'Proximity Mine',
		weight = 2500,
		throwable = true,
	},

	['WEAPON_PUMPSHOTGUN'] = {
		label = 'Pump Shotgun',
		weight = 3400,
		durability = 0.8,
		ammoname = 'ammo-shotgun'
	},

	['WEAPON_PUMPSHOTGUN_MK2'] = {
		label = 'Pump Shotgun MK2',
		weight = 3200,
		durability = 0.7,
		ammoname = 'ammo-shotgun'
	},

	['WEAPON_REVOLVER'] = {
		label = 'Revolver',
		weight = 2260,
		durability = 0.8,
		ammoname = 'ammo-44'
	},

	['WEAPON_REVOLVER_MK2'] = {
		label = 'Revolver MK2',
		weight = 1500,
		durability = 0.7,
		ammoname = 'ammo-44'
	},

	['WEAPON_SAWNOFFSHOTGUN'] = {
		label = 'Sawn Off Shotgun',
		weight = 2380,
		durability = 0.9,
		ammoname = 'ammo-shotgun'
	},

	['WEAPON_SMG'] = {
		label = 'SMG',
		weight = 3084,
		durability = 0.8,
		ammoname = 'ammo-9'
	},

	['WEAPON_SMG_MK2'] = {
		label = 'SMG Mk2',
		weight = 2700,
		durability = 0.7,
		ammoname = 'ammo-9'
	},

	['WEAPON_SMOKEGRENADE'] = {
		label = 'Smoke Grenade',
		weight = 600,
		throwable = true,
	},

	['WEAPON_SNIPERRIFLE'] = {
		label = 'Sniper Rifle',
		weight = 6500,
		ammoname = 'ammo-sniper'
	},

	['WEAPON_SNOWBALL'] = {
		label = 'Snow Ball',
		weight = 5,
		throwable = true,
	},

	['WEAPON_SNSPISTOL'] = {
		label = 'SNS Pistol',
		weight = 465,
		durability = 0.7,
		ammoname = 'ammo-45'
	},

	['WEAPON_SNSPISTOL_MK2'] = {
		label = 'SNS Pistol MK2',
		weight = 465,
		durability = 0.6,
		ammoname = 'ammo-45'
	},

	['WEAPON_SPECIALCARBINE'] = {
		label = 'Special Carbine',
		weight = 3000,
		durability = 0.8,
		ammoname = 'ammo-rifle'
	},

	['WEAPON_SPECIALCARBINE_MK2'] = {
		label = 'Special Carbine MK2',
		weight = 3370,
		durability = 0.7,
		ammoname = 'ammo-rifle'
	},

	['WEAPON_STICKYBOMB'] = {
		label = 'Sticky Bomb',
		weight = 1000,
		throwable = true,
	},

	['WEAPON_STONE_HATCHET'] = {
		label = 'Stone Hatchet',
		weight = 800,
		durability = 1.0,
	},

	['WEAPON_STUNGUN'] = {
		label = 'Tazer',
		weight = 227,
		durability = 0.6,
	},

	['WEAPON_SWEEPERSHOTGUN'] = {
		label = 'Sweeper Shotgun',
		weight = 4400,
		ammoname = 'ammo-shotgun'
	},

	['WEAPON_SWITCHBLADE'] = {
		label = 'Switch Blade',
		weight = 300,
		durability = 1.0,
	},

	['WEAPON_VINTAGEPISTOL'] = {
		label = 'Vintage Pistol',
		weight = 100,
		durability = 0.7,
		ammoname = 'ammo-9'
	},

	['WEAPON_WRENCH'] = {
		label = 'Wrench',
		weight = 2500,
		durability = 1.0,
	},
}
