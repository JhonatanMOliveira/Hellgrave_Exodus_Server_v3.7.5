if configManager.getBoolean(configKeys.WEATHER_RAIN) then
	local weatherStartup = GlobalEvent("WeatherStartup")

	function weatherStartup.onStartup()
		if math.random(100) <= 15 then
			Game.setStorageValue('Weather', 1)
		else
			Game.setStorageValue('Weather', 0)
		end
		return true
	end

weatherStartup:register()

local weather = GlobalEvent("Weather")

local START_RAIN_CHANCE = 15  --  chance to start raining
local STOP_RAIN_CHANCE  = 10  --  chance to stop raining

function weather.onThink(interval, lastExecution)
	local current = Game.getStorageValue('Weather')
	if current == 1 then
		if math.random(100) <= STOP_RAIN_CHANCE then
			Game.setStorageValue('Weather', 0)
		end
	else
		if math.random(100) <= START_RAIN_CHANCE then
			Game.setStorageValue('Weather', 1)
		end
	end
	return true
end

weather:interval(300000)
weather:register()

local weatherRain = GlobalEvent("WeatherRain")

function weatherRain.onThink(interval, lastExecution)
	if Game.getStorageValue('Weather') == 1 then
		local players = Game.getPlayers()
		if #players == 0 then
			return true
		end
		for i = 1, #players do
			local player = players[i]
			player:sendWeatherEffect(weatherConfig.groundEffect, weatherConfig.fallEffect, weatherConfig.thunderEffect)
		end
	end
	return true
end
	weatherRain:interval(100)
	weatherRain:register()
end
