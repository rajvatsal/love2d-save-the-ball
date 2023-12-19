local love = require("love")

local Enemy = function()
  local _dice, _x, _y, _radius = 0, 0, 0, 20

  _dice = math.random(1, 4)

  if _dice == 1 then
    _x = math.random(_radius, love.graphics.getWidth())
    _y = -_radius * 4
  elseif _dice == 2 then
    _x = love.graphics.getWidth() + _radius * 4
    _y = math.random(_radius, love.graphics.getHeight())
  elseif _dice == 3 then
    _x = math.random(_radius, love.graphics.getWidth())
    _y = love.graphics.getHeight + _radius * 4
  else
    _x = -_radius * 4
    _y = math.random(_radius, love.graphics.getHeight())
  end

  return {
    level = 1,
    radius = _radius,
    x = _x,
    y = _y,
    move = function(self, player_x, player_y)
      if player_x - self.x > 0 then
        self.x = self.x + self.level
      elseif player_x - self.x < 0 then
        self.x = self.x - self.level
      end

      if player_y - self.y > 0 then
        self.y = self.y + self.level
      elseif player_y - self.y < 0 then
        self.y = self.y - self.level
      end
    end,
    draw = function(self)
      love.graphics.setColor(1, 0, 0) -- red
      love.graphics.circle("fill", self.x, self.y, self.radius)
      love.graphics.setColor(1, 1, 1) -- white
    end
  }
end

return Enemy
