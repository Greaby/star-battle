var entity

var input_direction: Vector2 = Vector2()
var input_run: bool
var jump_just_pressed: bool
var jump_pressed: bool
var dash_pressed: bool
var detect_ladder: bool

func _init(e):
    entity = e
    entity.setCollision() # default

func get_inputs():
    input_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
    input_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
    input_run = Input.is_action_pressed("run")
    jump_just_pressed = Input.is_action_just_pressed("jump")
    jump_pressed = Input.is_action_pressed("jump")
    dash_pressed = Input.is_action_just_pressed("dash")
    
    detect_ladder = false
    var areas = entity.find_node("Detection").get_overlapping_areas()
    
    for area in areas:
        if(area.is_in_group("ladder")):
            detect_ladder = true

func get_input_direction() -> Vector2:
    var input_direction = Vector2()
    input_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
    input_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
    return input_direction
    
func change_state(state):
    if entity.is_network_master():
        entity.change_state(state)