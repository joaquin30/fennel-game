(local WIDTH 48)
(local HEIGHT 27)
(local TILEWIDTH 16)
(local TILEHEIGHT 16)
(local TERRAIN_PATH "assets/Terrain/Terrain.png")
(local TERRAIN_WIDTH 22)
(local TERRAIN_HEIGHT 11)
(local SPIKE_ID 21)

(fn getCoords [w h x]
  (values (* (% x w) TILEWIDTH) (* (math.floor (/ x w)) TILEHEIGHT)))

(fn loadTilemap [path world]
  (let [tilemap (require path)
        img (love.graphics.newImage TERRAIN_PATH)
        batch (love.graphics.newSpriteBatch img (* WIDTH TILEWIDTH HEIGHT TILEHEIGHT))]
    (batch:clear)
    (each [i v (ipairs tilemap)]
      (when (>= v 0)
        (let [(px py) (getCoords WIDTH HEIGHT (- i 1))
              (qx qy) (getCoords TERRAIN_WIDTH TERRAIN_HEIGHT v)
              quad (love.graphics.newQuad qx qy TILEWIDTH TILEHEIGHT img)]
        (batch:add quad px py)
        (world:add {:type (if (= v SPIKE_ID) "spike" "terrain")}
          (if (= v SPIKE_ID) (+ px 4) px)
          (if (= v SPIKE_ID) (+ py 12) py)
          (if (= v SPIKE_ID) 8 TILEWIDTH)
          (if (= v SPIKE_ID) 4 TILEHEIGHT)))))
    (batch:flush)
    batch))
