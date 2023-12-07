;; Libraries
(local fennel (require :lib.fennel))
(local repl (require :lib.stdio))
(local push (require :lib.push))
(local scene-manager (require :utils.scene))

;; Scene manager
(var scene (scene-manager.load :level))

;; Constantes
(local STEP (/ 1 120)) ; 120 FPS para fisicas
(var accum 0)

;; Love functions
(fn love.load []
  (love.mouse.setVisible false)
  (let [(w h) (love.window.getDesktopDimensions)]
    (push:setupScreen (* 16 48) (* 16 27) w h {:fullscreen true}))
  (repl.start))

(fn love.draw []
  (push:start)
  (scene.draw)
  (love.graphics.print (tostring (love.timer.getFPS)))
  (push:finish))

(fn love.update [dt]
  (set accum (+ accum dt))
  (while (>= accum STEP)
    (scene.update STEP)
    (set accum (- accum STEP))))

(fn love.keypressed [key]
  ;; LIVE RELOADING
  (when (= :f5 key)
    (let [name (.. :scene. (. scene :name))]
      (let [old (require name)
            _ (tset package.loaded name nil)
            new (require name)]
        (when (= (type new) :table)
          (each [k v (pairs new)]
            (tset old k v))
          (each [k v (pairs old)]
            (when (not (. new k))
              (tset old k nil)))
          (tset package.loaded name old)))))
  (when (= :escape key)
    (love.event.quit))
  (scene.keypressed key))

(fn love.keyreleased [key]
  (scene.keyreleased key))
