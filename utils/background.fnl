(local WIDTH (* 16 48))
(local HEIGHT (* 16 27))

{:load (fn [name]
         {:image (love.graphics.newImage (.. :assets/Background/ name))
          :y -64
          :vel 40
          :update (fn [self dt]
                    (set self.y (+ self.y (* self.vel dt)))
                    (when (>= self.y 0)
                      (set self.y (- 64))))
          :draw (fn [self]
                  (for [y self.y HEIGHT 64]
                    (for [x 0 WIDTH 64]
                      (love.graphics.draw self.image x y))))})}
