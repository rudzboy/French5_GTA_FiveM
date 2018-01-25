config.jobs['fishing'] = {
    ["name"] = "Pêche",
    ["requiredId"] = 6,
    ["vehicle"] = {
        ["model"] = 'tug',
        ['blip'] = {
            ['label'] = 'Pêche : Chalutier',
            ['id'] = 427,
            ['color'] = 38
        },
        ["spawn"] = {
            ['x'] = -457.472,
            ['y'] = -2904.14,
            ['z'] = 4.5,
            ['h'] = 135.0,
        }
    },
    ["positions"] = {
        ["service"] = {
            ['type'] = "service",
            ['delay'] = 0,
            ['x'] = -334.255,
            ['y'] = -2793.1,
            ['z'] = 5.0001,
            ['blip'] = {
                ['label'] = 'Pêche : Service',
                ['id'] = 366,
                ['color'] = 3
            },
            ['skin'] = {
                ['mp_m_freemode_01'] = {
                    ['components'] = {
                        {3,1,0,2},
                        {4,7,3,2},
                        {6,43,2,2},
                        {8,15,0,2},
                        {11,218,2,2},
                    },
                    ['props'] = {
                        {0,5,1,0}
                    }
                },
                ['mp_f_freemode_01'] = {
                    ['components'] = {
                        {3,1,0,2},
                        {4,61,5,2},
                        {6,36,1,2},
                        {8,15,0,2},
                        {11,190,5,2},
                    },
                    ['props'] = {
                        {0,5,5,0}
                    }
                }
            },
            ['marker'] = {
                ['r'] = 0,
                ['g'] = 80,
                ['b'] = 255,
                ['a'] = 150
            }
        },
        ["vehicle"] = {
            ['type'] = "vehicle",
            ['nextRoute'] = "harvest",
            ['delay'] = 0,
            ['x'] = -457.472,
            ['y'] = -2904.14,
            ['z'] = 1.0,
            ['h'] = 135.0,
            ['blip'] = {
                ['label'] = 'Pêche : Dépôt de véhicule',
                ['id'] = 266,
                ['color'] = 3
            },
            ['marker'] = {
                ['r'] = 0,
                ['g'] = 80,
                ['b'] = 255,
                ['a'] = 150
            }
        },
        ["harvest"] = {
            ['type'] = "harvest",
            ['nextRoute'] = "sell",
            ['delay'] = 500,
            ['x'] = -378.21,
            ['y'] = -3463.21,
            ['z'] = 1.2,
            ['blip'] = {
                ['label'] = 'Pêche : Zone de pêche',
                ['id'] = 68,
                ['color'] = 3
            },
            ['marker'] = {
                ['r'] = 0,
                ['g'] = 80,
                ['b'] = 255,
                ['a'] = 150
            }
        },
        ["sell"] = {
            ['type'] = "sell",
            ['nextRoute'] = "vehicle",
            ['delay'] = 2000,
            ['x'] = -28.34,
            ['y'] = -2821.12,
            ['z'] = 1.2,
            ['blip'] = {
                ['label'] = 'Pêche : Criée',
                ['id'] = 434,
                ['color'] = 3
            },
            ['marker'] = {
                ['r'] = 0,
                ['g'] = 80,
                ['b'] = 255,
                ['a'] = 150
            }
        }
    },
    ["isLegal"] = true,
    ["navigation"] = true,
    ["requireService"] = true,
    ["marketValue"] = 3,
    ["harvestedItemId"] = 13,
    ["sellableItemId"] = 13,
    ["maximumQuantity"] = 500,
    ["drawMarkerDistance"] = 30,
    ["actionRequiredDistance"] = 25
}
