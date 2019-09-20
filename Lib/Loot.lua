loot = {}

function loot:drop(xPos, yPos, item)
	table.insert(loot, {name = item.name, image = item.image, x = xPos * tile.width, y = yPos * tile.height, width = item.image:getWidth(), height = item.image:getHeight(), sound = item.sound})
end

loot:drop(50, 50, items[1])
loot:drop(46, 48, items[2])
loot:drop(55, 60, items[3])
loot:drop(52, 48, items[3])

function loot:pickup()
	for i = #loot, 1, -1 do
		if checkCollision(player, loot[i]) then
			if player.itemsInInventory < player.maxInventory then
				if loot[i].name == "Potion of Minor Healing" then
					loot[i].sound:play()
					inv:addItem(item.new("Potion of Minor Healing","Assets/Images/UI/HealthPotionUI.png","Recover Some HP.", 1))
					table.remove(loot, i)
					player.itemsInInventory = player.itemsInInventory + 1
					console:addMessage("Picked Up Potion of Minor Healing", {0.12, 0.12, 0.12, 1}, 5)
				elseif loot[i].name == "Potion of Minor Magic" then
					loot[i].sound:play()
					inv:addItem(item.new("Potion of Minor Magic","Assets/Images/UI/MagicPotionUI.png","Recover Some MP.", 2))
					table.remove(loot, i)
					player.itemsInInventory = player.itemsInInventory + 1
					console:addMessage("Picked Up Potion of Minor Magic", {0.12, 0.12, 0.12, 1}, 5)
				elseif loot[i].name == "Gold" then
					local gp = math.random(10, 78)
					loot[i].sound:play()
					player.gold = player.gold + gp
					table.remove(loot, i)
					console:addMessage("Picked Up " .. gp .. " Gold", {0.12, 0.12, 0.12, 1}, 5)
				end
			end
		end
	end
end

function loot:draw()
	if #loot > 0 then
		for i = 1, #loot do
			love.graphics.draw(loot[i].image, loot[i].x, loot[i].y)
		end
	end
end
