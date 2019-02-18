extends "res://player/states/BaseState.gd"

func _init(e).(e):
    e.setAnimation("jump")
    e.velocity.y = -e.jump_impulse
    
func physics_process():
    get_inputs()
    
    if dash_pressed:
        change_state(entity.STATES.DASH)
        return
    
    if entity.velocity.y > 0:
        change_state(entity.STATES.SAFE_FALL)
        return
        
    if jump_just_pressed:
        change_state(entity.STATES.DOUBLE_JUMP)
        return

    handle_move()
     
func handle_move():
    entity.velocity.y += entity.gravity
    if jump_pressed:
        entity.velocity.y -= entity.jump_force
    
    
    entity.velocity.x = lerp(entity.velocity.x, input_direction.x * entity.speed, 1 - entity.drag_force)
    
    if input_direction.x != 0:
        entity.flip =  input_direction.x < 0
