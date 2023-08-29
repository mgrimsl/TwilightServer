extends Node3D
var players = []
var authMod
var authRPC 
var authJoined = false
var lbFillRed = preload("res://assets/GUI/lifebar_fill_Red.png")
var lbBGRed = preload("res://assets/GUI/lifebar_bg_Red.png")
func playerAdded(player, isAuth):
	#print("new player added: ", player.name, " is auth?: ", isAuth)
	var playerMod = player.get_node("Player")
	print(player)
	if !isAuth:
		players.append(player.name)
		var floatGUI = player.get_node("Player/FloatGUI/HBoxContainer/Bars/Bar/Count/BackGround/Gauge")
		floatGUI.texture_progress = lbFillRed
		floatGUI.texture_under = lbBGRed
	else:
		authRPC = player
		authMod = playerMod
		authJoined = true
	playerMod.attacked.connect(_on_player_attacked)


func _on_player_attacked(target):
	#print("auth on attk: ",authMod.name)
	#authMod._on_enemy_attacked(target.position)
	#print(target.position)
	authMod._on_enemy_attacked(target)
	authRPC.rpc_id(get_multiplayer_authority(), "autoAttack", target.get_parent().name)

func _physics_process(delta):
	if !authJoined:
		return
	authMod.mouse = $"../Ground".mouse
	if Input.is_action_just_pressed("Ability1"):
			authRPC.rpc("ability1", authMod.mouse)
			authMod._on_ground_ability_1()
	
