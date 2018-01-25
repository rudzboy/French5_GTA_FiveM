-- Update players wind
function updateWind(toggle,heading)
	if(toggle) then
		SetWind(1.0)
		SetWindSpeed(11.99);
		SetWindDirection(heading)
	else
		SetWind(0.0)
		SetWindSpeed(0.0);
	end
end

function SendNotification(message)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(message)
	DrawNotification(false, false)
end

-- Sync weather with server settings.
RegisterNetEvent('smartweather:updateWeather')
AddEventHandler('smartweather:updateWeather', function(data)
	ClearOverrideWeather()
	SetWeatherTypeOverTime(data["weather"], data["transitionDuration"])
	Citizen.Wait(data["transitionDuration"]*100)
	SetOverrideWeather(data["weather"])
	updateWind(data["windEnabled"],data["windHeading"])
end)


-- Sync on player connect
AddEventHandler('onClientMapStart', function()
	TriggerServerEvent('smartweather:firstSyncWeather')
end)

-- Ask every minute
local delay = 60000
Citizen.CreateThread( function()
	while true do
		Citizen.Wait(delay)
		TriggerServerEvent('smartweather:syncWeather')
	end
end)