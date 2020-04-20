extends Navigation2D

var offset = Vector2(1.5, 0)

func get_actual_path(from: Vector2, to: Vector2):
	var path = get_simple_path(from - offset, to - offset, false)
	var actual_path = []
	for p in path:
		actual_path.append(p + offset)
	return actual_path

func is_in_nav(pos):
	return get_closest_point(pos) == pos
