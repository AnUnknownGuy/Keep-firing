extends "res://Scripts/Buildings.gd"

func has_building_at(pos: Vector2) -> bool:
	return get_building_at(pos) != null


func add_prop(prop: Prop) -> int:
	
	if not has_building_at(prop.grid_pos()):
		buildings_dictionnary[prop.grid_pos()] = prop
		return prop.cost
	
	else:
		return 0
