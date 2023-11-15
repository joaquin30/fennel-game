(local animation (require "utils.animation"))
(local sprite (require "utils.sprite"))

(local path "assets/Main Characters/Ninja Frog/")

(local images {
    "idle"  (love.graphics.newImage (.. path "Idle (32x32).png"))
    "run"   (love.graphics.newImage (.. path "Run (32x32).png"))
    "jump"  (love.graphics.newImage (.. path "Jump (32x32).png"))
    "fall"  (love.graphics.newImage (.. path "Fall (32x32).png"))
})

(local animations {
    "idle"  (animation.new (. images "idle"))
    "run"   (animation.new (. images "run"))
    "jump"  (animation.new (. images "jump"))
    "fall"  (animation.new (. images "fall"))
})

{
    : images
    : animations
    :anim "idle"
    :flippedH false :flippedV false
    :x 48 :y 48 :vx 0 :vy 0
    :w 32 :h 32
    :onfloor false
}