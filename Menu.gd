extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene : PackedScene
@onready var cam = $Camera2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_host_pressed():
	#get_tree().change_scene_to_file("res://MainScene.tscn")
	peer.create_server(123)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	add_player()
	cam.enabled = false

func _on_join_pressed():
	#et_tree().change_scene_to_file("res://MainScene.tscn")
	peer.create_client("127.0.0.1",123)
	multiplayer.multiplayer.peer = peer
	cam.enabled = false
	
func add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	
func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)
	
func del_player(id):
	rpc("_del_player", id)

@rpc("any_peer", "call_local") func _del_player(id):
	get_node(str(id)).queue_free()
