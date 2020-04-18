extends Building
tool

export(int, "Normal", "Bushes", "Flowers", "Tree") var type = 0 setget set_type

func set_type(t: int):
	type = t
	$Sprite.frame = t


func inc_state():
	state += 1
	if (current_heat >= max_heat_resist):
		terminated()
