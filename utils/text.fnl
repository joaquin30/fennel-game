(fn newText [text font color screen_w screen_h offset_x offset_y]
  {
    : text : font : color
    :x (+ (math.floor (/ (- screen_w (font:getWidth text)) 2)) offset_x)
    :y (+ (math.floor (/ (- screen_h (font:getHeight)) 2)) offset_y)
    :w (font:getWidth text)

    :draw (fn [self]
      (love.graphics.setColor self.color)
      (love.graphics.printf self.text self.font self.x self.y self.w "center"))
  })
