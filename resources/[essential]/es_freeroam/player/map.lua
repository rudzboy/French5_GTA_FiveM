local blips = {
    -- Station Essences
    --{name="Station Essence", id=361, x=49.4187,   y=2778.793,  z=58.043},
    --{name="Station Essence", id=361, x=263.894,   y=2606.463,  z=44.983},
    --{name="Station Essence", id=361, x=1039.958,  y=2671.134,  z=39.550},
    --{name="Station Essence", id=361, x=1207.260,  y=2660.175,  z=37.899},
    --{name="Station Essence", id=361, x=2539.685,  y=2594.192,  z=37.944},
    --{name="Station Essence", id=361, x=2679.858,  y=3263.946,  z=55.240},
    --{name="Station Essence", id=361, x=2005.055,  y=3773.887,  z=32.403},
    --{name="Station Essence", id=361, x=1687.156,  y=4929.392,  z=42.078},
    --{name="Station Essence", id=361, x=1701.314,  y=6416.028,  z=32.763},
    --{name="Station Essence", id=361, x=179.857,   y=6602.839,  z=31.868},
    --{name="Station Essence", id=361, x=-94.4619,  y=6419.594,  z=31.489},
    --{name="Station Essence", id=361, x=-2554.996, y=2334.40,  z=33.078},
    --{name="Station Essence", id=361, x=-1800.375, y=803.661,  z=138.651},
    --{name="Station Essence", id=361, x=-1437.622, y=-276.747,  z=46.207},
    --{name="Station Essence", id=361, x=-2096.243, y=-320.286,  z=13.168},
    --{name="Station Essence", id=361, x=-724.619, y=-935.1631,  z=19.213},
    --{name="Station Essence", id=361, x=-526.019, y=-1211.003,  z=18.184},
    --{name="Station Essence", id=361, x=-70.2148, y=-1761.792,  z=29.534},
    --{name="Station Essence", id=361, x=265.648,  y=-1261.309,  z=29.292},
    --{name="Station Essence", id=361, x=819.653,  y=-1028.846,  z=26.403},
    --{name="Station Essence", id=361, x=1208.951, y= -1402.567, z=35.224},
    --{name="Station Essence", id=361, x=1181.381, y= -330.847,  z=69.316},
    --{name="Station Essence", id=361, x=620.843,  y= 269.100,  z=103.089},
    --{name="Station Essence", id=361, x=2581.321, y=362.039, 108.468},
    -- Police Stations
    { name = "Commissariat de Police", id = 60, x = 425.130, y = -979.558, z = 30.711 },
    --{name="Police Station", id=60, x=1859.234, y= 3678.742, z=33.690},
    --{name="Police Station", id=60, x=-438.862, y=6020.768, z=31.490},
    --{name="Police Station", id=60, x=818.221, y=-1289.883, z=26.300},
    { name = "Prison", id = 285, x = 1679.049, y = 2513.711, z = 45.565 },
    -- LS Customs
}

Citizen.CreateThread(function()

    for _, item in pairs(blips) do
        item.blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(item.blip, item.id)
        SetBlipAsShortRange(item.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.name)
        EndTextCommandSetBlipName(item.blip)
    end

    --load unloaded ipl's
    LoadMpDlcMaps()
    EnableMpDlcMaps(true)
    RequestIpl("chop_props")
    RequestIpl("FIBlobby")
    RemoveIpl("FIBlobbyfake")
    RequestIpl("FBI_colPLUG")
    RequestIpl("FBI_repair")
    RequestIpl("v_tunnel_hole")
    RequestIpl("TrevorsMP")
    RequestIpl("TrevorsTrailer")
    RequestIpl("TrevorsTrailerTidy")
    RemoveIpl("farm_burnt")
    RemoveIpl("farm_burnt_lod")
    RemoveIpl("farm_burnt_props")
    RemoveIpl("farmint_cap")
    RemoveIpl("farmint_cap_lod")
    RequestIpl("farm")
    RequestIpl("farmint")
    RequestIpl("farm_lod")
    RequestIpl("farm_props")
    RequestIpl("des_farmhouse")
    RequestIpl("facelobby")
    RemoveIpl("CS1_02_cf_offmission")
    RequestIpl("CS1_02_cf_onmission1")
    RequestIpl("CS1_02_cf_onmission2")
    RequestIpl("CS1_02_cf_onmission3")
    RequestIpl("CS1_02_cf_onmission4")
    RequestIpl("v_rockclub")
    RemoveIpl("hei_bi_hw1_13_door")
    RequestIpl("bkr_bi_hw1_13_int")
    RequestIpl("ufo")
    RemoveIpl("v_carshowroom")
    RemoveIpl("shutter_open")
    RemoveIpl("shutter_closed")
    RemoveIpl("csr_inMission")
    RequestIpl("v_carshowroom")
    RequestIpl("shr_int")
    RequestIpl("shutter_closed")
    RequestIpl("smboat")
    RequestIpl("cargoship")
    RequestIpl("railing_start")
    RemoveIpl("sp1_10_fake_interior")
    RemoveIpl("sp1_10_fake_interior_lod")
    RequestIpl("sp1_10_real_interior")
    RequestIpl("sp1_10_real_interior_lod")
    RemoveIpl("id2_14_during_door")
    RemoveIpl("id2_14_during1")
    RemoveIpl("id2_14_during2")
    RemoveIpl("id2_14_on_fire")
    RemoveIpl("id2_14_post_no_int")
    RemoveIpl("id2_14_pre_no_int")
    RemoveIpl("id2_14_during_door")
    RequestIpl("id2_14_during1")
    RequestIpl("coronertrash")
    RequestIpl("Coroner_Int_on")
    RemoveIpl("Coroner_Int_off")
    RemoveIpl("bh1_16_refurb")
    RemoveIpl("jewel2fake")
    RemoveIpl("bh1_16_doors_shut")
    RequestIpl("refit_unload")
    RequestIpl("post_hiest_unload")
    RequestIpl("Carwash_with_spinners")
    RequestIpl("ferris_finale_Anim")
    RemoveIpl("ch1_02_closed")
    RequestIpl("ch1_02_open")
    RequestIpl("AP1_04_TriAf01")
    RequestIpl("CS2_06_TriAf02")
    RequestIpl("CS4_04_TriAf03")
    RemoveIpl("scafstartimap")
    RequestIpl("scafendimap")
    RemoveIpl("DT1_05_HC_REMOVE")
    RequestIpl("DT1_05_HC_REQ")
    RequestIpl("DT1_05_REQUEST")
    RequestIpl("FINBANK")
    RemoveIpl("DT1_03_Shutter")
    RemoveIpl("DT1_03_Gr_Closed")
    RequestIpl("ex_sm_13_office_01a")
    RequestIpl("ex_sm_13_office_01b")
    RequestIpl("ex_sm_13_office_02a")
    RequestIpl("ex_sm_13_office_02b")
    RequestIpl("CanyonRvrShallow")
    -- Zancudo River (need streamed content): 86.815, 3191.649, 30.463
    RequestIpl("cs3_05_water_grp1")
    RequestIpl("cs3_05_water_grp1_lod")
    RequestIpl("cs3_05_water_grp2")
    RequestIpl("cs3_05_water_grp2_lod")
    -- Cassidy Creek (need streamed content): -425.677, 4433.404, 27.3253
    RequestIpl("canyonriver01")
    RequestIpl("canyonriver01_lod")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local players = {}

        for i = 0, 31 do
            if NetworkIsPlayerActive(i) then
                table.insert(players, i)
            end
        end

        for k, v in pairs(players) do
            if not GetBlipFromEntity(GetPlayerPed(v)) then
                if GetPlayerPed(v) == GetPlayerPed(-1) then return end
                local blip = AddBlipForEntity(GetPlayerPed(v))
                SetBlipColour(blip, 1)
            end
        end
    end
end)
