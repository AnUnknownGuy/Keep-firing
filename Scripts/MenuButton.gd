extends _Button

export(String) var show_node_path = ""
export(String) var show_scene_path = ""

func handle_click():
	if len(show_node_path) > 0:
		get_parent().hide()
		get_node(show_node_path).show()
	elif len(show_scene_path) > 0:
		get_tree().change_scene(show_scene_path)
		get_tree().paused = false
