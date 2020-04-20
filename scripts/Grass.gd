extends Building
tool

export(int, "Normal", "Bushes", "Flowers", "Tree") var type = 0 setget set_type


func _ready():
	nb_state = 2

func set_type(t: int):
	type = t
	$Sprite.frame = t


func inc_state():
	state += 1
	
	$Fire.emitting = true
	
	if (state == 1):
		$Sprite.frame = 4
	if (state >= nb_state):
		$Sprite.frame = 5
		terminated()
	
	$Fire.set_state(state, nb_state)
