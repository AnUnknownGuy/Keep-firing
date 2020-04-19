extends Node2D

var buildings_dictionnary = {}

func _ready():
	for b in get_children():
		declare(b)
		b.post_init()

func get_random_building(ignore = null):
	var choices = []
	for b in buildings_dictionnary.values():
		if b.max_people_inside > 0 and b.grid_pos() != ignore:
			choices.append(b)

	return choices[floor(randf() * choices.size())]

func declare(building: Building):
	buildings_dictionnary[building.grid_pos()] = building

func get_building_at(pos: Vector2) -> Building:
	return buildings_dictionnary.get(pos)

func add_heat_at(pos: Vector2, heat: int):
	var building = get_building_at(pos)
	if (building != null):
		building.heat_up(heat)
