hpPotionImage = love.graphics.newImage("Assets/Images/Loot/HP_PotionImage.png")
hpPotionUI_Image = love.graphics.newImage("Assets/Images/UI/HP_Potion_UI_Image.png")

mpPotionImage = love.graphics.newImage("Assets/Images/Loot/MP_PotionImage.png")
mpPotionUI_Image = love.graphics.newImage("Assets/Images/UI/MP_Potion_UI_Image.png")

--goldPileImage = love.graphics.newImage("Assets/Images/Loot/GoldPileImage.png")

items = {}

items[1] = {name = "Potion of Minor Healing", type = "HealthPotion", uiImage = hpPotionUI_Image, image = hpPotionImage, sound = love.audio.newSource("Assets/Sounds/pickup_temp.wav", "static")}
items[2] = {name = "Potion of Minor Magic", type = "MagicPotion", uiImage = mpPotionUI_Image, image = mpPotionImage, sound = love.audio.newSource("Assets/Sounds/pickup_temp.wav", "static")}