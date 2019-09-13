player = {}

player.x = 0
player.y = 0

player.width = 12
player.height = 30
player.vel = {x = 0, y = 0}
player.dir = 'south'
player.speed = 95
player.runSpeed = 195
player.stamina = 100
player.maxHealth = 100
player.maxMagic = 100
player.health = 55
player.magic = player.maxMagic
player.itemsInInventory = 0
player.maxInventory = 30
player.image = love.graphics.newImage("Assets/Images/Player.png")

player.showInventory = false
player.inventorySlot = {width = 64, height = 64, image = love.graphics.newImage("Assets/Images/UI/InventorySlot.png")}
player.inventoryWindow = {width = 64 * 4, height = 640}

player.inventoryXPosition = 3
player.inventoryYPosition = 96

player.hud = {}
player.hud.x = 0
player.hud.y = 0
player.hud.width = 100
player.hud.height = 32
player.healthBarWidth = player.health - 6
player.healthBarHeight = 26
player.magicBarWidth = player.magic - 6
player.magicBarHeight = 26

player.hud.hpBackgroundImage = love.graphics.newImage("Assets/Images/UI/HP_BG_Image.png")
player.hud.mpBackgroundImage = love.graphics.newImage("Assets/Images/UI/HP_BG_Image.png")

function player:reset()
	player.health = 100
	player.magic = 100
end

function player:addHealth(ammount)
	if player.health < player.maxHealth then
		player.health = player.health + ammount
	end
	if player.health > player.maxHealth then
		player.health = player.maxHealth
	end
end

function player:takeDamage(ammount)
	player.health = player.health - ammount
	if player.health <= 0 then
		game.state = 'gameOver'
	end
end

function player:addMagic(ammount)
	if player.magic < player.maxMagic then
		player.magic = player.health + ammount
	end
	if player.magic > player.maxMagic then
		player.magic = player.maxMagic
	end
end

function player.hud:draw(xPos, yPos)
	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.rectangle('fill', xPos + 3, yPos + 3, player.health, player.healthBarHeight)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(player.hud.hpBackgroundImage, xPos, yPos)
	love.graphics.setNewFont("Assets/Fonts/VT323.ttf", 32)
	love.graphics.printf("HP", xPos, yPos, 100, 'center')

	love.graphics.setColor(0.09, 0.52, 0.94, 1)
	love.graphics.rectangle('fill', xPos + 3, (yPos + 35) + 3, player.magic, player.magicBarHeight)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(player.hud.mpBackgroundImage, xPos, yPos + 35)
	love.graphics.setNewFont("Assets/Fonts/VT323.ttf", 32)
	love.graphics.printf("MP", xPos, yPos + 35, 100, 'center')
end

player.inventory = {}
for i = 1, 10 do
	table.insert(player.inventory, {name = "empty", type = "none", ammount = 0})
end


function player:drawInventory(xPos, yPos)
	if player.showInventory == true then
		love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
		love.graphics.rectangle('fill', xPos, yPos, player.inventoryWindow.width, player.inventoryWindow.height)
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.setNewFont(12)
		for i = 1, #player.inventory do
			love.graphics.draw(player.inventorySlot.image, xPos + 1, (yPos - 64) + (i * 64))
		end
	end
end


function player:pickSpawn()
	local rX = math.random(0, map.width)
	local rY = math.random(0, map.height)
	if map.data[rX][rY] ~= 1 then
		player:pickSpawn()
	else
		player.x = rX * tile.width
		player.y = rY * tile.height
	end
end

function player:update(dt)
		local up = love.keyboard.isDown('w', 'up')
		local down = love.keyboard.isDown('s', 'down')
		local left = love.keyboard.isDown('a', 'left')
		local right = love.keyboard.isDown('d', 'right')
		local run = love.keyboard.isDown('lshift')

		if run then
			player.speed = player.runSpeed
		else
			player.speed = 95
		end

		player.oldPos = {x = player.x, y = player.y}

		player.x = player.x + player.speed * player.vel.x * dt

		for i = 1, #map.collisionData do
			resolveCollision(player, map.collisionData[i])
		end

		if left then
			player.vel.x = -1
			player.dir = 'west'
		elseif right then
			player.vel.x = 1
			player.dir = 'east'
		else
			player.vel.x = 0
		end

		player.oldPos = {x = player.x, y = player.y}

		player.y = player.y + player.speed * player.vel.y * dt

		for i = 1, #map.collisionData do
			resolveCollision(player, map.collisionData[i])
		end

		if up then
			player.vel.y = -1
			player.dir = 'north'
		elseif down then
			player.vel.y = 1
			player.dir = 'south'
		else
			player.vel.y = 0
		end

		if player.health <= 0 then
			game.state = 'gameOver'
		end

	end

function player:draw()
	love.graphics.draw(player.image, player.x, player.y)
end

return player