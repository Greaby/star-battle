extends Node2D

func _ready():
    randomize()
    var positions = $spawners.get_children()
    for p_id in main_state.spawn_points:
        add_player(p_id, positions.pop_front().position)
        
    if is_network_master():
        spawn_coin(true)
        
func _process(delta):
    if is_network_master():
        for player in $Players.get_children():
            print(player.points)
            if player.points == 6:
                main_state.end_game(player.find_node("Label").text)
        
func add_player(id: int, start_position: Vector2):
    var player = load("res://player/Player.tscn").instance()
    player.set_name(str(id)) # Use unique ID as node name
    player.position = start_position
    $Players.add_child(player)
    player.set_network_master(id)
    
    if id == get_tree().get_network_unique_id():
        player.find_node("Label").text = main_state.player_name
        
        var camera = load("res://player/Camera2D.tscn").instance()
        player.add_child(camera)
        player.camera = camera
    else:
        player.find_node("Label").text = main_state.players[id]
        
remote func spawn_coin(sleeping = false, spawn_position = null):
    if not spawn_position:
        spawn_position = $CoinsPositions.get_children()[randi() % $CoinsPositions.get_child_count()].position
        
    var coin = load("res://coin/Coin.tscn").instance()
    coin.position = spawn_position
    coin.sleeping = sleeping
    if not sleeping:
        pass
    $Coins.add_child(coin)
    
    if is_network_master():
        coin.connect("tree_exited", self, "start_timer")
        rpc("spawn_coin", sleeping, spawn_position)

func start_timer():
    $CoinTimer.start()

func _on_CoinTimer_timeout():
    spawn_coin(true)
