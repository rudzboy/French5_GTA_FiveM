config.jobs['concrete_delivery'] = {
    ["name"] = "Livreur Béton",
    ["requiredId"] = 7,
    ["vehicle"] = {
        ["model"] = 'mixer2',
        ['blip'] = {
            ['label'] = 'Béton : Véhicule',
            ['id'] = 318,
            ['color'] = 81
        },
    },
    ["positions"] = {
        ["vehicle"] = {
            ['type'] = "vehicle",
            ['nextRoute'] = "harvest",
            ['delay'] = 0,
            ['x'] = 2771.57,
            ['y'] = 2806.17,
            ['z'] = 41.4181,
            ['h'] = 300.0,
            ['blip'] = {
                ['label'] = 'Béton : Dépôt de véhicule',
                ['id'] = 318,
                ['color'] = 20
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
            ['x'] = 2950.89,
            ['y'] = 2748.44,
            ['z'] = 43.4897,
            ['blip'] = {
                ['label'] = 'Béton : Extraction',
                ['id'] = 68,
                ['color'] = 20
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
            ['x'] = 2931.88,
            ['y'] = 4309.97,
            ['z'] = 50.8667,
            ['blip'] = {
                ['label'] = 'Béton : Solidification',
                ['id'] = 365,
                ['color'] = 20
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
            ['x'] = 102.586,
            ['y'] = -344.931,
            ['z'] = 42.0919,
            ['blip'] = {
                ['label'] = 'Béton : Vente',
                ['id'] = 434,
                ['color'] = 20
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
    ["marketValue"] = 55,
    ["harvestedItemId"] = 14,
    ["sellableItemId"] = 15,
    ["maximumQuantity"] = 15,
    ["drawMarkerDistance"] = 25,
    ["actionRequiredDistance"] = 5
}
