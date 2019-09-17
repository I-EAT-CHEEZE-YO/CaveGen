mainMenu = {}

mainMenu.entries = {"Begin Game", "Options", "Quit to Desktop"}
mainMenu.font = love.graphics.newFont("Assets/Fonts/VT323.ttf", 32)
mainMenu.titleFont = love.graphics.newFont("Assets/Fonts/VT323.ttf", 164)
mainMenu.index = 1
mainMenu.color = {1, 1, 1, 1}
mainMenu.selColor = {1, 0, 0, 1}
mainMenu.titleColor = {1, 0, 0, 1}
mainMenu.title = "CaveGen"
mainMenu.backgroundImage = love.graphics.newImage("Assets/Images/UI/MainMenu_BG.png")
mainMenu.tickSound = love.audio.newSource("Assets/Sounds/menu_tick.wav", "static")
mainMenu.music = love.audio.newSource("Assets/Music/MainMenu.ogg", "static")

function mainMenu:draw()
	love.graphics.draw(mainMenu.backgroundImage, 0, 0)
	love.graphics.setFont(mainMenu.titleFont)
	love.graphics.setColor(mainMenu.titleColor)
	love.graphics.printf(mainMenu.title, 0, 0, 1024, 'center')
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.setFont(mainMenu.font)
	for i = 1, #mainMenu.entries do
		if i == mainMenu.index then
			love.graphics.setColor(mainMenu.selColor)
		else
			love.graphics.setColor(mainMenu.color)
		end
		love.graphics.printf(mainMenu.entries[i], 0, 230 + (i * 35), 1024, 'center')
	end
	love.graphics.setColor(1, 1, 1, 1)
end

function mainMenu:getInput(key)
	if key == 'up' and mainMenu.index > 1 then
		mainMenu.index = mainMenu.index - 1
		mainMenu.tickSound:play()
	elseif key == 'down' and mainMenu.index < #mainMenu.entries then
		mainMenu.index = mainMenu.index + 1
		mainMenu.tickSound:play()
	end

	if key == 'return' then
		if mainMenu.index == 1 then
			mainMenu.music:stop()
			map:generate('cave', {width = mapWidth, height = mapHeight, iterations = 4})
			enemies:spawn(15)
			player:reset()
			game.state = 'gameDebug'
			mainMenu.index = 1
		elseif mainMenu.index == 2 then
			game.state = 'optionsMenu'
		elseif mainMenu.index == 3 then
			love.event.push('quit')
		end
	end

end