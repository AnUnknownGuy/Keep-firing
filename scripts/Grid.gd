extends Node2D


onready var humans = $"../../Humans"

var entities_dictionnary = {}

func get_building_at(pos: Vector2):
	for b in get_children():
		if (b.grid_pos() == pos):
			return b
	return null

func get_entitites_at(pos: Vector2):
	for h in humans.get_children():
		if (h.grid_pos() == block.grid_pos() && b != block):
			return b
	return null

func heat_at(pos: Vector2, heat: int):
	
