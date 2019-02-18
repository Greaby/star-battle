extends "res://player/states/BaseState.gd"

func _init(e).(e):
    e.setAnimation("walk")
    
func physics_process():
    if not entity.is_network_master():
        return
        
    get_inputs()
    
    if input_direction.y == -1 and detect_ladder:
        change_state(entity.STATES.CLIMB)
        return
    
    if dash_pressed:
        change_state(entity.STATES.DASH)
        return
    
    if jump_just_pressed and entity.is_on_floor():
        change_state(entity.STATES.JUMP)
        return
    
    if not input_direction.x:
        change_state(entity.STATES.IDLE)
        return
        
    if input_run:
        change_state(entity.STATES.RUN)
        return
        
    if input_direction.y > 0:
        change_state(entity.STATES.CROUCH)
        return
        
    if entity.velocity.y > 0:
        change_state(entity.STATES.SAFE_FALL)
        return
    
    handle_move()
    
func handle_move():
    entity.velocity.y += entity.gravity
    entity.velocity.x = lerp(entity.velocity.x, input_direction.x * entity.speed, 1 - entity.drag_force)
    
    entity.flip = input_direction.x < 0