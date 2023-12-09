; librerias
(local anim8 (require :lib.anim8))
(local bump (require :lib.bump))
(local sprite (require :utils.sprite))
(local background (require :utils.background))
(local loadTilemap (require "map.tilemap"))

; objetos
(local player (require :actor.player))
;(local map (sti "map/Level 2.lua" [:bump]))
(local world (bump.newWorld))
(local bg (background.load "Celeste2.png"))
(local tilemap (loadTilemap "map.level.1" world))

(fn init []
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
  (player:update world dt))
  ;(print player.x player.y))

(fn draw []
  (bg:draw)
  ;(love.graphics.setBlendMode "alpha" "premultiplied")
  (love.graphics.draw tilemap)
  ;(love.graphics.setBlendMode "alpha" "alphamultiply")
  (player:draw))

{
  :name "level"
  : init
  : keypressed
  : keyreleased
  : update
  : draw
}
