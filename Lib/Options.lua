options = {}
options.tickSound = love.audio.newSource("Assets/Sounds/menu_tick.wav", "static")
options.titleFont = love.graphics.newFont("Assets/Fonts/VT323.ttf", 64)
options.font = love.graphics.newFont("Assets/Fonts/VT323.ttf", 32)
options.color = {1, 1, 1, 1}
options.selColor = {1, 0, 0, 1}
options.index = 1
options.masterVolume = 100
options.musicVolume = 100
options.sfxVolume = 100
options.entries = {"Master Volume : " .. options.masterVolume, "Music Volume : " .. options.musicVolume,"Sound Volume : " .. options.sfxVolume, "Return"}

function options:draw()
	love.graphics.setFont(options.titleFont)
	love.graphics.printf("Options", 0, 96, 1024, 'center')
	love.graphics.setFont(options.font)
	for i = 1, #options.entries do
		if i == options.index then
			love.graphics.setColor(options.selColor)
		else
			love.graphics.setColor(options.color)
		end
		love.graphics.printf(options.entries[i], 0, 220 + (i * 38), 1024, 'center')
	end
	love.graphics.setColor(1, 1, 1, 1)
end

function options:getInput(key)
	if key == 'up' and options.index > 1 then
		options.tickSound:play()
		options.index = options.index - 1
	elseif key == 'down' and options.index < #options.entries then
		options.tickSound:play()
		options.index = options.index + 1
	elseif key == 'left' then 
		if options.index == 1 then
			if  options.masterVolume > 0 then
				options.masterVolume = options.masterVolume - 5
				options.entries = {"Master Volume : " .. options.masterVolume, "Music Volume : " .. options.musicVolume,"Sound Volume : " .. options.sfxVolume, "Return"}
				--set all music and sound volumes
				love.audio.setVolume(options.masterVolume / 100)
			end
		elseif options.index == 2 then
			if options.musicVolume > 0 then
				options.musicVolume = options.musicVolume - 5
				options.entries = {"Master Volume : " .. options.masterVolume, "Music Volume : " .. options.musicVolume,"Sound Volume : " .. options.sfxVolume, "Return"}
				--set all music volumes

			end
		elseif options.index == 3 then
			if options.sfxVolume > 0 then
				options.sfxVolume = options.sfxVolume - 5
				options.entries = {"Master Volume : " .. options.masterVolume, "Music Volume : " .. options.musicVolume,"Sound Volume : " .. options.sfxVolume, "Return"}
				--set all sfx volume
			end
		end
	elseif key == 'right' then
		if options.index == 1 then
			if  options.masterVolume < 100 then
				options.masterVolume = options.masterVolume + 5
				options.entries = {"Master Volume : " .. options.masterVolume, "Music Volume : " .. options.musicVolume,"Sound Volume : " .. options.sfxVolume, "Return"}
				--set all music and sound volumes
				love.audio.setVolume(options.masterVolume / 100)
			end
		elseif options.index == 2 then
			if  options.musicVolume < 100 then
				options.musicVolume = options.musicVolume + 5
				options.entries = {"Master Volume : " .. options.masterVolume, "Music Volume : " .. options.musicVolume,"Sound Volume : " .. options.sfxVolume, "Return"}
				--set all music and sound volumes
			end
		elseif options.index == 3 then
			if options.sfxVolume < 100 then
				options.sfxVolume = options.sfxVolume + 5
				options.entries = {"Master Volume : " .. options.masterVolume, "Music Volume : " .. options.musicVolume,"Sound Volume : " .. options.sfxVolume, "Return"}
				--set all sfx volume
			end
		end
	elseif key == 'return' then
		if options.index == #options.entries then
			if game.paused == false then
				options.index = 1
				game.state = 'mainMenu'
			else
				options.index = 1
				pauseMenu.index = 1
				game.paused = true
				game.state = 'gameDebug'
			end
		end
	end
end

return options