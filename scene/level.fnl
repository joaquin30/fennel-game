; librerias
(local anim8 (require "lib.anim8"))
(local sti (require "lib.sti"))
(local bump (require "lib.bump"))
(local sprite (require "utils.sprite"))
(local background (require "utils.background"))

; objetos
(local player (require "actor.player"))
(local map (sti "map/Level 1.lua" ["bump"]))
(local world (bump.newWorld))
(local bg (background.load "Gray.png"))

; constantes
(local velH 150)
(local velY 400)
(local gravity 1500)

{
    :name "level"

    :init (fn []
        (map:bump_init world)
        (world:add player player.x player.y player.w player.h))

    :update (fn [dt]
        ; Fondo
        (bg:update dt)

        ; Input manager
        (let [left  (love.keyboard.isDown "left")
              right (love.keyboard.isDown "right")]
            (set player.vx
                (if (and left (not right)) (- velH)
                    (and right (not left)) velH 0)))
        
        ; update player
        (let [goal-x (+ player.x (* player.vx dt))
              goal-y (+ player.y (* player.vy dt))
              (actual-x actual-y) (world:move player goal-x goal-y)
              (_ len) (world:queryRect actual-x (+ actual-y player.h) player.w 1)] ; chequear si estamos en el piso
            (when (and (> len 0) (>= player.vy 0))
                (set player.onfloor true)
                (set player.vy 0))
            (when (= len 0)
                (set player.onfloor false))
            (when (< goal-y actual-y)
                (set player.vy 0))
            (set player.x actual-x)
            (set player.y actual-y)
            (when (not player.onfloor)
                (set player.vy
                    (math.min velY (+ player.vy (* gravity dt))))))

        ; update animations
        (when (< player.vx 0)
            (sprite.flipH player true))
        (when (> player.vx 0)
            (sprite.flipH player false))
        (when player.onfloor
            (set player.anim (if (> (math.abs player.vx) 0) "run" "idle")))
        (when (not player.onfloor)
            (set player.anim (if (>= player.vy 0) "jump" "fall")))
        (sprite.update player dt))

    :keypressed (fn [key]
        (when (and (= key "c") player.onfloor)
            (set player.onfloor false)
            (set player.vy (- velY))))

    :keyreleased (fn [key])

    :draw (fn []
        (bg:draw)
        (map:draw)
        ; (map:bump_draw) ; para ver colisiones
        (sprite.draw player))
        ;(love.graphics.print (tostring player.onfloor) 0 0)
        ;(love.graphics.print (tostring player.x) 0 10)
        ;(love.graphics.print (tostring player.y) 0 20))
}