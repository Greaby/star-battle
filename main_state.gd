extends Node

signal connection_succeeded
signal player_list_changed

const MAX_PLAYERS = 8

var player_name

var players = {}
var spawn_points = []

func _ready():
    get_tree().connect("network_peer_connected", self, "_player_connected")
    get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
    get_tree().connect("connected_to_server", self, "_connected_ok")
    get_tree().connect("connection_failed", self, "_connected_fail")
    get_tree().connect("server_disconnected", self, "_server_disconnected")

func host_game(port: int, _player_name: String):
    player_name = _player_name
    var peer = NetworkedMultiplayerENet.new()
    peer.create_server(port, MAX_PLAYERS)
    get_tree().set_network_peer(peer)
    
func join_game(host: String, port: int, _player_name: String):
    player_name = _player_name
    var peer = NetworkedMultiplayerENet.new()
    peer.create_client(host, port)
    get_tree().set_network_peer(peer)
    
func _player_connected():
    pass
    
func _player_disconnected():
    pass
    
func _connected_ok():
    rpc("register_player", get_tree().get_network_unique_id(), player_name)
    emit_signal("connection_succeeded")

func _connected_fail():
    get_tree().set_network_peer(null)

func _server_disconnected():
    pass
    
remote func register_player(id, new_player_name):
    if get_tree().is_network_server():
        # If we are the server, let everyone know about the new player
        rpc_id(id, "register_player", 1, player_name) # Send myself to new dude
        for p_id in players: # Then, for each remote player
            rpc_id(id, "register_player", p_id, players[p_id]) # Send player to new dude
            rpc_id(p_id, "register_player", id, new_player_name) # Send new dude to player

    players[id] = new_player_name
    emit_signal("player_list_changed")

func begin_game():
    var player_ids = [1] + players.keys()
    
    for p in players:
        rpc_id(p, "pre_start_game", player_ids)

    pre_start_game(player_ids)
    
remote func pre_start_game(player_ids):
    spawn_points = player_ids
    print(get_tree().get_network_unique_id())
    get_tree().change_scene("res://main.tscn")
    
    

    
        

