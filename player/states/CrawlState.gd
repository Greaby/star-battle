extends "res://player/states/BaseState.gd"

func _init(e).(e):
    e.setAnimation("crawl")
    e.setCollision(Vector2(16, 9), Vector2(0, 5))
    
func physics_process():
    get_inputs()
    
    if jump_just_pressed and entity.is_on_floor():
        change_state(entity.STATES.JUMP)
        return
    
    if not input_direction.x:
        change_state(entity.STATES.CROUCH)
        return
        
    if input_direction.y != 1:
        change_state(entity.STATES.WALK)
        
    if entity.velocity.y > 0:
        change_state(entity.STATES.SAFE_FALL)
        return

    handle_move()
    
func handle_move():
    entity.velocity.y += entity.gravity
    entity.velocity.x = lerp(entity.velocity.x, input_direction.x * entity.crawl_speed, 1 - entity.drag_force)
    
    entity.flip = input_direction.x < 0