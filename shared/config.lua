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
	settings = {
		homies = 'business',
		homieWeapons = {`WEAPON_MICROSMG`, `WEAPON_COMBATMG_MK2`},

		vehicleHealthPerRound = 100,

		vehicles = {
			['Savage'] = {vehicle = 'savage'},
			['Hunter'] = {vehicle = 'hunter'},
			['Buzzard'] = {vehicle = 'buzzard'},
		},
	},
	missions = {
		['Brown Thunder'] = {
			name = 'Brown Thunder',
			description = 'Hunt a triplet of random targets',
			category = 'Static',

			cluster = false,
			distance = {500, 1500},

			targetPeds = 'prisoners',
			targetWeapons = {`WEAPON_ASSAULTRIFLE`, `WEAPON_COMPACTRIFLE`, `WEAPON_MICROSMG`, `WEAPON_SAWNOFFSHOTGUN`},
			targets = {
				{type = {'automobile', 'bike'}},
				'copy',
				'copy',
			}
		},
		['Motorcade'] = {
			name = 'Motorcade',
			description = 'Hunt 3 armoured targets',
			category = 'Static',

			cluster = true,
			distance = {500, 1500},

			targetPeds = 'bodyguard',
			targetWeapons = {`WEAPON_APPISTOL`, `WEAPON_CARBINERIFLE`},
			targets = {
				{model = {'cog552', 'cognoscenti2', 'schafter5', 'schafter6', 'baller5', 'baller6', 'xls2', 'limo2'}},
				'repeat',
				'repeat',
			},
		},
	},
}
