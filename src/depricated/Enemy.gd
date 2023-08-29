extends CharacterBody3D


const SPEED = 30.0
const JUMP_VELOCITY = 4.5
signal attacked(enemy:CharacterBody3D)
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var ability1scn = preload("res://src/champions/Rain/Abilities/ability_1.tscn")

func _ready():
	$Timer.start()

func hit(damage):
	$FloatGUI/HBoxContainer/Bars/Bar/Count/BackGround/Gauge.on_hit(damage)


func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	var vpPos = $"../Camera3D".unproject_position(position)
	vpPos.x -= 90
	vpPos.y -= 75

	$FloatGUI.position = vpPos
	move_and_slide()
	
func _input_event(_camera, _event, _click_position, _click_normal, _shape_idx):
	if Input.is_action_just_pressed("Attack"):
		emit_signal("attacked",self)
		
func _on_ground_ability_1():
	var ability1 = ability1scn.instantiate()
	ability1.init($"../Player".position, position, self)
	add_sibling(ability1)
		



func _on_timer_timeout():
	pass
	#_on_ground_ability_1()
