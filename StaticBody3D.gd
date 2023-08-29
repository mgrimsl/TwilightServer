extends StaticBody3D
var mouse = Vector3()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input_event(camera, event, position, normal, shape_idx):
	position.y = 1
	mouse = position
	if event.is_action_pressed("Click"):
		#$"../CharacterBody3D".moving = true
		$"../CharacterBody3D".destination = position



