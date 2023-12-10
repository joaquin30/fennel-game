(local animation (require :utils.animation))
(local sprite (require :utils.sprite))

(local path "assets/Main Characters/Ninja Frog/")

(local images
       {:idle (love.graphics.newImage (.. path "Idle (32x32).png"))
        :run (love.graphics.newImage (.. path "Run (32x32).png"))
        :jump (love.graphics.newImage (.. path "Jump (32x32).png"))
        :fall (love.graphics.newImage (.. path "Fall (32x32).png"))
        :wall (love.graphics.newImage (.. path "Wall Jump (32x32).png"))})

(local animations {:idle (animation.new (. images :idle))
                   :run (animation.new (. images :run))
                   :jump (animation.new (. images :jump))
                   :fall (animation.new (. images :fall))
                   :wall (animation.new (. images :wall))})

(fn draw [spr]
  (let [anim (. spr.animations spr.anim)
        img (. spr.images spr.anim)]
    (anim:draw img (math.floor (- spr.x 7)) (math.floor (- spr.y 6)))))

; constantes
(local VELX 150)
(local VELY 400)
(local GRAVITY 1500)

(fn stopJump [player]
  (set player.vy
    (if (< player.vy 0) (/ player.vy 5) player.vy)))

(fn jump [player]
  (when (and (= player.hascontrol 0) (<= player.airtime 20)
             (not player.hasjumped))
    (set player.hasjumped true)
    (set player.vy (- VELY)))
  (when (and (<= player.offwall 20) player.hascontrol)
    (set player.hascontrol 20)
    (set player.hasjumped true)
    (set player.vy (- VELY))
    (set player.vx (* VELX
      (if player.walldir -2 2)))))

(fn dash [player]
  (when (and (= player.hascontrol 0) (not player.hasdashed))
    (set player.hasdashed true)
    (set player.hascontrol 10)
    (set player.vx (* VELX
      (if player.flippedH -5 5)))))

(fn collFilter [player object]
  (when (= object.type "spike")
      (set player.dead true))
  "slide")

(fn update [player world dt]
  (when (= player.hascontrol 0)
    (set player.vx (if player.mov.right VELX player.mov.left (- VELX) 0)))

  (set player.colls {:up false :down false :left false :right false})

  (let [goalx (+ player.x (* player.vx dt))
        goaly (+ player.y (* player.vy dt))
        (actualx actualy) (world:move player goalx goaly collFilter)]
    (when (< goalx actualx)
      (set player.colls.right true))
    (when (> goalx actualx)
      (set player.colls.left true))
    (when (< goaly actualy)
      (set player.colls.up true))
    (when (> goaly actualy)
      (set player.colls.down true))
    (set player.x actualx)
    (set player.y actualy))

  (set player.airtime (+ player.airtime 1))
  (when player.colls.down
    (set player.airtime 0)
    (set player.vy 0)
    (set player.hasjumped false)
    (set player.hasdashed false))

  (when player.colls.up
    (set player.vy 0))

  (set player.hascontrol (- player.hascontrol
    (if (> player.hascontrol 0) 1 0)))

  (set player.offwall
    (if (and (not player.colls.down)
         (or player.colls.left player.colls.right))
      0 (+ player.offwall 1)))
  (when (and (not player.colls.down) player.colls.left)
    (set player.walldir true))
  (when (and (not player.colls.down) player.colls.right)
    (set player.walldir false))

  (set player.vy
    (math.min
      (if (= player.offwall 0) 100 300)
      (+ player.vy (* dt
        (if (< (math.abs player.vy) 50) (/ GRAVITY 2) GRAVITY )))))

  ; update animations
  (when (< player.vx 0)
    (sprite.flipH player true))
  (when (> player.vx 0)
    (sprite.flipH player false))
  (when (= player.airtime 0)
    (set player.anim (if (or player.mov.left player.mov.right) "run" "idle")))
  (when (> player.airtime 0)
    (set player.anim (if (>= player.vy 0) "jump" "fall")))
  (when (and (= player.offwall 0)
             (> player.vy 0))
    (set player.anim "wall") )

  (sprite.update player dt))

(fn newPlayer [x y]
  {
    : images
    : animations
    :anim "idle"
    :flippedH false ; false: right, true: left
    :mov {:up false :down false :left false :right false}
    :w 18 :h 26
    : x : y
    :vx 0 :vy 0
    :colls {:up false :down false :left false :right false}
    :airtime 0
    :hasjumped false
    :hasdashed false
    :offwall 0
    :walldir false ; false: right, true: left
    :hascontrol 0
    :dead false

  ;; Functions
    : jump
    : dash
    : stopJump
    : update
    : draw
  })
