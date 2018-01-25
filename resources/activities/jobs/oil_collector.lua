config.jobs['oil_collector'] = {
    ["name"] = "Livreur Pétrole",
    ["requiredId"] = 9,
    ["vehicle"] = {
        ["model"] = 'hauler',
        ['blip'] = {
            ['label'] = 'Pétrole : Véhicule',
            ['id'] = 318,
            ['color'] = 81
        },
    },
    ["positions"] = {
        ["vehicle"] = {
            ['type'] = "vehicle",
            ['nextRoute'] = "harvest",
            ['delay'] = 0,
            ['x'] = 1763.3,
            ['y'] = -1654.94,
            ['z'] = 112.676,
            ['h'] = 265.0,
            ['blip'] = {
                ['label'] = 'Pétrole : Dépôt de véhicule',
                ['id'] = 318,
                ['color'] = 50
            },
            ['marker'] = {
                ['r'] = 255,
                ['g'] = 255,
                ['b'] = 255,
                ['a'] = 70
            }
        },
        ["harvest"] = {
            ['type'] = "harvest",
            ['nextRoute'] = "transform",
            ['delay'] = 5000,
            ['x'] = 1226.11,
            ['y'] = -2440.85,
            ['z'] = 44.4816,
            ['blip'] = {
                ['label'] = 'Pétrole : Extraction',
                ['id'] = 68,
                ['color'] = 50
            },
            ['marker'] = {
                ['r'] = 200,
                ['g'] = 255,
                ['b'] = 200,
                ['a'] = 70
            }
        },
        ["transform"] = {
            ['type'] = "transform",
            ['nextRoute'] = "sell",
            ['delay'] = 10000,
            ['x'] = 1499.18,
            ['y'] = -1884.87,
            ['z'] = 71.9012,
            ['blip'] = {
                ['label'] = 'Pétrole : Raffinement',
                ['id'] = 365,
                ['color'] = 50
            },
            ['marker'] = {
                ['r'] = 255,
                ['g'] = 255,
                ['b'] = 255,
                ['a'] = 70
            }
        },
        ["sell"] = {
            ['type'] = "sell",
            ['nextRoute'] = "vehicle",
            ['delay'] = 5000,
            ['x'] = 2728.97,
            ['y'] = 1421.84,
            ['z'] = 24.4889,
            ['blip'] = {
                ['label'] = 'Pétrole : Vente',
                ['id'] = 434,
                ['color'] = 50
            },
            ['marker'] = {
                ['r'] = 255,
                ['g'] = 255,
                ['b'] = 255,
                ['a'] = 70
            }
        }
    },
    ["isLegal"] = true,
    ["navigation"] = true,
    ["requireService"] = false,
    ["marketValue"] = 65,
    ["harvestedItemId"] = 10,
    ["sellableItemId"] = 11,
    ["maximumQuantity"] = 10,
    ["drawMarkerDistance"] = 25,
    ["actionRequiredDistance"] = 5
}
 
