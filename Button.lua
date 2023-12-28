local love = require('love')

local Button = function(text, func, func_param, width, height)
  return {
    width = width or 0,
    height = height or 0,
    func = func or function(self) print('This function doesn\'t have any use') end,
    func_param = func_param,
    text = text or 'No text',
    button_x = 10,
    button_y = 0,
    text_x = 10,
    text_y = 12,

    checkPressed = function(self, mouse_x, mouse_y, mouse_radius)
      if mouse_x + mouse_radius >= self.button_x and mouse_x - mouse_radius <= self.width + self.button_x then
        if mouse_y + mouse_radius >= self.button_y and mouse_y - mouse_radius <= self.height + self.button_y then
          if self.func_param then
            self.func(self.func_param)
          else
            self.func()
          end
        end
      end
    end,

    draw = function(self, button_x, button_y, text_x, text_y)
      self.button_x = button_x or self.button_x
      self.button_y = button_y or self.button_y

      if text_x then
        self.text_x = text_x
      end
      if text_y then
        self.text_y = text_y
      end

      love.graphics.setColor(0.6, 0.6, 0.6)
      love.graphics.rectangle('fill', self.button_x, self.button_y, self.width, self.height)

      love.graphics.setColor(0, 0, 0)
      love.graphics.print(self.text, self.text_x + self.button_x, self.text_y + self.button_y)
      self.text_x = 10
      self.text_y = 12

      love.graphics.setColor(1, 1, 1)
    end
  }
end

return Button
