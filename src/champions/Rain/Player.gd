extends CharacterBody3D

const JUMP_VELOCITY = 4.5
const MAX_SPEED = 50

#stats
var Speed = 5
var MaxHealth = 200

#Ability 1
var Ab1Channel = .4
var A1Cd = 1
var canCastA1 = true
var A1Timer : Timer
var ChannelTimer : Timer
var ability1scn = preload("res://src/champions/Rain/Abilities/ability_1.tscn")
#Auto Attacks
var AttackRange = 5
var AttackSpeed = 1
var attacking = false
var canAttack = true
var attackMove = false
var target
var AAtimer : Timer
var autoAttackscn = preload("res://src/champions/Rain/AutoAttack/auto_attack.tscn")
#movment
var moving = false
var destination = Vector3()
var movment = Vector3()

var channel = false
var mouse = Vector3()
var skillDest = Vector3()
var animator : AnimationPlayer
var floatGUI 

signal attacked(enemy:CharacterBody3D)
@onready var cam = $"../Camera3D"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	AAtimer = $AACD
	AAtimer.timeout.connect(_on_timer_timeout)
	animator = $StylizedCharacter/AnimationPlayer
	A1Timer = $A1CD
	ChannelTimer = $Channel
	var ground = $"../../../Ground"
	ground.move.connect(_on_ground_move)
	ground.ability1.connect(_on_ground_ability_1)
	var enemy = $"../../../Enemy"
	connect("attacked", _on_attacked)
	floatGUI = $FloatGUI/HBoxContainer/Bars/Bar/Count/BackGround/Gauge


func _physics_process(delta):
	if channel:
		return
	animationHandel()
	if(!is_multiplayer_authority()):
		return
	if(!attackMove):
		MovementLoop(delta,1)
	else:
		destination = target.position
		MovementLoop(delta, AttackRange)
	
	HandleGUI_Move()

func animationHandel():
	if moving:
		animator.play("Run")
	elif(!attacking && !channel):
		animator.play("Iddle")

func MovementLoop(_delta, movRange):
		if(moving == false || position.distance_to(destination) < movRange):
			moving = false
			velocity = Vector3.ZERO
			if(attackMove == true || attacking == true):
				_on_enemy_attacked(target)
				get_parent().rpc("autoAttack", target.get_parent().name)
			return
		look_at(destination, Vector3.UP)
		velocity = position.direction_to(destination) * Speed
		move_and_slide()

func HandleGUI_Move():
	var vpPos = $"../Camera3D".unproject_position(position)
	vpPos.x -= 160
	vpPos.y -= 220
	$FloatGUI.position = vpPos

func stop():
	moving = false

func _on_enemy_attacked(target):
	self.target = target
	var pos = target.position
	destination = pos
	attacking = true
	if(position.distance_to(pos) < AttackRange && canAttack):
		look_at(pos, Vector3.UP)
		stop()
		AAtimer.wait_time = AttackSpeed
		AAtimer.start()
		canAttack = false
		animator.play("Punch_R")
		var autoAttack = autoAttackscn.instantiate()
		autoAttack.init(position,target)
		add_sibling(autoAttack)
	elif(canAttack):
		moving = true
		attackMove = true
		destination = pos

func _on_timer_timeout():
	canAttack = true
	AAtimer.stop()

func _on_ground_move(dest):
	if(!is_multiplayer_authority()):
		return
	moving = true;
	destination = dest
	attacking = false
	attackMove = false

func _on_ground_ability_1(dest = mouse):
	destination = dest
	if !canCastA1:
		return
	look_at(dest, Vector3.UP)
	stop()
	A1Timer.wait_time = A1Cd
	A1Timer.start()
	ChannelTimer.wait_time = Ab1Channel
	ChannelTimer.start()
	canCastA1 = false
	channel = true
	skillDest = dest
	animator.play("Kick_R")

func _on_a_1cd_timeout():
	A1Timer.stop()
	canCastA1 = true

func _on_channel_timeout():
	ChannelTimer.stop()
	channel = false
	var ability1 = ability1scn.instantiate()
	ability1.init(skillDest, position, self)
	call_deferred("add_sibling", ability1)

func hit(damage, player, name):
	print(player, " ", name)
	$FloatGUI/HBoxContainer/Bars/Bar/Count/BackGround/Gauge.on_hit(damage)
	if is_multiplayer_authority():
		pass
		$"../../GUI/HBoxContainer/Bars/Bar/Count/BackGround/Gauge".on_hit(damage)
	
func _input(event):
		if Input.is_action_just_pressed("Attack"):
			pass

func _on_input_event(camera, event, position, normal, shape_idx):
	if Input.is_action_just_pressed("Attack"):
		emit_signal("attacked", self)

func _on_attacked(enemy):
	if is_multiplayer_authority():
		_on_enemy_attacked(enemy) # Replace with function body.
