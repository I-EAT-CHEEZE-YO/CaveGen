require "Lib.MainMenu"
require "Lib.PauseMenu"
require "Lib.Map"
require "Lib.Player"
require "Lib.Collision"
Camera = require "Lib.Camera"

require "Lib.Items"
require "Lib.Loot"

function love.load()
	
	math.randomseed(11010110)

	love.graphics.setBackgroundColor(0.05, 0.05, 0.05, 1)
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)

	print("Width = " .. love.graphics.getWidth() .. " Height = " .. love.graphics.getHeight())

	game = {}
	game.debug = false
	game.paused = false
	game.state = 'mainMenu'

	mapWidth = 165
	mapHeight = 75

	camera = Camera()
	camera:setFollowLerp(0.2)
	camera:setFollowStyle('TOPDOWN')
	camera:setBounds(0, 0, (mapWidth * tile.width), (mapHeight * tile.height))

end

function love.update(dt)

	if game.state == "gameDebug" then
		if game.paused == false then
			camera:update(dt)
			camera:follow(player.x, player.y)
			player:update(dt)
			loot:pickup()
		end
	end
	collectgarbage()
end

function love.draw()
	if game.state == 'mainMenu' then
		mainMenu:draw()
	elseif game.state == 'gameDebug' then
		if game.paused == false then
			camera:attach()
			map:draw(0,0)
			loot:draw()
			player:draw()
			if game.debug == true then
				map:drawCollisionData()
			end
			camera:detach()
			camera:draw()
			player.hud:draw(0, 0)
			player:drawInventory(love.graphics.getWidth() - (64 * 4), 0)
		elseif game.paused == true then
			pauseMenu:draw()
		end

		if game.debug == true then
			love.graphics.setNewFont(14)
			love.graphics.printf("------Debug Mode------", 0, 3, 1024, 'center')
			love.graphics.printf("Memory Used In KB = " .. math.floor(collectgarbage('count')), 0, 15, 1024, 'center')
			love.graphics.printf("FPS : " .. love.timer.getFPS(), 0, 30, 1024, 'center')
			love.graphics.printf("Player Position X[" .. math.floor(player.x / tile.width) .. "] Y[".. math.floor(player.y / tile.height) .. "]", 0, 45, 1024, 'center')
			love.graphics.printf("Player Direction : " .. player.dir, 0, 60, 1024, 'center')
			love.graphics.printf("Player HP = " .. player.health, 0, 75, 1024, 'center')
			love.graphics.printf("Show Inventory " .. tostring(player.showInventory), 0, 90, 1024, 'center')
		end
	elseif game.state == 'gameOver' then
		love.graphics.setNewFont(120)
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.printf("Game Over", 0, 240, 1024, 'center')
	end

end

function love.keypressed(key)
	if game.state == 'mainMenu' then
		mainMenu:getInput(key)
	elseif game.state == 'gameDebug' then
		if key == 'escape' then
			if game.paused == true then
				game.paused = false
				pauseMenu.index = 1
			else
				game.paused = true
			end
		elseif key == 'f1' then
			if game.debug == true then
				game.debug = false
			else
				game.debug = true
			end
		elseif key == 'f2' then
			
    	elseif key == 'space' then
    		if player.showInventory == true then
    			player.showInventory = false
    		else
    			player.showInventory = true
    		end
    	end
    	if game.paused == true then
    		pauseMenu:getInput(key)
    	end
    end
end