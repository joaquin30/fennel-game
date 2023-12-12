; librerias
(local background (require :utils.background))
(local newText (require "utils.text"))

; valores
(local bg (background.load "Celeste2.png"))
(local (WIDTH HEIGHT) (values (* 16 48) (* 16 27)))

(local bigfont (love.graphics.newFont "assets/Silkscreen-Regular.ttf" 64))
(local normalfont (love.graphics.newFont "assets/Silkscreen-Regular.ttf" 32))
(local smallfont (love.graphics.newFont "assets/Silkscreen-Regular.ttf" 16))
(bigfont:setLineHeight 0.7)
(local title (newText "Plataformas\nde Fennel" bigfont [1 1 1] WIDTH HEIGHT 0 -100))
(local text (newText "Presiona X para jugar" normalfont [1 1 1] WIDTH HEIGHT 0 40))
(local credits (newText "Lenguajes de programación\n UCSP 2023-2" smallfont [1 1 1] WIDTH HEIGHT 0 100))

(fn keypressed [key])

(fn keyreleased [key])

(fn update [dt]
  (bg:update dt)
  (if (love.keyboard.isDown "x") "level1" nil))

(fn draw []
  (bg:draw)
  (title:draw)
  (text:draw)
  (credits:draw))

{
  :name "level"
  : keypressed
  : keyreleased
  : update
  : draw
}
