hpPotionImage = love.graphics.newImage("Assets/Images/Loot/HP_PotionImage.png")
mpPotionImage = love.graphics.newImage("Assets/Images/Loot/MP_PotionImage.png")
dungeonKeyImage = love.graphics.newImage("Assets/Images/Loot/DungeonKey.png")

itemSound = love.audio.newSource("Assets/Sounds/Pickup.wav", "static")
goldSound = love.audio.newSource("Assets/Sounds/PickupGold.wav", "static")

items = {
	{name = "Potion of Minor Healing", image = hpPotionImage, sound = itemSound, id = 1},
	{name = "Potion of Minor Magic", image = mpPotionImage, sound = itemSound, id = 2},
	{name = "Dungeon Key", image = dungeonKeyImage, sound = goldSound, id = 3}
}