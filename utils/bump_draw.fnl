(fn bumpDraw [world]
  (let [items (world:getItems)]
    (each [_ item (ipairs items)]
      (love.graphics.rectangle "line" (world:getRect item)))))
