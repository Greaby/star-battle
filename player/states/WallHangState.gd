extends "res://player/states/BaseState.gd"

var direction: Vector2

func _init(e).(e):
    e.setAnimation("slide")
    _end_state()
    
func physics_process():
    
    get_inputs()
    
    #if input_direction.y == -1 and detect_ladder:
    #    change_state(entity.STATES.CLIMB)
    
    if not entity.is_on_wall() or entity.get_slide_collision(0).normal.x != -input_direction.x:
        change_state(entity.STATES.SAFE_FALL)
    
    handle_move()

func handle_move():
    entity.velocity.y = 0
    entity.velocity.x = lerp(entity.velocity.x, input_direction.x * entity.speed, 1 - entity.drag_force)
    
func _end_state():
    yield(entity.get_tree().create_timer(.2), "timeout")
    print("slide")
    change_state(entity.STATES.WALL_SLIDING)