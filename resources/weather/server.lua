local secondsToWait = 270
local currentWeatherString = "CLEAR" -- Starting Weather Type.
local nextWeatherString = false

local serverTime = tonumber(os.time())

local windEnabled = false
local windHeading = 0

weatherTree = {
	["EXTRASUNNY"] = {"EXTRASUNNY", "CLEAR"},
	["SMOG"] = {"SMOG","FOGGY","CLEAR","CLEARING","OVERCAST","CLOUDS","EXTRASUNNY"},
	["CLEAR"] = {"CLEAR", "CLOUDS","EXTRASUNNY","CLEARING","FOGGY","OVERCAST"},
	["CLOUDS"] = {"CLEAR","SMOG","FOGGY","CLEARING","OVERCAST","SNOW","CLOUDS"},
	["FOGGY"] = {"CLEAR","CLOUDS","SMOG","OVERCAST"},
	["OVERCAST"] = {"OVERCAST","CLEAR","CLOUDS","SMOG","FOGGY","RAIN","CLEARING"},
	["RAIN"] = {"THUNDER","CLEARING","SNOW","OVERCAST"},
	["THUNDER"] = {"RAIN","BLIZZARD"},
	["CLEARING"] = {"CLEAR","CLOUDS","OVERCAST","FOGGY","SMOG","RAIN"},
	["SNOW"] = {"BLIZZARD","RAIN","XMAS","CLOUDS","FOGGY","SMOG"},
	["BLIZZARD"] = {"SNOW","THUNDER","XMAS"},
	["XMAS"] = {"XMAS","BLIZZARD","SNOW"},
	-- 	["NEUTRAL"] = {"EXTRASUNNY","SMOG","CLEAR","CLEARING","CLOUDS","FOGGY","OVERCAST"},
	-- ["SNOWLIGHT"] = {} ? Doesn't seem to do anything worth while
}

windWeathers = {
	["OVERCAST"] = true,
	["RAIN"] = true,
	["THUNDER"] = true,
	["BLIZZARD"] = true,
	["XMAS"] = true,
	["SNOW"] = true,
	["CLOUDS"] = true
}


function getTableLength(T)
	local count = 0
	for _ in pairs(T) do 
		count = count + 1
	end
	return count
end


function getTableKeys(T)
	local keys = {}
	for k,_ in pairs(T) do
		table.insert(keys,k)
	end
	return keys
end


currentWeatherData = {
	["transitionDuration"] = secondsToWait,
	["weatherString"] = currentWeatherString,
	["nextWeatherString"] = false,
	["windEnabled"] = false,
	["windHeading"] = 0
}

function updateWeatherString()

	if(nextWeatherString == false)then
	    local currentOptions = weatherTree[currentWeatherString]
		nextWeatherString = currentOptions[math.random(1,getTableLength(currentOptions))]
	end

	math.randomseed(serverTime)

	local count = getTableLength(weatherTree)
	local tableKeys = getTableKeys(weatherTree)

	local nextOptions = weatherTree[currentWeatherString]
	nextWeatherString = nextOptions[math.random(1,getTableLength(nextOptions))]

	-- 50/50 Chance to enabled wind at a random heading for the specified weathers.
	if(windWeathers[currentWeatherString] and (math.random(0,1) == 1))then
		windEnabled = true
		windHeading = math.random(0,360)
	end

	currentWeatherData = {
		["transitionDuration"] = secondsToWait,
		["weather"] = nextWeatherString,
		["windEnabled"] = windEnabled,
		["windHeading"] = windHeading
	}

	print("Transition Weather from "..currentWeatherString.." to "..nextWeatherString..".")

	currentWeatherString = nextWeatherString

	TriggerClientEvent("smartweather:updateWeather", -1, currentWeatherData)
end


-- Sync Weather once player joins.
RegisterServerEvent("smartweather:syncWeather")
AddEventHandler("smartweather:syncWeather",function()
	local actualTime = tonumber(os.time())
    if tonumber(actualTime - serverTime) >= secondsToWait then
		serverTime = actualTime
		updateWeatherString()
	end
end)

RegisterServerEvent("smartweather:firstSyncWeather")
AddEventHandler("smartweather:firstSyncWeather",function()
	TriggerClientEvent("smartweather:updateWeather", source, currentWeatherData)
	print("Sending Weather to "..GetPlayerName(source)..".")
end)