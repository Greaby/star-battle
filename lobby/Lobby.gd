extends Control

const MAX_PLAYERS = 2

onready var port = $Connection/MarginContainer/VBoxContainer/HBoxContainer2/Port
onready var host = $Connection/MarginContainer/VBoxContainer/HBoxContainer2/Host
onready var player_name = $Connection/MarginContainer/VBoxContainer/HBoxContainer3/PlayerName

# Called when the node enters the scene tree for the first time.
func _ready():
    main_state.connect("connection_succeeded", self, "_on_connection_success")
    main_state.connect("player_list_changed", self, "refresh_lobby")

func validate_player_name():
    return $Connection/MarginContainer/VBoxContainer/HBoxContainer3/PlayerName.text != ""

func _on_HostButton_pressed():
    if not validate_player_name():
        return
    
    main_state.host_game(int(port.text), player_name.text)
    display_waiting()
    refresh_lobby()
    
func _on_JoinButton_pressed():
    if not validate_player_name():
        return
        
    main_state.join_game(host.text, int(port.text), player_name.text)

func _on_connection_success():
    display_waiting()

func display_waiting():
    $Connection.hide()
    $Waiting.show()
    
func refresh_lobby():
    var players = main_state.players.values()
    players.sort()
    $Waiting/MarginContainer/VBoxContainer/Players.clear()
    $Waiting/MarginContainer/VBoxContainer/Players.add_item(main_state.player_name + " (You)")
    for p in players:
        $Waiting/MarginContainer/VBoxContainer/Players.add_item(p)

    $Waiting/MarginContainer/VBoxContainer/StartGame.disabled = not get_tree().is_network_server()
    
    
func _on_StartGame_pressed():
    main_state.begin_game()
