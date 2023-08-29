extends Node3D

var eDelta = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.attacked.connect(_on_attack)


func _physics_process(delta):
	eDelta = delta
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("Attack"):
			pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _enter_tree():
	set_multiplayer_authority(name.to_int())
	#if !is_multiplayer_authority():
	#	$"Camera3D".clear_current()
	#else:
	#	$"Camera3D".make_current()
	get_parent().playerAdded(self, is_multiplayer_authority())

@rpc("unreliable", "any_peer", "call_local") func updatePos(id,pos, moving, velo, dest, attacking, speed):
	if !is_multiplayer_authority():
		if name == id:
			#print(velo)
			velo.y=0
			$Player.position = lerp(position, pos, 1)
			$Player.moving = moving;
			$Player.velocity = velo
			$Player.look_at(dest, Vector3.UP)
			$Player.Speed = speed
			#print($Player, " is moving? ", $Player.moving)
			#print(moving)
			$Player.destination = dest
			$Player.attacking = attacking
			$Player.attackMove = false
			var vpPos = $"../../Camera3D".unproject_position(pos)
			vpPos.x -= 160
			vpPos.y -= 220
			#$Player.moving = true
			$Player/FloatGUI.position = vpPos

@rpc("unreliable", "any_peer", "call_local") func ability1(dest):
	if !is_multiplayer_authority():
		$Player._on_ground_ability_1(dest)

@rpc("unreliable", "any_peer", "call_local") func autoAttack(targetName):
		var target = (get_parent().get_node(str(targetName)).get_node("Player"))
		$Player._on_enemy_attacked(target)

func _on_timer_timeout():
	if is_multiplayer_authority():
		rpc("updatePos", name, $Player.position, $Player.moving, $Player.velocity, $Player.destination, $Player.attacking, $Player.Speed)
		
func _on_attack(target):
	pass
	#print(target)
