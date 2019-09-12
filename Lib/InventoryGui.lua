local inventoryGui = {}

local w,h = love.graphics.getDimensions()

local item = require "Lib.Item"

local inv

local invW
local invH

local itemDrawW
local itemDrawH

function inventoryGui:setInventory(inventory,iconW,iconH)
  inv = inventory
  invW = #inv.arr[1]
  invH = #inv.arr
  itemDrawW = iconW
  itemDrawH = iconH
end

love.mouse.setVisible(true)

local mx,my = love.mouse.getPosition()

local mouseOn = {is=false,x=1,y=1}

local selected = {is=false,x=1,y=1}

local infoBox = {w=245,h=120}

function inventoryGui:update(xPos, yPos)
  mx,my = love.mouse.getPosition()
  mouseOn.is = false
  for y=1,invH do
    for x=1,invW do
      local drawX = (x-1)*itemDrawW
      local drawY = (y-1)*itemDrawH
      local mouseIsOn = mx > xPos + drawX and mx <= xPos + drawX+itemDrawW and my > yPos + drawY and my <= yPos + drawY+itemDrawH
      if mouseIsOn then 
        mouseOn.is = true
        mouseOn.x,mouseOn.y = x,y
      end
    end
  end
end

function inventoryGui:mousepressed(x,y,b)
  if b == 1 then
    if mouseOn.is then
      if not selected.is then
        if inv.arr[mouseOn.y][mouseOn.x] ~= 0 then
          selected.item = inv.arr[mouseOn.y][mouseOn.x].name
          selected.is = true
          selected.x = mouseOn.x
          selected.y = mouseOn.y
        end
      else
        inv:replace(selected.x,selected.y,mouseOn.x,mouseOn.y)
        selected.is = false
      end
    else
      if selected.is then
        inv:drop(selected.x, selected.y, math.floor(camera.mx / tile.width), math.floor(camera.my / tile.height))
        selected.is = false
      end
    end
  elseif b == 2 then
    if mouseOn.is then
      if not selected.is then
        if inv.arr[mouseOn.y][mouseOn.x] ~= 0 then
          if inv.arr[mouseOn.y][mouseOn.x].name == "Potion of Minor Healing" then
            if player.health < player.maxHealth then
              player:addHealth(math.random(5, 15))
              inv:remove(mouseOn.x, mouseOn.y)
              player.itemsInInventory = player.itemsInInventory - 1
            end
          elseif inv.arr[mouseOn.y][mouseOn.x].name == "Potion of Minor Magic" then
            if player.magic < player.maxMagic then
              player:addMagic(math.random(5, 15))
              inv:remove(mouseOn.x, mouseOn.y)
              player.itemsInInventory = player.itemsInInventory - 1
            end
          end
        end
      end
    end
  end
end

love.graphics.setLineWidth(2)
function inventoryGui:draw(xPos, yPos)
  love.graphics.setNewFont(18)
  for y=1,invH do
    for x=1,invW do
      local drawX = (x-1)*itemDrawW
      local drawY = (y-1)*itemDrawH
      local mouseOnThis = mouseOn.is and mouseOn.x == x and mouseOn.y == y
      if mouseOnThis then
        love.graphics.setColor(0.25, 0.25, 0.25, 1)
      else
        love.graphics.setColor(0.15, 0.15, 0.15, 1)
      end
      love.graphics.rectangle("fill", xPos + drawX, yPos + drawY,itemDrawW,itemDrawH)
      love.graphics.setColor(0, 0, 0, 1)
      love.graphics.rectangle("line", xPos + drawX, yPos + drawY,itemDrawW,itemDrawH)
      love.graphics.setColor(1, 1, 1, 1)
    end
  end
  for y=1,invH do
    for x=1,invW do
      local drawX = (x-1)*itemDrawW
      local drawY = (y-1)*itemDrawH
      local mouseOnThis = mouseOn.is and mouseOn.x == x and mouseOn.y == y
      local item = inv.arr[y][x]
      if selected.is and selected.x == x and selected.y == y then
        love.graphics.setColor(1, 1, 1, 0.45)
        love.graphics.draw(item.img,xPos + drawX, yPos + drawY)
        love.graphics.setColor(0, 0, 0, 0.3)
        love.graphics.draw(item.img,mx+10,my+10)
      elseif item ~= 0 then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(item.img,xPos + drawX, yPos + drawY)
      end
      if mouseOn.is and item ~= 0 and mouseOn.x == x and mouseOn.y == y then
        love.graphics.setColor(0.15, 0.15, 0.15, 0.45)
        love.graphics.rectangle("line",xPos + itemDrawW*invW+10,yPos + 0,infoBox.w,infoBox.h)
        love.graphics.setColor(0.25, 0.25, 0.25, 0.45)
        love.graphics.rectangle("fill",xPos + itemDrawW*invW+10,yPos + 0,infoBox.w,infoBox.h)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf(item.name .. "\n" .. item.desc, xPos + itemDrawW*invW+15,yPos + 0,infoBox.w-5)
      end
    end
  end
  if selected.is then
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(inv.arr[selected.y][selected.x].img,mx,my)
  end
  love.graphics.setColor(1, 1, 1, 1)
end

return inventoryGui