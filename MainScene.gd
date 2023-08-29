extends Node3D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene
@onready var cam = $Camera3D
# Called when the node enters the scene tree for the first time.
func _ready():
	peer.create_server(8080)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)

func _on_host_pressed():
	peer.create_server(8080)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	#add_player(1)
	#cam.clear_current()

func _on_join_pressed():
	#peer.create_client("20.172.229.169",8080)
	peer.create_client("localhost",8080)
	#peer.create_client("192.168.1.68",123)
	multiplayer.multiplayer_peer = peer
	#cam.clear_current()

func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	$PlayersMan.add_child(player)



func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc("_del_player", id)

@rpc("any_peer", "call_local") func _del_player(id):
	get_node(str(id)).queue_free()

