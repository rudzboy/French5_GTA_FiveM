config.jobs['medic_delivery'] = {
    ["name"] = "Livraison Matériel Médical",
    ["requiredId"] = 11,
    ["vehicle"] = {
        ["model"] = 'polmav',
        ["livery"] = 1,
        ['blip'] = {
            ['label'] = 'Médecin : Hélicoptère',
            ['id'] = 43,
            ['color'] = 3
        },
    },
    ["positions"] = {
        ["vehicle"] = {
            ['type'] = "vehicle",
            ['nextRoute'] = "harvest",
            ['delay'] = 0,
            ['x'] = 299.87,
            ['y'] = -1453.81,
            ['z'] = 46.5095,
            ['h'] = 180.0,
            ['blip'] = {
                ['label'] = 'Matériel médical : Héliport',
                ['id'] = 43,
                ['color'] = 3
            },
            ['marker'] = {
                ['r'] = 60,
                ['g'] = 60,
                ['b'] = 255,
                ['a'] = 120
            }
        },
        ["harvest"] = {
            ['type'] = "harvest",
            ['nextRoute'] = "sell",
            ['delay'] = 5000,
            ['x'] = -397.04,
            ['y'] = -341.748,
            ['z'] = 70.9682,
            ['blip'] = {
                ['label'] = 'Matériel médical : Stock',
                ['id'] = 403,
                ['color'] = 3
            },
            ['marker'] = {
                ['r'] = 60,
                ['g'] = 60,
                ['b'] = 255,
                ['a'] = 120
            }
        },
        ["sell"] = {
            ['type'] = "sell",
            ['nextRoute'] = "harvest",
            ['delay'] = 20000,
            ['x'] = 1776.97,
            ['y'] = 3655.17,
            ['z'] = 34.3475,
            ['blip'] = {
                ['label'] = 'Matériel médical : Vente',
                ['id'] = 434,
                ['color'] = 3
            },
            ['marker'] = {
                ['r'] = 60,
                ['g'] = 60,
                ['b'] = 255,
                ['a'] = 120
            }
        }
    },
    ["isLegal"] = true,
    ["navigation"] = false,
    ["requireService"] = false,
    ["marketValue"] = 50,
    ["harvestedItemId"] = 29,
    ["sellableItemId"] = 29,
    ["maximumQuantity"] = 10,
    ["drawMarkerDistance"] = 100,
    ["actionRequiredDistance"] = 5
}
