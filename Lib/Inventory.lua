local utils = require "Lib.Utils"

errorSound = love.audio.newSource("Assets/Sounds/ErrorSound.wav", "static")
dropSound = love.audio.newSource("Assets/Sounds/DropItem.wav", "static")

inventory = {}
inventory.__index = inventory

function inventory.new(w,h)
  local inv = {}
  setmetatable(inv,inventory)
  inv.w = w
  inv.h = h
  inv.arr = utils.newEmptyArr(w,h,0)
  return inv
end

function inventory:addItem(item)
  local stop = false
  for y=1,#self.arr do
    for x=1,#self.arr[1] do
      if self.arr[y][x] == 0 then
        self.arr[y][x] = item
        stop = true
        break
      end
    end
    if stop then break end
  end
end

function inventory:replace(x1,y1,x2,y2)
  local ph = self.arr[y1][x1]
  self.arr[y1][x1] = self.arr[y2][x2]
  self.arr[y2][x2] = ph
end

function inventory:remove(x, y)
  self.arr[y][x] = 0
end

function inventory:drop(x, y, xPos, yPos)
  if self.arr[y][x].id ~= -1 then
    if map.data[xPos][yPos] == 1 then
      loot:drop(xPos, yPos, items[self.arr[y][x].id])
      self.arr[y][x] = 0
      dropSound:play()
    else
      errorSound:play()
    end
  end
end

return inventory