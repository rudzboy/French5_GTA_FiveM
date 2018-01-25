-- GLOBAL CONFIGURATION --

config = {}

config.drawMarkerShow = true
config.drawBlipTradeShow = true
config.syncDelay = 1000

-- JOBS CONFIGURATION --

config.jobs = {}

-- ANIMATIONS CONFIGURATION (animations table key must match an existing position type value in jobs table) --

config.animations = {
    ["harvest"] = {
        ["dictionary"] = 'amb@world_human_gardener_plant@male@base',
        ["animation"] = 'base',
        ["flags"] = 16,
        ["speedIn"] = 2.0,
        ["speedOut"] = 4.0
    },
    ["sell"] = {
        ["dictionary"] = 'move_p_m_two_idles@generic',
        ["animation"] = 'fidget_look_around',
        ["flags"] = 0,
        ["speedIn"] = 2.0,
        ["speedOut"] = 4.0
    }
}