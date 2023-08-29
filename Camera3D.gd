extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready():
	clear_current();
	global_position.x = 1
	global_position.y = 12
	global_position.z = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
