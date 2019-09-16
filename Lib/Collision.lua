	function checkCollision(obj1, obj2)
  		return obj1.x < obj2.x + obj2.width and
  		obj2.x < obj1.x + obj1.width and
        obj1.y < obj2.y + obj2.height and
        obj2.y < obj1.y + obj1.height
	end

	function resolveCollision(obj1, obj2)
		if checkCollision(obj1, obj2) then
			obj1.x = player.oldPos.x
			obj1.y = player.oldPos.y
		end
	end

	function resolveEnemyCollision(obj1, obj2)
		if checkCollision(obj1, obj2) then
			obj1.x = obj1.oldPos.x
			obj1.y = obj1.oldPos.y
			if obj1.dir == 1 then
				obj1.dir = 2
				obj1.updateTime = 0
			elseif obj1.dir == 2 then
				obj1.updateTime = 0
				obj1.dir = 1
			elseif obj1.dir == 4 then
				obj1.dir = 3
				obj1.updateTime = 0
			elseif obj1.dir == 3 then
				obj1.dir = 4
				obj1.updateTime = 0
			end
		end
	end