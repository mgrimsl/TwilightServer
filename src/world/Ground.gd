extends StaticBody3D
signal move(destination:Vector3)
signal ability1(destination:Vector3)
var mouse = Vector3()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("Ability1"):
		pass
		#emit_signal("ability1", mouse)

func _input_event(_camera, event, mPosition, _normal, _shape_idx):
	mPosition.y = 1
	mouse = mPosition
	if event.is_action_pressed("Click"):
		emit_signal("move", mouse)



