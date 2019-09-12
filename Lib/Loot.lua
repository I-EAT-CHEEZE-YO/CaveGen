loot = {}

function loot:drop(xPos, yPos, item)
	table.insert(loot, {name = item.name, image = item.image, x = xPos * tile.width, y = yPos * tile.height, width = item.image:getWidth(), height = item.image:getHeight(), sound = item.sound})
end

loot:drop(50, 50, items[1])
loot:drop(46, 48, items[2])
loot:drop(55, 60, items[3])

function loot:pickup()
	for i = #loot, 1, -1 do
		if checkCollision(player, loot[i]) then
			if player.itemsInInventory < player.maxInventory then
				if loot[i].name == "Potion of Minor Healing" then
					loot[i].sound:play()
					inv:addItem(item.new("Potion of Minor Healing","Assets/Images/UI/HealthPotionUI.png","Recover Some HP.", 1))
					table.remove(loot, i)
					player.itemsInInventory = player.itemsInInventory + 1
				elseif loot[i].name == "Potion of Minor Magic" then
					loot[i].sound:play()
					inv:addItem(item.new("Potion of Minor Magic","Assets/Images/UI/MagicPotionUI.png","Recover Some MP.", 2))
					table.remove(loot, i)
					player.itemsInInventory = player.itemsInInventory + 1
				elseif loot[i].name == "Dungeon Key" then
					loot[i].sound:play()
					inv:addItem(item.new("Dungeon Key","Assets/Images/UI/DungeonKeyUI.png","Unlocks A Locked Door or Chest.", 3))
					table.remove(loot, i)
					player.itemsInInventory = player.itemsInInventory + 1
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
