extends KinematicBody2D

const UP = Vector2(0, -1)

enum STATES {IDLE, WALK, RUN, JUMP, DOUBLE_JUMP, FALL, SAFE_FALL, CROUCH, CRAWL, DASH, CLIMB, HURT}
var stateObject
var states = {
    STATES.IDLE: preload("res://player/states/IdleState.gd"),
    STATES.WALK: preload("res://player/states/WalkState.gd"),
    STATES.RUN: preload("res://player/states/RunState.gd"),
    STATES.JUMP: preload("res://player/states/JumpState.gd"),
    STATES.DOUBLE_JUMP: preload("res://player/states/DoubleJumpState.gd"),
    STATES.FALL: preload("res://player/states/FallState.gd"),
    STATES.SAFE_FALL: preload("res://player/states/SafeFallState.gd"),
    STATES.CROUCH: preload("res://player/states/CrouchState.gd"),
    STATES.CRAWL: preload("res://player/states/CrawlState.gd"),
    STATES.DASH: preload("res://player/states/DashState.gd"),
    STATES.CLIMB: preload("res://player/states/ClimbState.gd"),
    STATES.HURT: preload("res://player/states/HurtState.gd")
}

var velocity: Vector2 = Vector2()
var flip: bool = false

var invinsible = false

var points = 0

var camera

export(int) var crawl_speed: int = 70
export(int) var speed: int = 150
export(int) var run_speed: int = 300
export(int) var dash_speed: int = 1000
export(int) var climb_speed: int = 70
export(int) var jump_impulse: int = 200
export(int) var hurt_inpulse: int = 150
export(int) var jump_force: int = 5
export(int) var gravity: int = 10
export(float, 0, 1, .01) var drag_force: float = .9

slave var slave_pos = Vector2()
slave var slave_velocity = Vector2()
slave var slave_flip: bool = false

func _ready() -> void:
    change_state(STATES.IDLE)
    get_tree().create_timer(0.1)
    
func _process(delta):
    if is_network_master():
        for arrow in camera.find_node("Path2D").get_children():
            arrow.queue_free()
        
        var coins = get_parent().get_parent().find_node("Coins")
        for coin in coins.get_children():
            if not coin.find_node("Visibility").is_on_screen():
                var arrow = load("res://player/Arrow.tscn").instance()
                var coin_vector = position - coin.position
                arrow.find_node("Sprite").rotation = coin_vector.angle()
                var offset = (coin_vector.angle() + PI) / (PI * 2)
                
                camera.find_node("Path2D").add_child(arrow)
                arrow.unit_offset = offset
    
func _physics_process(delta) -> void:
    
    if is_network_master():
        stateObject.physics_process()
        velocity = move_and_slide(velocity, UP)
        rset("slave_velocity", velocity)
        rset("slave_pos", position)
        rset("slave_flip", flip)
    else:
        velocity = slave_velocity
        position = slave_pos
        flip = slave_flip
        
    $AnimatedSprite.flip_h = flip
    

remote func change_state(new_state) -> void:
    if is_network_master():
        rpc("change_state", new_state)
    stateObject = states[new_state].new($".")

func setAnimation(name: String) -> void:
    $AnimatedSprite.play(name)
    
func setCollision(extents: Vector2 = Vector2(10, 14), position: Vector2 = Vector2()):
    $CollisionShape2D.shape.extents = extents
    $CollisionShape2D.position = position
    
remote func add_point():
    points += 1
    $Points.text = str(points)
    
func remove_point():
    if points == 0:
        return

    points -= 1
    $Points.text = str(points)
    drop_coin()
    
func drop_coin():
    find_parent("Main").drop_coin(position, Vector2(50 * int(flip), -100))

func _on_Attack_body_entered(body):
    if body == $"." or body.invinsible:
        return
    
    if body.is_network_master():
        body.change_state(STATES.HURT)
    
