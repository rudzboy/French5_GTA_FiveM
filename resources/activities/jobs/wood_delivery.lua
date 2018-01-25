config.jobs['wood_delivery'] = {
    ["name"] = "Livreur Bois",
    ["requiredId"] = 10,
    ["vehicle"] = {
        ["model"] = 'scrap',
        ['blip'] = {
            ['label'] = 'Bois : Véhicule',
            ['id'] = 318,
            ['color'] = 81
        },
    },
    ["positions"] = {
        ["vehicle"] = {
            ['type'] = "vehicle",
            ['nextRoute'] = "harvest",
            ['delay'] = 0,
            ['x'] = -577.859,
            ['y'] = 5327.66,
            ['z'] = 70.2606,
            ['h'] = 165.0,
            ['blip'] = {
                ['label'] = 'Bois : Dépôt de véhicule',
                ['id'] = 318,
                ['color'] = 81
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
            ['nextRoute'] = "sell",
            ['delay'] = 5000,
            ['x'] = -512.788,
            ['y'] = 5243.79,
            ['z'] = 80.3041,
            ['blip'] = {
                ['label'] = 'Bois : Extraction',
                ['id'] = 68,
                ['color'] = 81
            },
            ['marker'] = {
                ['r'] = 200,
                ['g'] = 255,
                ['b'] = 200,
                ['a'] = 70
            }
        },
        ["sell"] = {
            ['type'] = "sell",
            ['nextRoute'] = "vehicle",
            ['delay'] = 5000,
            ['x'] = 1198.73,
            ['y'] = -1359.63,
            ['z'] = 35.2266,
            ['blip'] = {
                ['label'] = 'Bois : Vente',
                ['id'] = 434,
                ['color'] = 81
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
    ["marketValue"] = 79,
    ["harvestedItemId"] = 12,
    ["sellableItemId"] = 12,
    ["maximumQuantity"] = 10,
    ["drawMarkerDistance"] = 25,
    ["actionRequiredDistance"] = 5
} 
