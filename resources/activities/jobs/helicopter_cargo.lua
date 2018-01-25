config.jobs['helicopter_cargo'] = {
    ["name"] = "Pilote Hélicoptère",
    ["requiredId"] = 12,
    ["vehicle"] = {
        ["model"] = 'cargobob2',
        ['blip'] = {
            ['label'] = 'Hélicoptère : Véhicule',
            ['id'] = 43,
            ['color'] = 38
        },
    },
    ["positions"] = {
        ["vehicle"] = {
            ['type'] = "vehicle",
            ['nextRoute'] = "harvest",
            ['delay'] = 0,
            ['x'] = 1770.5,
            ['y'] = 3239.58,
            ['z'] = 42.137,
            ['h'] = 200.0,
            ['blip'] = {
                ['label'] = 'Hélicoptère : Héliport',
                ['id'] = 43,
                ['color'] = 50
            },
            ['marker'] = {
                ['r'] = 255,
                ['g'] = 80,
                ['b'] = 25,
                ['a'] = 70
            }
        },
        ["harvest"] = {
            ['type'] = "harvest",
            ['nextRoute'] = "transform",
            ['delay'] = 15000,
            ['x'] = 305.55,
            ['y'] = 2832.1,
            ['z'] = 43.432,
            ['blip'] = {
                ['label'] = 'Hélicoptère : Chargement',
                ['id'] = 68,
                ['color'] = 50
            },
            ['marker'] = {
                ['r'] = 255,
                ['g'] = 80,
                ['b'] = 25,
                ['a'] = 70
            }
        },
        ["transform"] = {
            ['type'] = "transform",
            ['nextRoute'] = "sell",
            ['delay'] = 25000,
            ['x'] = -162.2,
            ['y'] = -995.3,
            ['z'] = 254.133,
            ['blip'] = {
                ['label'] = 'Hélicoptère : Point de livraison',
                ['id'] = 365,
                ['color'] = 50
            },
            ['marker'] = {
                ['r'] = 255,
                ['g'] = 80,
                ['b'] = 25,
                ['a'] = 70
            }
        },
        ["sell"] = {
            ['type'] = "sell",
            ['nextRoute'] = "vehicle",
            ['delay'] = 2000,
            ['x'] = 1737.0,
            ['y'] = 3285.0,
            ['z'] = 41.142,
            ['blip'] = {
                ['label'] = 'Hélicoptère : Paiement après livraison',
                ['id'] = 434,
                ['color'] = 50
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
    ["harvestedItemId"] = 18,
    ["sellableItemId"] = 19,
    ["maximumQuantity"] = 1,
    ["drawMarkerDistance"] = 100,
    ["actionRequiredDistance"] = 10
}