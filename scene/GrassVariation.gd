extends Node2D
tool

export(int, "Normal", "Bushes", "Flowers", "Tree") var type = 0 setget set_type

func set_type(t: int):
	type = t
	$Sprite.frame = t
