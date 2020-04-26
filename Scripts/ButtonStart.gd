extends _Button

onready var level = $"../../"

func handle_click():
	visible = false
	level.start()
