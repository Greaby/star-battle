extends "res://player/states/BaseState.gd"

func _init(e).(e):
    e.setAnimation("crouch")
    
func physics_process():
    get_inputs()
    
    if jump_just_pressed and entity.is_on_floor():
        change_state(entity.STATES.JUMP)
        return
        
    if input_direction.y != 1:
        change_state(entity.STATES.IDLE)
        
    if input_direction.x:
        change_state(entity.STATES.CRAWL)
        return

    handle_move()
    
func handle_move():
    entity.velocity.y += entity.gravity
    entity.velocity.x = 0