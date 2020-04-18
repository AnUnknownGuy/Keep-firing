extends Navigation2D

var offset = Vector2(3, 0)

func get_actual_path(from: Vector2, to: Vector2):
	var path = get_simple_path(from + offset, to + offset, false)
	var actual_path = []
	for p in path:
		actual_path.append(p - offset)
	return actual_path
