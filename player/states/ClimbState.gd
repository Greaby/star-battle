extends "res://player/states/BaseState.gd"

func _init(e).(e):
    e.setAnimation("climb")
    
func physics_process():
    get_inputs()

    if input_direction.y != -1 or not detect_ladder:
        change_state(entity.STATES.IDLE)

    handle_move()
    
func handle_move():
    entity.velocity.y = -entity.climb_speed
    entity.velocity.x = 0