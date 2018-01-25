config.jobs['taxi'] = {
    ["name"] = "Taxi",
    ["requiredId"] = 5,
    ["vehicle"] = {
        ["model"] = 'taxi',
        ['blip'] = {
            ['label'] = 'Taxi : Véhicule',
            ['id'] = 198,
            ['color'] = 5
        },
    },
    ["positions"] = {
        ["service"] = {
            ['type'] = "service",
            ['delay'] = 0,
            ['x'] = 895.288,
            ['y'] = -179.141,
            ['z'] = 74.7003,
            ['blip'] = {
                ['label'] = 'Taxi : Service',
                ['id'] = 366,
                ['color'] = 28
            },
            ['marker'] = {
                ['r'] = 239,
                ['g'] = 203,
                ['b'] = 0,
                ['a'] = 140
            }
        },
        ["vehicle"] = {
            ['type'] = "vehicle",
            ['delay'] = 0,
            ['x'] = 908.521,
            ['y'] = -176.641,
            ['z'] = 73.7818,
            ['h'] = 240.0,
            ['blip'] = {
                ['label'] = 'Taxi : Dépôt de véhicule',
                ['id'] = 198,
                ['color'] = 28
            },
            ['marker'] = {
                ['r'] = 239,
                ['g'] = 203,
                ['b'] = 0,
                ['a'] = 140
            }
        }
    },
    ["isLegal"] = true,
    ["navigation"] = false,
    ["requireService"] = true,
    ["drawMarkerDistance"] = 25,
    ["actionRequiredDistance"] = 5
}