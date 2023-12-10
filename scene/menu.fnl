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
    (love.keyboard.isDown "escape")
      (love.event.quit)
    (and (love.keyboard.isDown "c") (love.keyboard.isDown "x"))
      "level1"
      nil))

(fn draw []
  (bg:draw)
  (love.graphics.print "PRESIONA X+C" (- (/ WIDTH 2) 64) (- (/ HEIGHT 2) 32))
  (love.graphics.print "ESC PARA SALIR" (- (/ WIDTH 2) 64) (/ HEIGHT 2)))

{
  :name "level"
  : keypressed
  : keyreleased
  : update
  : draw
}
