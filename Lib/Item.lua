local item = {}
item.__index = item

function item.new(name,img,desc,id)
  local itm = {}
  setmetatable(itm,item)
  itm.name = name
  itm.img = love.graphics.newImage(img)
  itm.desc = desc
  itm.id = id
  return itm
end

return item