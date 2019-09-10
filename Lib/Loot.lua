loot = {}

function loot:drop(xPos, yPos, item)
	table.insert(loot, {name = item.name, image = item.image, x = xPos * tile.width, y = yPos * tile.height, width = item.image:getWidth(), height = item.image:getHeight(), sound = item.sound})
end

loot:drop(50, 55, items[1])
loot:drop(45, 60, items[1])
loot:drop(40, 60, items[1])
loot:drop(35, 60, items[2])
loot:drop(45, 67, items[1])
loot:drop(48, 75, items[1])
loot:drop(25, 30, items[1])
loot:drop(50, 68, items[2])
loot:drop(44, 60, items[1])
loot:drop(43, 60, items[1])
loot:drop(42, 68, items[1])


function loot:pickup()
	for i = #loot, 1, -1 do
		if checkCollision(player, loot[i]) then
			if loot[i].name == "Potion of Minor Healing" then
				loot[i].sound:play()
				player:addToInventory(items[1], 1)
				table.remove(loot, i)
			elseif loot[i].name == "Potion of Minor Magic" then
				loot[i].sound:play()
				player:addToInventory(items[2], 1)
				table.remove(loot, i)
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
