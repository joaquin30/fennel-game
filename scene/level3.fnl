; librerias
(local anim8 (require "lib.anim8"))
(local bump (require "lib.bump"))
(local sprite (require "utils.sprite"))
(local background (require "utils.background"))
(local loadTilemap (require "map.tilemap"))
(local newPlayer (require "actor.player"))
(local bumpDraw (require "utils.bump_draw"))

; constantes
(local CURRENT_LEVEL "level3")
(local NEXT_LEVEL "level4")
(local TILEMAP "map.level.3")

; objetos
(var player nil)
(var bg nil)
(var world nil)
(var tilemap nil)

(fn init []
  (set player (newPlayer 20 280 "Pink Man"))
  (sprite.flipH player false)
  (sprite.flipH player true)
  (sprite.flipH player false)
  (set bg (background.load "Celeste2.png"))
  (set world (bump.newWorld))
  (set tilemap (loadTilemap TILEMAP world))
  (world:add player player.x player.y player.w player.h))

(fn keypressed [key]
  (if
    (= key "left")
      (set player.mov.left true)
    (= key "right")
      (set player.mov.right true)
    (= key "up")
      (set player.mov.up true)
    (= key "down")
      (set player.mov.down true)
    (= key "c")
      (player:jump)
    (= key "x")
      (player:dash)))

(fn keyreleased [key]
  (if
    (= key "left")
      (set player.mov.left false)
    (= key "right")
      (set player.mov.right false)
    (= key "up")
      (set player.mov.up false)
    (= key "down")
      (set player.mov.down false)
    (= key "c")
      (player:stopJump)))

(fn update [dt]
  (bg:update dt)
  (player:update world dt)
  (if player.dead CURRENT_LEVEL (< player.y -10) NEXT_LEVEL nil))

(fn draw []
  (bg:draw)
  (love.graphics.draw tilemap)
  (player:draw))
  ;(bumpDraw world))

{
  :name "level"
  : init
  : keypressed
  : keyreleased
  : update
  : draw
}
