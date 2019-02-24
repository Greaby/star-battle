extends "res://player/states/BaseState.gd"

var direction: Vector2

func _init(e).(e):
    entity.invinsible = true
    entity.find_node("Attack").monitoring = true
    entity.setAnimation("dash")
    entity.find_node("Particles2D").emitting = true
    
    direction = get_input_direction()
    if not direction:
        direction.x = -1 if entity.find_node("AnimatedSprite").flip_h else 1
    
    if entity.is_on_floor():
        direction.y = 0

    entity.find_node("Sprite").rotation = direction.normalized().rotated(PI).angle()
    entity.find_node("AnimationPlayer").play("slash")
    
    if entity.is_network_master():
        entity.camera.find_node("AnimationPlayer").play("shake")
    
    _end_dash()
    
func physics_process():
    handle_move()

func handle_move():
    entity.velocity = entity.dash_speed * direction.normalized()
    
func _end_dash():
    yield(entity.get_tree().create_timer(.2), "timeout")
    entity.invinsible = false
    entity.find_node("Attack").monitoring = false

    entity.velocity.y = max(entity.velocity.y, -entity.jump_impulse)
    entity.velocity.x = clamp(entity.velocity.x, -entity.run_speed, entity.run_speed)
    entity.find_node("Particles2D").emitting = false
    change_state(entity.STATES.FALL)