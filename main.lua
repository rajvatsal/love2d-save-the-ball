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
  running = function(self, enemies, dt)
    for i = 1, #enemies, 1 do
      if not enemies[i]:checkTouched(player.x, player.y, player.radius) then
        enemies[i]:move(player.x, player.y)

        for j = 1, #self.levels do
          if math.floor(self.points) == self.levels[j] then
            table.insert(enemies, 1, enemy(self.dificulty * (j + 1)))
            self.points = self.points + 5
          end
        end
      else
        changeGameState('ended')
      end
    end
    self.points = self.points + dt
  end
}

changeGameState    = function(state)
  game.state['running'] = state == 'running'
  game.state['menu'] = state == 'menu'
  game.state['pause'] = state == 'pause'
  game.state['ended'] = state == 'ended'
end

local fonts        = {
  medium = {
    font = love.graphics.newFont(14),
    size = 14,
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
  menu_state = {},
  ended_state = {},
  pause_state = {},
}

local enemies      = {}

local startNewGame = function()
  changeGameState('running')
  game.points = 0

  enemies = { enemy(1) }
end

love.load          = function()
  love.mouse.setVisible(false)
  table.insert(enemies, 1, enemy())

  buttons.menu_state.play_game = button('Play Game', startNewGame, nil, 120, 40)
  buttons.menu_state.settings = button('Settings', nil, nil, 120, 40)
  buttons.menu_state.exit_game = button('Exit Game', love.event.quit, nil, 120, 40)

  buttons.ended_state.replay_game = button('Replay', startNewGame, nil, 100, 50)
  buttons.ended_state.menu = button('Menu', changeGameState, 'menu', 100, 50)
  buttons.ended_state.exit_game = button('Quit', love.event.quit, nil, 100, 50)

  buttons.pause_state.continue_game = button('Continue', changeGameState, 'running', 100, 50)
  buttons.pause_state.menu = button('Menu', changeGameState, 'menu', 100, 50)
  buttons.pause_state.exit_game = button('Quit', love.event.quit, nil, 100, 50)
end

love.mousepressed  = function(x, y, btn)
  if game.state['running'] then return end
  if game.state['menu'] then
    if btn == 1 then
      for index in pairs(buttons.menu_state) do
        buttons.menu_state[index]:checkPressed(x, y, player.radius / 2)
      end
    end
  elseif game.state['ended'] then
    if btn == 1 then
      for index in pairs(buttons.ended_state) do
        buttons.ended_state[index]:checkPressed(x, y, player.radius / 2)
      end
    end
  elseif game.state['pause'] then
    if btn == 1 then
      for index in pairs(buttons.pause_state) do
        buttons.pause_state[index]:checkPressed(x, y, player.radius / 2)
      end
    end
  end
end

love.keypressed    = function(key)
  if key == 'escape' then
    if game.state['pause'] then
      changeGameState('running')
    elseif game.state['running'] then
      changeGameState('pause')
    end
  end
end

love.update        = function(dt)
  player.x, player.y = love.mouse.getPosition()
  if game.state['running'] then
    game:running(enemies, dt)
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
    buttons.menu_state.play_game:draw(nil, 15)
    buttons.menu_state.settings:draw(nil, 70)
    buttons.menu_state.exit_game:draw(nil, 125)
  elseif game.state['ended'] then
    buttons.ended_state.replay_game:draw(love.graphics.getWidth() / 2.15, love.graphics.getHeight() / 1.8, 22.5, 16.5)
    buttons.ended_state.menu:draw(love.graphics.getWidth() / 2.15, love.graphics.getHeight() / 1.53, 29.5, 16.5)
    buttons.ended_state.exit_game:draw(love.graphics.getWidth() / 2.15, love.graphics.getHeight() / 1.33, 32.5, 16.5)

    love.graphics.printf(math.floor(game.points), fonts.massive.font, 0,
      love.graphics.getHeight() / 2 - fonts.massive.size, love.graphics.getWidth(), 'center')
  end

  if game.state['pause'] then
    buttons.pause_state.continue_game:draw(love.graphics.getWidth() / 2.15, love.graphics.getHeight() / 1.8, 16.5, 16.5)
    buttons.pause_state.menu:draw(love.graphics.getWidth() / 2.15, love.graphics.getHeight() / 1.53, 29.5, 16.5)
    buttons.pause_state.exit_game:draw(love.graphics.getWidth() / 2.15, love.graphics.getHeight() / 1.33, 32.5, 16.5)

    love.graphics.printf('paused', fonts.massive.font, 0, love.graphics.getHeight() / 2 - fonts.massive.size,
      love.graphics.getWidth(), 'center')
  end

  if not game.state['running'] then
    love.graphics.circle('fill', player.x, player.y, player.radius / 2)
  end
end
