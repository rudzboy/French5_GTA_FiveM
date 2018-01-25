config.jobs['plane_cargo'] = {
    ["name"] = "Pilote Avion",
    ["requiredId"] = 13,
    ["vehicle"] = {
        ["model"] = 'vestra',
        ['blip'] = {
            ['label'] = 'Avion : Véhicule',
            ['id'] = 90,
            ['color'] = 26
        },
    },
    ["positions"] = {
        ["vehicle"] = {
            ['type'] = "vehicle",
            ['nextRoute'] = "harvest",
            ['delay'] = 0,
            ['x'] = -1271.22,
            ['y'] = -3380.75,
            ['z'] = 13.94,
            ['h'] = 320.0,
            ['blip'] = {
                ['label'] = 'Avion : Aéroport',
                ['id'] = 90,
                ['color'] = 26
            },
            ['marker'] = {
                ['r'] = 120,
                ['g'] = 120,
                ['b'] = 255,
                ['a'] = 70
            }
        },
        ["harvest"] = {
            ['type'] = "harvest",
            ['nextRoute'] = "transform",
            ['delay'] = 15000,
            ['x'] = 1700.5,
            ['y'] = 3265.65,
            ['z'] = 41.1493,
            ['blip'] = {
                ['label'] = 'Avion : Chargement',
                ['id'] = 68,
                ['color'] = 26
            },
            ['marker'] = {
                ['r'] = 120,
                ['g'] = 120,
                ['b'] = 255,
                ['a'] = 70
            }
        },
        ["transform"] = {
            ['type'] = "transform",
            ['nextRoute'] = "sell",
            ['delay'] = 25000,
            ['x'] = -1888.25,
            ['y'] = 2992.38,
            ['z'] = 32.8102,
            ['blip'] = {
                ['label'] = 'Avion : Point de livraison',
                ['id'] = 365,
                ['color'] = 26
            },
            ['marker'] = {
                ['r'] = 120,
                ['g'] = 120,
                ['b'] = 255,
                ['a'] = 70
            }
        },
        ["sell"] = {
            ['type'] = "sell",
            ['nextRoute'] = "vehicle",
            ['delay'] = 2000,
            ['x'] = -1633.19,
            ['y'] = -3098.54,
            ['z'] = 13.9448,
            ['blip'] = {
                ['label'] = 'Avion : Paiement après livraison',
                ['id'] = 434,
                ['color'] = 26
            },
            ['marker'] = {
                ['r'] = 255,
                ['g'] = 80,
                ['b'] = 25,
                ['a'] = 70
            }
        }
    },
    ["isLegal"] = true,
    ["navigation"] = true,
    ["requireService"] = false,
    ["marketValue"] = 1300,
    ["harvestedItemId"] = 20,
    ["sellableItemId"] = 21,
    ["maximumQuantity"] = 1,
    ["drawMarkerDistance"] = 100,
    ["actionRequiredDistance"] = 10
}
