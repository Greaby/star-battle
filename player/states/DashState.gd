extends "res://player/states/BaseState.gd"

var last_velocity: Vector2
var dash_direction: int

func _init(e).(e):
    e.invinsible = true
    e.find_node("Attack").monitoring = true
    e.setAnimation("dash")
    last_velocity = e.velocity
    e.find_node("Particles2D").emitting = true
    
    dash_direction = -1 if e.find_node("AnimatedSprite").flip_h else 1
    var rotation = -e.velocity
    rotation.x = entity.dash_speed * -dash_direction
    
    e.find_node("Sprite").rotation = rotation.angle()
    e.find_node("AnimationPlayer").play("slash")
    
    if e.is_network_master():
        e.camera.find_node("AnimationPlayer").play("shake")
    
    _end_dash()
    
func physics_process():
    handle_move()

func handle_move():
    entity.velocity.x = entity.dash_speed * dash_direction
    
func _end_dash():
    yield(entity.get_tree().create_timer(.2), "timeout")
    entity.invinsible = false
    entity.find_node("Attack").monitoring = false
    entity.velocity = last_velocity
    entity.find_node("Particles2D").emitting = false
    change_state(entity.STATES.FALL)