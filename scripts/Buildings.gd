extends Node2D


onready var entitites = $"../../Entities"

var buildings_dictionnary = {}


func declare_at_pos(building: Building, pos: Vector2):
	buildings_dictionnary[pos] = building

func get_building_at(pos: Vector2) -> Building:
	return buildings_dictionnary[pos]

func add_heat_at(pos: Vector2, heat: int):
	var building = get_building_at(pos)
	if (building != null):
		building.heat_up(heat)
