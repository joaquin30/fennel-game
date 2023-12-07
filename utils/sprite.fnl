{; cambia la animacion del sprite a otra
 :change (fn [spr name]
           (let [anim (. spr.animations name)]
             (anim:gotoFrame 1)
             (set anim.flippedH spr.flippedH))
           (set spr.anim name))
 ; Hace que el sprite mire hacia la izq o der
 ; si flip = false mira a la derecha
 ; si flip = true mira a la izquierda
 :flipH (fn [spr flip]
          (when (not= flip spr.flippedH)
            (set spr.flippedH flip)
            (each [_ anim (pairs spr.animations)]
              (set anim.flippedH flip))))
 ; corre la animacion
 :update (fn [spr dt]
           (let [anim (. spr.animations spr.anim)]
             (anim:update dt)))
 ; dibuja el sprite
 :draw (fn [spr]
         (let [anim (. spr.animations spr.anim)
               img (. spr.images spr.anim)]
           (anim:draw img spr.x spr.y)))}
