(local animation (require :utils.animation))
(local sprite (require :utils.sprite))

(fn draw [spr]
  (let [anim (. spr.animations spr.anim)
        img (. spr.images spr.anim)]
    (anim:draw img (math.floor (- spr.x 7)) (math.floor (- spr.y 6))))
  (love.graphics.draw spr.particle_system))

; constantes
(local VELX 150)
(local VELY 450)
(local GRAVITY 1700)
(local DASH_VEL 750)

(fn stopJump [player]
  (set player.vy
    (if (< player.vy 0) (/ player.vy 5) player.vy)))

(fn jump [player]
  (when (and (= player.hascontrol 0) (<= player.airtime 20)
             (not player.hasjumped))
    (love.audio.play player.images.jump_sound)
    (player.particle_system:emit 10)
    (set player.hasjumped true)
    (set player.vy (- VELY)))
  (when (and (<= player.offwall 10) player.hascontrol)
    (love.audio.play player.images.jump_sound)
    (player.particle_system:emit 10)
    (set player.hascontrol 25)
    (set player.hasjumped true)
    (set player.vy (* VELY -1))
    (set player.vx (* VELX
      (if player.walldir -1.75 1.75)))))

(fn dash [player]
  (when (and (= player.hascontrol 0) (= player.hasdashed 0) player.candash)
    (love.audio.play player.images.dash_sound)
    (set player.candash false)
    (set player.hasdashed 15)
    (set player.hascontrol 15)
    (set player.vx (if player.mov.right DASH_VEL player.mov.left (- DASH_VEL)  0))
    (set player.vy (if player.mov.up (- DASH_VEL) player.mov.down DASH_VEL 0))
    (when (and (= player.vx 0) (= player.vy 0)) ; cuando no haya velocidad
      (set player.vx (if player.flippedH (- DASH_VEL) DASH_VEL)))
    (when (and (~= player.vx 0) (~= player.vy 0)) ; triangulo de 45
      (set player.vx (* player.vx 0.7)) ; 0.7 ~ 1/sqrt(2)
      (set player.vy (* player.vy 0.7)))))

(fn collFilter [player object]
  (if (= object.type "spike") nil "slide"))

(fn update [player world dt]
  (when (= player.hascontrol 0)
    (set player.vx (if player.mov.right VELX player.mov.left (- VELX) 0)))
  (when (and (= player.hasdashed 1))
    (set player.vy (if (< player.vy 0) (* VELY -0.25) 0)))

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
    (set player.y actualy)
    (player.particle_system:setPosition (+ actualx (/ player.w 2)) (+ actualy player.h)))

  (let [(items _) (world:queryRect player.x player.y player.w player.h)]
    (each [_ item (ipairs items)]
      (when (= item.type "spike")
        (love.audio.play player.images.death_sound)
        (set player.dead true))))

  (set player.airtime (+ player.airtime 1))
  (when player.colls.down
    (when (> player.airtime 2) (player.particle_system:emit 10))
    (set player.airtime 0)
    (set player.vy 0)
    (set player.hasjumped false)
    (set player.candash true))

  (when (and player.colls.up (= player.hasdashed 0))
    (set player.vy 0))

  (set player.hascontrol (- player.hascontrol
    (if (> player.hascontrol 0) 1 0)))
  (set player.hasdashed (- player.hasdashed
    (if (> player.hasdashed 0) 1 0)))

  (set player.offwall
    (if (and (not player.colls.down)
         (or player.colls.left player.colls.right))
      0 (+ player.offwall 1)))
  (when (and (not player.colls.down) player.colls.left)
    (set player.walldir true))
  (when (and (not player.colls.down) player.colls.right)
    (set player.walldir false))

  (when (= player.hasdashed 0)
    (set player.vy
      (math.min
        (if (= player.offwall 0) 100 300)
        (+ player.vy (* dt
          (if (< (math.abs player.vy) 50) (/ GRAVITY 2) GRAVITY ))))))

  (when (> player.hasdashed 0)
    (player.particle_system:emit 5))

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
    (set player.anim "wall"))

  ;particles an animation
  (player.particle_system:update dt)
  (sprite.update player dt))

(fn newPlayer [x y name]
  (let [
  path (.. "assets/Main Characters/" name "/")

  player {
    ; seria mejor que se llame resources
    :images { :idle (love.graphics.newImage (.. path "Idle (32x32).png"))
              :run (love.graphics.newImage (.. path "Run (32x32).png"))
              :jump (love.graphics.newImage (.. path "Jump (32x32).png"))
              :fall (love.graphics.newImage (.. path "Fall (32x32).png"))
              :wall (love.graphics.newImage (.. path "Wall Jump (32x32).png"))
              :dust (love.graphics.newImage "assets/Other/Dust Particle.png")
              :jump_sound (love.audio.newSource "assets/Sound/jump.wav" "static")
              :dash_sound (love.audio.newSource "assets/Sound/dash.wav" "static")
              :death_sound (love.audio.newSource "assets/Sound/death.wav" "static")}

    ; animaciones mas abajo
    :animations nil

    :anim "idle"
    :flippedH false ; false: right, true: left
    :mov {:up false :down false :left false :right false}
    :w 18 :h 26
    : x : y
    :vx 0 :vy 0
    :colls {:up false :down false :left false :right false}
    :airtime 0
    :hasjumped false
    :candash false
    :hasdashed 0
    :offwall 0
    :walldir false ; false: right, true: left
    :hascontrol 0
    :dead false
    :particle_system nil

  ;; Functions
    : jump
    : dash
    : stopJump
    : update
    : draw
  }]

    ; cargar animaciones
    (set player.animations
      { :idle (animation.new player.images.idle)
        :run (animation.new player.images.run)
        :jump (animation.new player.images.jump)
        :fall (animation.new player.images.fall)
        :wall (animation.new player.images.wall)})

    ; Sistema de particulas
    ; que hermoso es Love2D
    (set player.particle_system (love.graphics.newParticleSystem player.images.dust 50))
    (player.particle_system:setParticleLifetime .3 .5)
    (player.particle_system:setColors [1 1 1 1] [1 1 1 1] [1 1 1 0])
    (player.particle_system:setLinearAcceleration -50 -50 50 50)
    ;(player.particle_system:setSpeed -20)
    (player.particle_system:setRotation 10 20)
    (player.particle_system:setSizes .5)
    (player.particle_system:setEmissionArea "uniform" 10 5)
    player))
