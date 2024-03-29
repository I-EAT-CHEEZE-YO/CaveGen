require "Lib.MainMenu"
require "Lib.Options"
require "Lib.Console"
require "Lib.PauseMenu"
require "Lib.Map"
require "Lib.Player"
require "Lib.Enemy"
require "Lib.Collision"
Camera = require "Lib.Camera"
inventory = require "Lib.Inventory"
item = require "Lib.Item"
inv = inventory.new(6,5)

require "Lib.Items"
require "Lib.Loot"

inventoryGui = require "Lib.InventoryGui"
inventoryGui:setInventory(inv,32,32)

function love.load()
	love.graphics.setBackgroundColor(0.05, 0.05, 0.05, 1)
	love.graphics.setDefaultFilter('nearest', 'nearest', 1)

	loadingScreen = love.graphics.newImage("Assets/Images/UI/LoadingScreen.png")

	game = {}
	game.build = "testing"
	game.debug = false
	game.paused = false
	game.state = 'mainMenu'
	game.timer = 0
	game.ready = false

	--11010110
	--os.time()
	if game.build == "testing" then 
		math.randomseed(11010110)
	elseif game.build == "release" then
		math.randomseed(os.time())
	end

	mapWidth = 165
	mapHeight = 75

	camera = Camera()
	camera:setFollowLerp(0.15)
	camera:setFollowStyle('TOPDOWN')
	camera:setBounds(0, 0, (mapWidth * tile.width), (mapHeight * tile.height))
	camera.scale = 1

end

function love.update(dt)
	if game.state == 'mainMenu' then
		mainMenu.music:play()
		mainMenu.music:setLooping(true)
	elseif game.state == "gameDebug" then
		game.timer = game.timer + 1 * dt

		if game.timer > 1 then
			game.ready = true
		end

		if game.paused == false then
			camera:update(dt)
			camera:follow(player.x, player.y)
			enemies:update(dt)
			player:update(dt)
			loot:pickup()
			inventoryGui:update(player.inventoryXPosition, player.inventoryYPosition)
			console:update(dt)
		end
	end
	collectgarbage()
end

function love.draw()
	if game.state == 'mainMenu' then
		mainMenu:draw()
	elseif game.state == 'optionsMenu' then
		options:draw()
	elseif game.state == 'gameDebug' then
		if game.paused == false then
			camera:attach()
			map:draw(0,0)
			loot:draw()
			enemies:draw()
			player:draw()
			if game.debug == true then
				map:drawCollisionData()
				player:drawAgroZone()
			end
			camera:detach()
			camera:draw()
			player.hud:draw(3, 3)
			console:draw(love.graphics.getWidth() - 420, love.graphics.getHeight() - 146)
			if player.showInventory == true then
				inventoryGui:draw(player.inventoryXPosition, player.inventoryYPosition)
			end
		elseif game.paused == true then
			pauseMenu:draw()
		end

		if game.debug == true then
			love.graphics.setNewFont("Assets/Fonts/VT323.ttf", 16)
			love.graphics.printf("------Debug Mode------", 0, 3, 1024, 'center')
			love.graphics.printf("Memory Used In KB = " .. math.floor(collectgarbage('count')), 0, 15, 1024, 'center')
			love.graphics.printf("FPS : " .. love.timer.getFPS(), 0, 30, 1024, 'center')
			love.graphics.printf("Enemies Remaining " .. #enemies, 0, 45, 1024, 'center')
			love.graphics.printf("Player Gold = " .. player.gold, 0, 60, 1024, 'center')
			love.graphics.printf("", 0, 75, 1024, 'center')
			love.graphics.printf("", 0, 90, 1024, 'center')
			if player.itemsInInventory == player.maxInventory then
				love.graphics.printf("Inventory Full", 0, 105, 1024, 'center')
			else
				love.graphics.printf("Inventory not Full " .. player.maxInventory - player.itemsInInventory .. " empty slots", 0, 105, 1024, 'center')
			end
			love.graphics.printf("CmX = [" .. math.floor(camera.mx / tile.width) .. "] CmY = [" .. math.floor(camera.my / tile.height) .. "]", 0, 120, 1024, 'center')
		end
		if game.ready == false then
			love.graphics.draw(loadingScreen, 0, 0)
		end
	elseif game.state == 'gameOver' then
		love.graphics.setNewFont("Assets/Fonts/VT323.ttf", 120)
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.printf("Game Over", 0, 240, 1024, 'center')
	end

end

function love.keypressed(key)
	if game.state == 'mainMenu' then
		mainMenu:getInput(key)
	elseif game.state == 'optionsMenu' then
		options:getInput(key)
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
			player:takeDamage(10)
    	elseif key == 'tab' then
    		if player.showInventory == true then
    			player.showInventory = false
    		else
    			player.showInventory = true
    		end
    	end
    	if game.paused == true then
    		pauseMenu:getInput(key)
    	end
    elseif game.state == 'gameOver' then
    	if key == 'space' then
    		game.state = 'mainMenu'
    	end
    end

	function love.mousepressed(x,y,b)
		if game.state == 'gameDebug' then
			if player.showInventory == true then
		  		inventoryGui:mousepressed(x,y,b)
			end
		end
	end

end