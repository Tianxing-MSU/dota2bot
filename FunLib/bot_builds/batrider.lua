local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

-- local sUtility = {}
-- local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {0, 10},
        }
    },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {0, 10},
            ['t10'] = {0, 10},
        }
    },
    ['pos_4'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
    ['pos_5'] = {
        [1] = {
            ['t25'] = {10, 0},
            ['t20'] = {10, 0},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        }
    },
}

X.AbilityBuild = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {1,3,1,2,1,6,1,3,3,3,6,2,2,2,6},
    },
    ['pos_3'] = {
        [1] = {1,2,1,3,1,6,1,3,3,3,2,6,2,2,6},
    },
    ['pos_4'] = {
        [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
    },
    ['pos_5'] = {
        [1] = {2,3,3,1,3,6,3,1,1,1,6,2,2,2,6},
    },
}

X.BuyList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_double_branches",
            "item_faerie_fire",
        
            "item_bottle",
            "item_magic_wand",
            "item_travel_boots",
            "item_blink",
            "item_black_king_bar",--
            "item_octarine_core",--
            "item_shivas_guard",--
            "item_ultimate_scepter",
            "item_refresher",--
            "item_overwhelming_blink",--
            "item_ultimate_scepter_2",
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_gauntlets",
            "item_circlet",
            "item_double_branches",
        
            "item_bracer",
            "item_boots",
            "item_magic_wand",
            "item_wind_lace",
            "item_veil_of_discord",
            "item_blink",
            "item_black_king_bar",--
            "item_travel_boots",
            "item_shivas_guard",--
            "item_ultimate_scepter",
            "item_octarine_core",--
            "item_refresher",--
            "item_overwhelming_blink",--
            "item_ultimate_scepter_2",
            "item_travel_boots_2",--
            "item_aghanims_shard",
            "item_moon_shard",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_circlet",
            "item_blood_grenade",
        
            "item_boots",
            "item_magic_wand",
            "item_tranquil_boots",
            "item_blink",
            "item_force_staff",--
            "item_black_king_bar",--
            "item_boots_of_bearing",--
            "item_shivas_guard",--
            "item_wind_waker",--
            "item_arcane_blink",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_double_tango",
            "item_double_branches",
            "item_circlet",
            "item_blood_grenade",
        
            "item_boots",
            "item_magic_wand",
            "item_arcane_boots",
            "item_blink",
            "item_force_staff",--
            "item_black_king_bar",--
            "item_guardian_greaves",--
            "item_shivas_guard",--
            "item_wind_waker",--
            "item_arcane_blink",--
            "item_aghanims_shard",
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
}

X.SellList = {
    ['pos_1'] = {},
    ['pos_2'] = {
        [1] = {
            "item_branches",
            "item_bottle",
            "item_magic_wand",
        }
    },
    ['pos_3'] = {
        [1] = {
            "item_magic_wand",
        }
    },
    ['pos_4'] = {
        [1] = {
            "item_circlet",
            "item_magic_wand",
        }
    },
    ['pos_5'] = {
        [1] = {
            "item_circlet",
            "item_magic_wand",
        }
    },
}

return X