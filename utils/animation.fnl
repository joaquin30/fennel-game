(local anim8 (require :lib.anim8))

{; Crear nueva animación
 ; Ej: (animation.new (love.graphics.newImage "ruta/imagen.png"))
 :new (fn [img]
        (let [w (img:getWidth)
              h (img:getHeight)
              grid (anim8.newGrid 32 32 w h)]
          (anim8.newAnimation (grid (.. :1- (tostring (/ w 32))) 1) 0.05)))}
