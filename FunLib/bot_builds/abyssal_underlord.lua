local RI = require(GetScriptDirectory()..'/FunLib/bot_builds/util_role_item')

local X = {}

local sUtility = {"item_crimson_guard", "item_lotus_orb", "item_heavens_halberd"}
local sUtilityItem = RI.GetBestUtilityItem(sUtility)

X.TalentBuild = {
    ['pos_1'] = { },
    ['pos_2'] = { },
    ['pos_3'] = {
        [1] = {
            ['t25'] = {0, 10},
            ['t20'] = {0, 10},
            ['t15'] = {10, 0},
            ['t10'] = {10, 0},
        },
    },
    ['pos_4'] = { },
    ['pos_5'] = { },
}

-- ========================================================================================== -

X.AbilityBuild = {
    ['pos_1'] = { },
    ['pos_2'] = { },
    ['pos_3'] = {
        [1] = {1,3,1,3,1,2,1,6,2,2,2,6,3,3,6},
    },
    ['pos_4'] = { },
    ['pos_5'] = { },
}

-- ========================================================================================== -

X.BuyList = {
    ['pos_1'] = { },
    ['pos_2'] = { },
    ['pos_3'] = {
        [1] = {
            "item_tango",
            "item_double_branches",
            "item_quelling_blade",
            "item_double_gauntlets",

            "item_bracer",
            "item_helm_of_iron_will",
            "item_soul_ring",
            "item_arcane_boots",
            "item_magic_wand",
            "item_veil_of_discord",
            "item_mekansm",
            "item_pipe",--
            "item_guardian_greaves",--
            sUtilityItem,--
            "item_aghanims_shard",
            "item_shivas_guard",--
            "item_octarine_core",--
            "item_sheepstick",--
            "item_ultimate_scepter_2",
            "item_moon_shard",
        }
    },
    ['pos_4'] = { },
    ['pos_5'] = { },
}

-- ========================================================================================== -

X.SellList = {
    ['pos_1'] = { },
    ['pos_2'] = { },
    ['pos_3'] = {
        [1] = {
            "item_quelling_blade",
            "item_bracer",
            "item_soul_ring",
            "item_magic_wand",
        },
    },
    ['pos_4'] = { },
    ['pos_5'] = { },
}

return X