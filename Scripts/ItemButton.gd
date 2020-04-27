extends _Button

export(String) var icon_path = ""
export(String) var scene_path = ""
export(int, "Building", "Prop", "SProp", "Tile") var tile_type = 0
export(int) var tile_width = 1

func set_count(c):
	if c == 0:
		$Sprite.self_modulate = Color(1, 1, 1, 0.5)
	else:
		$Sprite.self_modulate = Color(1, 1, 1, 1)
	$Numbers.number = c

func get_count():
	return $Numbers.number

func _ready():
	$Sprite.texture = load(icon_path)

func handle_click():
	$"../../../".set_scene(load(scene_path), tile_type, tile_width, self)
	$"../../../".ignore_click = true
