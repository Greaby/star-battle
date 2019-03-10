extends "res://player/states/BaseState.gd"

func _init(e).(e):
    e.setAnimation("fall")
    
func physics_process():
    get_inputs()
    
    if input_direction.y == -1 and detect_ladder:
        change_state(entity.STATES.CLIMB)
    
    if entity.is_on_floor():
        change_state(entity.STATES.IDLE)
        return
    
    if jump_just_pressed:
        change_state(entity.STATES.DOUBLE_JUMP)
        return
        
    if dash_pressed:
        change_state(entity.STATES.DASH)
        return
        
    if entity.is_on_wall() and entity.get_slide_collision(0).normal.x == -input_direction.x:
        change_state(entity.STATES.WALL_HANG)

    handle_move()
    
func handle_move():
    entity.velocity.y += entity.gravity
    entity.velocity.x = lerp(entity.velocity.x, input_direction.x * entity.speed, 1 - entity.drag_force)
    
    if input_direction.x != 0:
        entity.flip =  input_direction.x < 0
