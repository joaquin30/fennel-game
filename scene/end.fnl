; librerias
(local background (require :utils.background))
; objetos
(local bg (background.load "Celeste2.png"))
(local (WIDTH HEIGHT) (values (* 16 48) (* 16 27)))

(fn keypressed [key])

(fn keyreleased [key])

(fn update [dt]
  (bg:update dt)
  (if
    (love.keyboard.isDown "x")
      "menu"
      nil))

(fn draw []
  (bg:draw)
  (love.graphics.print "FIN" (- (/ WIDTH 2) 16) (- (/ HEIGHT 2) 16))
  (love.graphics.print "PRESIONA X PARA EL MENU" (- (/ WIDTH 2) 96) (/ HEIGHT 2)))

{
  :name "level"
  : keypressed
  : keyreleased
  : update
  : draw
}
