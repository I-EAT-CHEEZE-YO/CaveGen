enemy = {}

bugImage = love.graphics.newImage("Assets/Images/Enemies/Bug.png")
bugSound = love.audio.newSource("Assets/Sounds/EnemyBug.wav", 'static')

function enemy:create(x, y, width, height, image, sound)
	return {
		x = x * tile.width,
		y = y * tile.height,
		width = width,
		height = height,
		updateTime = 0,
		updateFrequency = math.random(10, 12),
		updateAt = math.random(25, 35),
		speed = math.random(100, 125),
		dir = math.random(1, 4),
		vel = {x = 0, y = 0},
		image = image,
		lvl = 1,
		health = 100,
		attackDamage = math.random(1, 10),
		defence = math.random(1, 5),
		deathSound = sound,
		attack = function(self)
			player:takeDamage(self.attackDamage)
			self.attackDamage = math.random(1, self.lvl * 10)
			console:addMessage("Took " .. self.attackDamage .. " Points of Damage!", {0.12, 0.12, 0.12, 1}, 5)
		end,
		takeDamage = function(self, ammount)
			player.attackSound:play()
			self.health = self.health - ammount
		end
	}
end


enemies = {}

--enemies[1] = enemy:create(53, 59, 32, 32, bugImage, bugSound)
--enemies[2] = enemy:create(50, 55, 32, 32, bugImage, bugSound)
--enemies[3] = enemy:create(60, 45, 32, 32, bugImage, bugSound)
--enemies[4] = enemy:create(50, 45, 32, 32, bugImage, bugSound)

function enemies:spawn(n)
	local floors = {}
	for x = 0, map.width do
		for y = 0, map.height do
			if map.data[x][y] == 1 then
				table.insert(floors, {x = x, y = y})
			end
		end
	end

	for i = 1, n do
		local t = math.random(1, #floors)
		enemies[i] =  enemy:create(floors[t].x, floors[t].y, 32, 32, bugImage, bugSound)
	end
	floors = nil
end


function enemies:draw()
	if #enemies > 0 then
		for i = 1, #enemies do
			love.graphics.draw(enemies[i].image, enemies[i].x, enemies[i].y)
		end
	end
end

function enemies:update(dt)
	local mouse = {x = camera.mx, y = camera.my, width = 10, height = 10}
	local playerMainAttack = love.mouse.isDown(1)
	local playerSecondaryAttack = love.mouse.isDown(2)

	if #enemies > 0 then
		for i = #enemies, 1, -1 do

			enemies[i].updateTime = enemies[i].updateTime + enemies[i].updateFrequency * dt

			if checkCollision(player.atkZone, enemies[i]) then
				if checkCollision(mouse, enemies[i]) then
					if playerMainAttack and not oldPlayerMainAttack then
						local atk = math.random(3, 8)
						player.attacking = true
						enemies[i]:takeDamage(atk)
						console:addMessage("Hit Bug For " .. atk .. " Damage!", {0.12, 0.12, 0.12, 1}, 5)
					else
						player.attacking = false
					end
				elseif checkCollision(mouse, enemies[i]) then
					if playerSecondaryAttack and not oldPlayerSecondaryAttack then
						local mp = math.random(1, 12)
						if player.magic >= mp then
							enemies[i]:takeDamage(player.attack)
							console:addMessage("Hit Bug For " .. mp .. " Damage!", {0.12, 0.12, 0.12, 1}, 5)
							player.magic = player.magic - mp
						else
							console:addMessage("Not Enough MP", {0.12, 0.12, 0.12, 1}, 5)
						end
					end
				end
				if enemies[i].updateTime > enemies[i].updateAt then
					enemies[i]:attack()
					enemies[i].updateTime = 0
				end
			elseif checkCollision(player.agroZone, enemies[i]) then
				if checkCollision(mouse, enemies[i]) then
					if playerSecondaryAttack and not oldPlayerSecondaryAttack then
						local mp = math.random(1, 12)
						if player.magic >= mp then
							enemies[i]:takeDamage(player.attack)
							console:addMessage("Hit Bug For " .. mp .. " Damage!", {0.12, 0.12, 0.12, 1}, 5)
							player.magic = player.magic - mp
						else
							console:addMessage("Not Enough MP", {0.12, 0.12, 0.12, 1}, 5)
						end
					end
				end
				if enemies[i].updateTime > enemies[i].updateAt then
					enemies[i].x = enemies[i].x + enemies[i].speed * enemies[i].vel.x * dt
					enemies[i].y = enemies[i].y + enemies[i].speed * enemies[i].vel.y * dt
					enemies[i].vel.x = 0
					enemies[i].vel.y = 0
					if enemies[i].x > player.atkZone.x then
						enemies[i].vel.x = -1
					elseif enemies[i].x + enemies[i].width < player.atkZone.x then
						enemies[i].vel.x = 1
					else
						enemies[i].vel.x = 0
					end
					if enemies[i].y > player.atkZone.y then
						enemies[i].vel.y = -1
					elseif enemies[i].y + enemies[i].height < player.atkZone.y then
						enemies[i].vel.y = 1
					else
						enemies[i].vel.y = 0
					end
				end
			else
				if enemies[i].dir == 1 then --left
					enemies[i].vel.x = -1
					enemies[i].vel.y = 0
				elseif enemies[i].dir == 2 then --right
					enemies[i].vel.x = 1
					enemies[i].vel.y = 0
				elseif enemies[i].dir == 3 then -- up
					enemies[i].vel.y = -1
					enemies[i].vel.x = 0
				elseif enemies[i].dir == 4 then --down
					enemies[i].vel.y = 1
					enemies[i].vel.x = 0
				elseif enemies[i].dir == 5 or enemies[i].dir == 6 then
					enemies[i].vel = {x = 0, y = 0}
				end			
			
				enemies[i].oldPos = {x = enemies[i].x, y = enemies[i].y}	

				enemies[i].x = enemies[i].x + enemies[i].speed * enemies[i].vel.x * dt
		
				for j = 1, #map.collisionData do
					resolveEnemyCollision(enemies[i], map.collisionData[j])
				end

				enemies[i].oldPos = {x = enemies[i].x, y = enemies[i].y}

				enemies[i].y = enemies[i].y + enemies[i].speed * enemies[i].vel.y * dt
	
				for j = 1, #map.collisionData do
					resolveEnemyCollision(enemies[i], map.collisionData[j])
				end

				if enemies[i].updateTime > enemies[i].updateAt then
					enemies[i].updateTime = 0
					enemies[i].dir = math.random(1, 6)
				end
			end

			if enemies[i].health <= 0 then
				loot:drop(enemies[i].x / tile.width, enemies[i].y / tile.height, items[math.random(1, #items)])
				enemies[i].deathSound:play()
				table.remove(enemies, i)
				console:addMessage("Bug Defeated!", {0.12, 0.12, 0.12, 1}, 5)
				player.attacking = false
			end

		end
	end
	oldPlayerMainAttack = playerMainAttack
	oldPlayerSecondaryAttack = playerSecondaryAttack
end

return enemies

