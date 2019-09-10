pauseMenu = {}

pauseMenu.font = love.graphics.newFont("Assets/Fonts/hint-retro.ttf", 32)
pauseMenu.titleFont = love.graphics.newFont("Assets/Fonts/hint-retro.ttf", 42)
pauseMenu.entries = {"Resume", "Options", "Quit to Main Menu", "Quit to Desktop"}
pauseMenu.index = 1
pauseMenu.color = {1, 1, 1, 1}
pauseMenu.selColor = {0.69, 0.07, 0.03, 1}
pauseMenu.miniMapPos = {x = love.graphics.getWidth() / 2 - (165 * 3) / 2, y = 55}
pauseMenu.tickSound = love.audio.newSource("Assets/Sounds/menu_tick.wav", "static")

function pauseMenu:draw()
	love.graphics.setFont(pauseMenu.titleFont)
	map:drawMiniMap(pauseMenu.miniMapPos.x, pauseMenu.miniMapPos.y)
	love.graphics.printf('Paused', 0, 5, 1024, 'center')
	love.graphics.setFont(pauseMenu.font)
	for i = 1, #pauseMenu.entries do
		if i == pauseMenu.index then
			love.graphics.setColor(pauseMenu.selColor)
		else
			love.graphics.setColor(pauseMenu.color)
		end
		love.graphics.printf(pauseMenu.entries[i], 0, 375 + (i * 35), 1024, 'center')
	end
	love.graphics.setColor(1, 1, 1, 1)
end 

function pauseMenu:getInput(key)
	if key == 'up' and pauseMenu.index > 1 then
		pauseMenu.tickSound:play()
		pauseMenu.index = pauseMenu.index - 1
	elseif key == 'down' and pauseMenu.index < #pauseMenu.entries then
		pauseMenu.tickSound:play()
		pauseMenu.index = pauseMenu.index + 1
	end

	if key == 'return' then
		if pauseMenu.index == 1 then
			game.paused = false
			pauseMenu.index = 1
		elseif pauseMenu.index == 3 then
			game.state = 'mainMenu'
			game.paused = false
			pauseMenu.index = 1
		elseif pauseMenu.index == 4 then
			love.event.push('quit')
		end
	end
end