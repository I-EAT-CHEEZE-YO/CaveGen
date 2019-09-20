console = {}

console.fontSize = 22
console.font = love.graphics.newFont("Assets/Fonts/VT323.ttf", console.fontSize)
console.background = love.graphics.newImage("Assets/Images/UI/ConsoleBG.png")
console.messageShownTime = 100
console.messageUpdateFrequency = 1
console.maxLines = 5
console.maxMessageLength = 120
console.messages = {}


function console:addMessage(message, color, showTime)
	table.insert(console.messages, {message = message, color = color, time = 0, showTime = showTime})
end

function console:removeMessages()
	if #console.messages > 0 then
		if console.messages[1].time > console.messages[1].showTime then
			table.remove(console.messages, 1)
		elseif #console.messages > console.maxLines then
			table.remove(console.messages, 1)
		end
	end
end

function console:update(dt)
	for i = 1, #console.messages do
		console.messages[i].time = console.messages[i].time + console.messageUpdateFrequency * dt
	end
	console:removeMessages()
end

function console:draw(xPos, yPos)
	if #console.messages > 0 then
		love.graphics.draw(console.background, xPos, yPos + 10)
		for i = 1, #console.messages do
			love.graphics.setFont(console.font, console.fontSize)
			love.graphics.setColor(console.messages[i].color)
			love.graphics.printf(console.messages[i].message, xPos, yPos + (console.fontSize * i), 420, 'center')
		end
	end
	love.graphics.setColor(1, 1, 1, 1)
end

return console