extends Node2D

var buildings_dictionnary = {}

func _ready():
	for b in get_children():
		declare(b)
		b.post_init()

func get_random_building(ignore = null):
	var choices = []
	for b in buildings_dictionnary.values():
		if b.max_people_inside > 0 and b.grid_pos() != ignore and b.exit_pos() != null:
			choices.append(b)
	if (choices.size() == 0):
		return null
	else:
		return choices[int(floor(randf() * choices.size()))]

func remove(building: Building):
	for x in range(0, building.width):
		for y in range(0, building.height):
			buildings_dictionnary.erase(building.grid_pos() + Vector2(x, y))
			
		

func get_random_building_on_fire():
	var choices = []
	for b in buildings_dictionnary.values():
		if b.max_people_inside > 0 and b.exit_pos() != null and b.on_fire:
			choices.append(b)
	if (choices.size() == 0):
		return null
	else:
		return choices[int(floor(randf() * choices.size()))]

func has_building_on_fire():
	for b in buildings_dictionnary.values():
		if b.max_people_inside > 0 and b.exit_pos() != null and b.on_fire:
			return true
	return false

func declare(building: Building):
	for x in range(0, building.width):
		for y in range(0, building.height):
			buildings_dictionnary[building.grid_pos() + Vector2(x, y)] = building

func has_building_at(pos: Vector2) -> bool:
	return get_building_at(pos) != null
	
func get_building_at(pos: Vector2) -> Building:
	return buildings_dictionnary.get(pos)

func add_heat_at(pos: Vector2, heat: int):
	var building = get_building_at(pos)
	if (building != null):
		building.heat_up(heat)
