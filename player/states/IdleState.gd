extends "res://player/states/BaseState.gd"

func _init(e).(e):
    e.setAnimation("idle")
    
func physics_process():
    get_inputs()
    
    if input_direction.y == -1 and detect_ladder:
        change_state(entity.STATES.CLIMB)
    
    if jump_just_pressed and entity.is_on_floor():
        change_state(entity.STATES.JUMP)
        return
    
    if input_direction.x:
        change_state(entity.STATES.WALK)
        return
        
    if entity.velocity.y > 0:
        change_state(entity.STATES.SAFE_FALL)
        return
        
    if input_direction.y == 1:
        change_state(entity.STATES.CROUCH)

    handle_move()

func handle_move():
    entity.velocity.y += entity.gravity
    entity.velocity.x = lerp(entity.velocity.x, 0, 1 - entity.drag_force)