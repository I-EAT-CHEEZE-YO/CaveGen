map = {}

map.width = 75
map.height = 90
map.type = 'cave'

map.birthLimit = 4
map.deathLimit = 5
map.chanceToStartAlive = 0.45
map.iterations = 4
map.minFloorTiles = 55.5

map.miniMapBG = love.graphics.newImage("Assets/Images/UI/MiniMapBorder.png")

map.data = {}

map.collisionData = {} -- {ID, x, y, width, height}


tile = {width = 32, height = 32}

tiles = {
	floor = love.graphics.newImage("Assets/Images/Floor.png"),
	wall = love.graphics.newImage("Assets/Images/Wall.png"),
	top_left_corner = love.graphics.newImage("Assets/Images/TopLeftCorner.png"),
	top_right_corner = love.graphics.newImage("Assets/Images/TopRightCorner.png"),
	bottom_left_corner = love.graphics.newImage("Assets/Images/BottomLeftCorner.png"),
	bottom_right_corner = love.graphics.newImage("Assets/Images/BottomRightCorner.png")
}

function countNeighbors(x, y)
	local n = 0
	if x == 0 or x == map.width then n = n + 1 end
	if x == 0 or y == map.height then n = n + 1 end

	if x > 0 and x < map.width -1 and y > 0 and y < map.height -1 then
		if map.data[x-1][y-1] == 1 then n = n + 1 end
		if map.data[x][y-1] == 1 then n = n + 1 end
		if map.data[x+1][y-1] == 1 then n = n + 1 end
		if map.data[x-1][y] == 1 then n = n + 1 end
		if map.data[x+1][y] == 1 then n = n + 1 end
		if map.data[x-1][y+1] == 1 then n = n + 1 end
		if map.data[x][y+1] == 1 then n = n + 1 end
		if map.data[x+1][y+1] == 1 then n = n + 1 end
	end
	return n
end

function countFloors()
	local nFloors = 0
	for x = 0, map.width do
		for y = 0, map.height do
			if map.data[x][y] == 1 then
				nFloors = nFloors + 1
			end
		end
	end
	return nFloors
end

function map:emptyMap()
	for x = 0, map.width do
		map.data[x] = {}
		for y = 0, map.height do
			map.data[x][y] = 0
		end
	end
end

function map:randomise()
	for x = 0, map.width do
		for y = 0, map.height do
			if math.random() > map.chanceToStartAlive then
				map.data[x][y] = 1
			else
				map.data[x][y] = 0
			end
		end
	end
end

function map:iterate()
	temp = {}
	temp.data = map.data
	for x = 0, map.width do
		for y = 0, map.height do
			if map.data[x][y] == 1 and countNeighbors(x, y) >= 4 then
				temp.data[x][y] = 1
			elseif map.data[x][y] == 0 and countNeighbors(x, y) >= 5 then
				temp.data[x][y] = 1
			else
				temp.data[x][y] = 0
			end
		end
	end
	map.data = temp.data
end

function map:fixCorners()
	for x = 0, map.width do
		for y = 0, map.height do
			if map.data[x][y] == 1 then
				if map.data[x-1][y-1] == 0 and map.data[x][y-1] == 0 and map.data[x-1][y] == 0 then
					map.data[x][y] = "tlc"
				end
				if map.data[x][y-1] == 0 and map.data[x+1][y-1] == 0 and map.data[x+1][y] == 0 then
					map.data[x][y] = "trc"
				end
				if map.data[x-1][y] == 0 and map.data[x-1][y+1] == 0 and map.data[x][y+1] == 0 then
					map.data[x][y] = "blc"
				end
				if map.data[x+1][y] == 0 and map.data[x+1][y+1] == 0 and map.data[x][y+1] == 0 then
					map.data[x][y] = "brc"
				end

			end
		end
	end
end

function map:populateCollisionData()
	map.collisionData = {}
	local nWalls = 0
	for x = 0, map.width do
		for y = 0, map.height do
			if map.data[x][y] == 0 then
				table.insert(map.collisionData, {id = nWalls, x = x * tile.width, y = y * tile.height, width = tile.width, height = tile.height})
				nWalls = nWalls + 1
			end
		end
	end
end

function map:repopulateCollisionData()
	map.collisionData = {}
	local nWalls = 0
	for x = 0, map.width do
		for y = 0, map.height do
			if map.data[x][y] == 0 then
				table.insert(map.collisionData, {id = nWalls, x = x * tile.width, y = y * tile.height, width = tile.width, height = tile.height})
				nWalls = nWalls + 1
			end
		end
	end
end

function map:generate(type, args)
	if args ~= nil then
		if args.width ~= nil then
			map.width = args.width
		end
		if args.height ~= nil then
			map.height = args.height
		end
		if args.iterations ~= nil then
			map.iterations = args.iterations
		end
	end
	if type == 'cave' then
		map.type = 'cave'
		map:emptyMap()
		map:randomise()
		for i = 1, map.iterations do
			map:iterate()
		end
		map:populateCollisionData()
		player:pickSpawn()
	end
end

function map:drawCollisionData()
	love.graphics.setColor(1, 0, 0, 1)
	for i = 1, #map.collisionData do
		love.graphics.rectangle('line', map.collisionData[i].x, map.collisionData[i].y, map.collisionData[i].width, map.collisionData[i].height)
	end
	love.graphics.setColor(1, 1, 1, 1)
end

function map:draw(xOffset, yOffset)
	for x = 0, map.width do
		for y = 0, map.height do
			if map.data[x][y] == 1 then --FLOOR
				love.graphics.draw(tiles.floor, xOffset + (x * tile.width), yOffset + (y * tile.height))
			elseif map.data[x][y] == 0 then --WALL
				love.graphics.draw(tiles.wall, xOffset + (x * tile.width), yOffset + (y * tile.height))
			elseif map.data[x][y] == "tlc" then
				love.graphics.draw(tiles.top_left_corner, xOffset + (x * tile.width), yOffset + (y * tile.height))
			elseif map.data[x][y] == "trc" then
				love.graphics.draw(tiles.top_right_corner, xOffset + (x * tile.width), yOffset + (y * tile.height))
			elseif map.data[x][y] == "brc" then
				love.graphics.draw(tiles.bottom_right_corner, xOffset + (x * tile.width), yOffset + (y * tile.height))
			elseif map.data[x][y] == "blc" then
				love.graphics.draw(tiles.bottom_left_corner, xOffset + (x * tile.width), yOffset + (y * tile.height))
			end

		end
	end
end

function map:drawMiniMap(xPos, yPos)
	local cell = {width = 3, height = 3}
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(map.miniMapBG, xPos - 3, yPos - 3)
	love.graphics.setColor(0.55, 0.43, 0.38, 1)
	love.graphics.rectangle('fill', xPos, yPos, map.width * cell.width , map.height * cell.height)
	for x = 0, map.width do
		for y = 0, map.height do
			if map.data[x][y] == 1 then --FLOOR
				love.graphics.setColor(0.73, 0.66, 0.64, 1)
				love.graphics.rectangle('fill', xPos + (x * cell.width) , yPos + (y * cell.height) , cell.width, cell.height)
			end
		end
	end
	love.graphics.setColor(1, 1, 1, 1)
end

return map