local love   = require('love')
local enemy  = require('Enemy')
local button = require('Button')

math.randomseed(os.time())

local player       = {
  radius = 20,
  x = 30,
  y = 30,
}

local game         = {
  dificulty = 1,
  state = {
    menu = true,
    running = false,
    pause = false,
    ended = false,
  },
  points = 0,
  levels = { 15, 30, 45, 60, 75, 90, 105, 120 },
  changeState = function(self, state)
    self.state['running'] = state == 'running'
    self.state['menu'] = state == 'menu'
    self.state['pause'] = state == 'pause'
    self.state['ended'] = state == 'ended'
  end,
}

local fonts = {
  medium = {
    font = love.graphics.newFont(16),
    size = 16,
  },
  large = {
    font = love.graphics.newFont(24),
    size = 24,
  },
  massive = {
    font = love.graphics.newFont(60),
    size = 60,
  }
}

local buttons      = {
  menu_state = {}
}

local enemies      = {}

local startNewGame = function()
  game:changeState('running')
  game.points = 0

  enemies = { enemy(1) }
end

love.load          = function()
  love.mouse.setVisible(false)
  table.insert(enemies, 1, enemy())

  buttons.menu_state.play_game = button('Play Game', startNewGame, nil, 120, 40)
  buttons.menu_state.settings = button('Settings', nil, nil, 120, 40)
  buttons.menu_state.exit_game = button('Exit Game', love.event.quit, nil, 120, 40)
end

love.mousepressed  = function(x, y, btn)
  if game.state['running'] then return end
  if game.state['menu'] then
    if btn == 1 then
      for index in pairs(buttons.menu_state) do
        buttons.menu_state[index]:checkPressed(x, y, player.radius / 2)
      end
    end
  end
end

love.update        = function(dt)
  player.x, player.y = love.mouse.getPosition()
  if game.state['running'] then
    for i = 1, #enemies, 1 do
      if not enemies[i]:checkTouched(player.x, player.y, player.radius) then
        enemies[i]:move(player.x, player.y)

        for j = 1, #game.levels do
          if math.floor(game.points) == game.levels[j] then
            table.insert(enemies, 1, enemy(game.dificulty * (j + 1)))
            game.points = game.points + 5
          end
        end
      else
        game:changeState('menu')
      end
    end
    game.points = game.points + dt
  end
end

love.draw          = function()
  love.graphics.setFont(fonts.medium.font)
  love.graphics.printf(love.timer.getFPS(), fonts.medium.font, 10,
    love.graphics.getHeight() - 30, love.graphics.getWidth())

  if game.state['running'] then
    love.graphics.printf(math.floor(game.points), fonts.large.font, 0, 10, love.graphics.getWidth(), 'center')

    for i = 1, #enemies, 1 do
      enemies[i]:draw()
    end

    love.graphics.circle('fill', player.x, player.y, player.radius)
  elseif game.state['menu'] then
    buttons.menu_state.play_game:draw(nil, 20)
    buttons.menu_state.settings:draw(nil, 80)
    buttons.menu_state.exit_game:draw(nil, 140)
  end

  if not game.state['running'] then
    love.graphics.circle('fill', player.x, player.y, player.radius / 2)
  end
end
