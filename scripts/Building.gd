extends Burnable
class_name Building

export var max_people_inside = 0
var people_inside = max_people_inside

var grid_pos_buffer = null

func grid_pos(pos: Vector2 = position):
	if pos != position:
		return .grid_pos(pos)
	
	if grid_pos_buffer == null:
		grid_pos_buffer = .grid_pos()
	return grid_pos_buffer


func _to_string():
	return "Building(" + str(people_inside) + "/" + str(max_people_inside) + ")"
