local love  = require("love")
local enemy = require("Enemy")

math.randomseed(os.time())

local player  = {
  radius = 20,
  x = 30,
  y = 30,
}

local game    = {
  dificulty = 1,
  state = {
    menu = false,
    running = true,
    pause = false,
    ended = false,
  }
}

local enemies = {}

love.load     = function()
  love.mouse.setVisible(false)
  table.insert(enemies, 1, enemy())
end

love.update   = function()
  player.x, player.y = love.mouse.getPosition()
  for i = 1, #enemies, 1 do
    enemies[i]:move(player.x, player.y)
  end
end

love.draw     = function()
  love.graphics.printf(love.timer.getFPS(), love.graphics.newFont(14), 10,
    love.graphics.getHeight() - 30, love.graphics.getWidth())

  if game.state["running"] then
    for i = 1, #enemies, 1 do
      enemies[i]:draw()
    end

    love.graphics.circle("fill", player.x, player.y, player.radius)
  end

  if not game.state["running"] then
    love.graphics.circle("fill", player.x, player.y, player.radius / 2)
  end
end
