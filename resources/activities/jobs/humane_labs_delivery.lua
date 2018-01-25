config.jobs['humane_labs_delivery'] = {
    ["name"] = "Collecteur HumaneLabs",
    ["vehicle"] = {
        ["model"] = 'bagger',
        ['blip'] = {
            ['label'] = 'HumaneLabs : Véhicule',
            ['id'] = 318,
            ['color'] = 38
        },
        ["spawn"] = {
            ['x'] = 3596.55,
            ['y'] = 3661.52,
            ['z'] = 33.872,
            ['h'] = 90.0,
        }
    },
    ["positions"] = {
        ["vehicle"] = {
            ['type'] = "vehicle",
            ['nextRoute'] = "harvest",
            ['delay'] = 0,
            ['x'] = 3479.64,
            ['y'] = 3669.25,
            ['z'] = 33.889,
            ['h'] = 0.0,
            ['blip'] = {
                ['label'] = 'HumaneLabs : Dépôt de véhicule',
                ['id'] = 318,
                ['color'] = 38
            },
            ['marker'] = {
                ['r'] = 50,
                ['g'] = 100,
                ['b'] = 255,
                ['a'] = 70
            }
        },
        ["harvest"] = {
            ['type'] = "harvest",
            ['nextRoute'] = "transform",
            ['delay'] = 5000,
            ['x'] = 1157.79,
            ['y'] = -1596.35,
            ['z'] = 34.6926,
            ['blip'] = {
                ['label'] = 'HumaneLabs : Collecte',
                ['id'] = 68,
                ['color'] = 38
            },
            ['marker'] = {
                ['r'] = 50,
                ['g'] = 100,
                ['b'] = 255,
                ['a'] = 70
            }
        },
        ["transform"] = {
            ['type'] = "transform",
            ['nextRoute'] = "sell",
            ['delay'] = 15000,
            ['x'] = 948.51,
            ['y'] = -1698.09,
            ['z'] = 29.4679,
            ['blip'] = {
                ['label'] = 'HumaneLabs : Congélation',
                ['id'] = 365,
                ['color'] = 38
            },
            ['marker'] = {
                ['r'] = 50,
                ['g'] = 100,
                ['b'] = 255,
                ['a'] = 70
            }
        },
        ["sell"] = {
            ['type'] = "sell",
            ['nextRoute'] = "vehicle",
            ['delay'] = 5000,
            ['x'] = 3612.59,
            ['y'] = 3739.29,
            ['z'] = 28.075,
            ['blip'] = {
                ['label'] = 'HumaneLabs : Livraison',
                ['id'] = 434,
                ['color'] = 38
            },
            ['marker'] = {
                ['r'] = 50,
                ['g'] = 100,
                ['b'] = 255,
                ['a'] = 70
            }
        }
    },
    ["isLegal"] = false,
    ["navigation"] = false,
    ["requireService"] = false,
    ["marketValue"] = 750,
    ["harvestedItemId"] = 16,
    ["sellableItemId"] = 17,
    ["maximumQuantity"] = 5,
    ["drawMarkerDistance"] = 5,
    ["actionRequiredDistance"] = 5
}
