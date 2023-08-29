extends TextureProgressBar

var MaxHealth = 200
var currentHealth = 200
# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = MaxHealth
	value = MaxHealth
	currentHealth = MaxHealth
	$"../Number".text = "%0.0f" %currentHealth


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	value = currentHealth
	if value <= 0:
		currentHealth = MaxHealth
		$"../Number".text = "%0.0f" %currentHealth

func on_hit(dmg):
	currentHealth -= dmg
	$"../Number".text = "%0.0f" %currentHealth
