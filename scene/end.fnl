; librerias
(local background (require :utils.background))
(local newText (require "utils.text"))

; valores
(local bg (background.load "Celeste2.png"))
(local (WIDTH HEIGHT) (values (* 16 48) (* 16 27)))

(local bigfont (love.graphics.newFont "assets/Silkscreen-Regular.ttf" 64))
(local normalfont (love.graphics.newFont "assets/Silkscreen-Regular.ttf" 32))
(local smallfont (love.graphics.newFont "assets/Silkscreen-Regular.ttf" 16))
(local title (newText "FIN" bigfont [1 1 1] WIDTH HEIGHT 0 -120))
(local text (newText "Presiona Z\npara volver" normalfont [1 1 1] WIDTH HEIGHT 0 -50))
(local credits (newText "Hecho por:\nBruno Fernandez\nCarlos Castro\nFredy Quispe\nJoaquin Pino" smallfont [1 1 1] WIDTH HEIGHT 0 40))

(fn keypressed [key])

(fn keyreleased [key])

(fn update [dt]
  (bg:update dt)
  (if (love.keyboard.isDown "z") "menu" nil))

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
