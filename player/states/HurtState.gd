extends "res://player/states/BaseState.gd"

var hurt_direction: int

func _init(e).(e):
    e.invinsible = true
    e.remove_point()
    e.setAnimation("hurt")
    
    e.velocity.y = -e.hurt_inpulse
    
    hurt_direction = -1 if e.find_node("AnimatedSprite").flip_h else 1
    if e.is_network_master():
        e.camera.find_node("AnimationPlayer").play("shake")
    
    _end_state()
    
func physics_process():
    handle_move()

func handle_move():
    entity.velocity.x = 60 * hurt_direction
    entity.velocity.y += entity.gravity
    
func _end_state():
    yield(entity.get_tree().create_timer(.5), "timeout")
    entity.invinsible = false
    change_state(entity.STATES.IDLE)