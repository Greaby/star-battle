extends "res://player/states/BaseState.gd"

var direction: Vector2

func _init(e).(e):
    e.setAnimation("slide")
    pass
    
func physics_process():
    
    get_inputs()
    
    if not entity.is_on_wall() or entity.get_slide_collision(0).normal.x != -input_direction.x:
        change_state(entity.STATES.SAFE_FALL)
        
    if entity.is_on_floor():
        change_state(entity.STATES.IDLE)
        return
        
    handle_move()

func handle_move():
    entity.velocity.y = min(entity.velocity.y + entity.gravity, entity.max_wall_sliding)
    entity.velocity.x = lerp(entity.velocity.x, input_direction.x * entity.speed, 1 - entity.drag_force)
