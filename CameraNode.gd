extends Node3D

var cameraSpeed = .1
var size = Vector2()
var leftBound
var rightBound
var topBound
var bottomBound

var moving = false
var left = false
var right = false
var up = false
var down = false


# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_viewport().size
	leftBound = size.x * .10
	rightBound = size.x - leftBound
	topBound = size.y * .10
	bottomBound = size.y - topBound



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	moving = false #turns off camera movment
	if(moving == true):
		if(right == true):
			moveRight()
		elif(left == true):
			moveLeft()
		if(up == true):
			moveUp()
		elif(down == true):
			moveDown()

func _input(event):
	if event is InputEventMouseMotion:
		moveCamera(event.position)
	if Input.is_action_just_pressed("ZoomIn"):
		transform.origin.y -= .5
	if Input.is_action_just_pressed("ZoomOut"):
		transform.origin.y += .5
		
func _notification(note):
	match note:
		NOTIFICATION_WM_MOUSE_EXIT:
			stop()
			
func moveCamera(pos):
	stop()
	if pos.x > rightBound:
		moving = true
		right = true
		left = false
	elif pos.x < leftBound:
		moving = true
		left = true
		right = false
	if pos.y < topBound:
		moving = true
		up = true
		down = false
	elif pos.y > bottomBound:
		moving = true
		down = true
		up = false
func stop():
	moving = false;
	up = false
	down = false
	right = false
	left = false
func moveLeft():
	transform.origin.x -= cameraSpeed
func moveRight():
	transform.origin.x += cameraSpeed
func moveUp():
	transform.origin.z -= cameraSpeed
func moveDown():
	transform.origin.z += cameraSpeed
