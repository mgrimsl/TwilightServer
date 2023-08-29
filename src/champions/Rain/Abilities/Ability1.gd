
extends Area3D

var damage = 20 

var dest = Vector3()
var velocity = Vector3.ZERO
var start = Vector3()
var constantTravel = true
var travelDistance = 7
var speed = .3
var own
var active = true
@onready var timer : Timer = $DebuffTimer
var target
signal hit(target: CharacterBody3D)

func init(mouse, pos, player):
	own = player
	start = Vector3(pos.x,1,pos.z) 
	dest = mouse
	start += start.direction_to(dest) * 1.2
	transform.origin = start
		
func _physics_process(_delta):
	if(constantTravel == true):
		fixedTravel()
	else:
		travel()

func fixedTravel():
	if(position.distance_to(start) > travelDistance && active ):
		$MeshInstance3D.call_deferred("queue_free")
		$CollisionShape3D.call_deferred("queue_free")
		active = false
		return
	velocity = start.direction_to(dest) * speed
	transform.origin += velocity

func travel():
	if(position.distance_to(dest) < 1  && active):
		$MeshInstance3D.call_deferred("queue_free")
		$CollisionShape3D.call_deferred("queue_free")
		active = false
		return
	velocity = position.direction_to(dest) * speed
	transform.origin += velocity

func _on_body_entered(body : CharacterBody3D):
	if body != own && active:
		body.hit(damage, get_parent(), name)
		$MeshInstance3D.call_deferred("queue_free")
		$CollisionShape3D.call_deferred("queue_free")
		timer.wait_time = 2
		target = body
		body.Speed = body.Speed *.20 
		timer.start()
		timer.timeout.connect(end)
		active = false
func test():
	print("hi")
func end():
	target.Speed = target.Speed / .20
	print("lol")
	timer.stop()
	call_deferred("queue_free")
	

