extends _Button

export(String) var icon_path = ""
export(String) var scene_path = ""

func _ready():
	$Sprite.texture = load(icon_path)

func handle_click():
	owner.set_scene(load(scene_path))
	owner.ignore_click = true
