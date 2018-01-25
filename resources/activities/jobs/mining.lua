config.jobs['mining'] = {
    ["name"] = "Mineur",
    ["requiredId"] = 4,
    ["positions"] = {
        ["service"] = {
            ['type'] = "service",
            ['delay'] = 0,
            ['x'] = -601.64,
            ['y'] = 2091.36,
            ['z'] = 131.445,
            ['blip'] = {
                ['label'] = 'Mineur : Service',
                ['id'] = 366,
                ['color'] = 46
            },
            ['weapons'] = {
                "WEAPON_FLASHLIGHT"
            },
            ['skin'] = {
                ['mp_m_freemode_01'] = {
                    ['components'] = {
                        {3,34,0,2},
                        {4,0,12,2},
                        {6,25,0,2},
                        {8,59,0,2},
                        {11,5,0,2},
                    }
                },
                ['mp_f_freemode_01'] = {
                    ['components'] = {
                        {3,11,0,2},
                        {4,35,0,2},
                        {6,26,1,2},
                        {8,36,0,2},
                        {11,11,2,2},
                    }
                }
            },
            ['marker'] = {
                ['r'] = 255,
                ['g'] = 215,
                ['b'] = 0,
                ['a'] = 120
            }
        },
        ["harvest"] = {
            ['type'] = "harvest",
            ['nextRoute'] = "transform",
            ['delay'] = 8000,
            ['x'] = -426.862,
            ['y'] = 2063.8,
            ['z'] = 120.452,
            ['blip'] = {
                ['label'] = 'Mineur : Mine d\'or',
                ['id'] = 68,
                ['color'] = 46
            },
            ['marker'] = {
                ['r'] = 255,
                ['g'] = 215,
                ['b'] = 0,
                ['a'] = 120
            }
        },
        ["transform"] = {
            ['type'] = "transform",
            ['nextRoute'] = "sell",
            ['delay'] = 13000,
            ['x'] = 1073.2,
            ['y'] = -1948.92,
            ['z'] = 31.0176,
            ['blip'] = {
                ['label'] = 'Mineur : Extraction',
                ['id'] = 365,
                ['color'] = 46
            },
            ['marker'] = {
                ['r'] = 255,
                ['g'] = 215,
                ['b'] = 0,
                ['a'] = 120
            }
        },
        ["sell"] = {
            ['type'] = "sell",
            ['nextRoute'] = "harvest",
            ['delay'] = 10000,
            ['x'] = -637.88,
            ['y'] = -235.0,
            ['z'] = 37.8656,
            ['blip'] = {
                ['label'] = 'Mineur : Vente',
                ['id'] = 434,
                ['color'] = 46
            },
            ['marker'] = {
                ['r'] = 255,
                ['g'] = 215,
                ['b'] = 0,
                ['a'] = 120
            }
        }
    },
    ["isLegal"] = true,
    ["navigation"] = true,
    ["requireService"] = true,
    ["marketValue"] = 480,
    ["harvestedItemId"] = 24,
    ["sellableItemId"] = 25,
    ["maximumQuantity"] = 5,
    ["drawMarkerDistance"] = 25,
    ["actionRequiredDistance"] = 5
}
