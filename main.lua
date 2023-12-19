local love = require("love")

local player = {
  radius = 20,
  x = 30,
  y = 30,
}

local game = {
  state = {
    menu = false,
    running = true,
    pause = false,
    ended = false,
  }
}

love.load = function()
  love.mouse.setVisible(false)
end

love.update = function()
  player.x, player.y = love.mouse.getPosition()
end

love.draw = function()
  love.graphics.printf(love.timer.getFPS(), love.graphics.newFont(14), 10,
    love.graphics.getHeight() - 30, love.graphics.getWidth())

  if game.state["running"] then
    love.graphics.circle("fill", player.x, player.y, player.radius)
  end

  if not game.state["running"] then
    love.graphics.circle("fill", player.x, player.y, player.radius / 2)
  end
end
