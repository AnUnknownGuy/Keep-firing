extends Node2D

onready var entitites = $"../../Entities"

var buildings_dictionnary = {}

func _ready():
	for b in get_children():
		declare(b)

func declare(building: Building):
	buildings_dictionnary[building.grid_pos()] = building

func get_building_at(pos: Vector2) -> Building:
	return buildings_dictionnary.get(pos)

func add_heat_at(pos: Vector2, heat: int):
	var building = get_building_at(pos)
	if (building != null):
		building.heat_up(heat)
