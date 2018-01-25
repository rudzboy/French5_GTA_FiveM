config.jobs['garbage_collector'] = {
    ["name"] = "Recyclage",
    ["requiredId"] = 8,
    ["vehicle"] = {
        ["model"] = 'biff',
        ['blip'] = {
            ['label'] = 'Recyclage : Véhicule',
            ['id'] = 318,
            ['color'] = 81
        }
    },
    ["positions"] = {
        ["vehicle"] = {
            ['type'] = "vehicle",
            ['nextRoute'] = "harvest",
            ['delay'] = 0,
            ['x'] = 918.294,
            ['y'] = 3566.64,
            ['z'] = 33.7586,
            ['h'] = 0.0,
            ['blip'] = {
                ['label'] = 'Recyclage : Dépôt de véhicule',
                ['id'] = 318,
                ['color'] = 51
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
            ['x'] = 2054.97,
            ['y'] = 3181.22,
            ['z'] = 45.1689,
            ['blip'] = {
                ['label'] = 'Recyclage : Déchetterie',
                ['id'] = 68,
                ['color'] = 51
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
            ['x'] = 2349.79,
            ['y'] = 3133.11,
            ['z'] = 48.2089,
            ['blip'] = {
                ['label'] = 'Recyclage : Traitement',
                ['id'] = 365,
                ['color'] = 51
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
            ['x'] = 1245.72,
            ['y'] = 1861.15,
            ['z'] = 79.6781,
            ['blip'] = {
                ['label'] = 'Recyclage : Vente',
                ['id'] = 434,
                ['color'] = 51
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
    ["marketValue"] = 128,
    ["harvestedItemId"] = 8,
    ["sellableItemId"] = 9,
    ["maximumQuantity"] = 10,
    ["drawMarkerDistance"] = 25,
    ["actionRequiredDistance"] = 5
}
