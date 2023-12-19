local love = require('love')

local player = {
  radius = 20,
  x = 30,
  y = 30,
}

love.load = function()
  love.mouse.setVisible(false)
end

love.update = function()
  player.x, player.y = love.mouse.getPosition()
end

love.draw = function()
  love.graphics.circle('fill', player.x, player.y, player.radius)
end
