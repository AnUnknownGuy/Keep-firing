extends Node2D
class_name Burnable


onready var buildings = $"../../Buildings"
onready var entities = $"../../Entities"

export var max_heat_transmitted = 0
export var max_heat_resist = 0

export var time_alive_on_fire = 0
var time_remaining = time_alive_on_fire

var current_heat = 0
var added_heat = 0
var on_fire = false

var nb_states = 1

func _ready():
	set_z()

func grid_pos():
	return (position/64).floor()

func set_z():
	z_index = position.y

func add_heat(heat: float):
	added_heat += heat

func set_new_heat():
	current_heat += added_heat
	if (current_heat > max_heat_resist):
		set_on_fire()
		current_heat = max_heat_resist
	added_heat = 0

func transfert_heat():
	var heat_to_transfer = current_heat
	if (heat_to_transfer >= max_heat_transmitted):
		heat_to_transfer = max_heat_transmitted
		
	for x in range(-1, 1):
		for y in range(-1, 1):
			if (x != y || (x == 0 && y ==0)):
				var building_next_to = buildings.get_building_at(position + Vector2(x,y))
				if (building_next_to != null):
					building_next_to.add_heat(heat_to_transfer)
				var entities_next_to = entities.get_entities_at(position + Vector2(x,y))
				
				for entity in entities_next_to:
					entity.heat_up(heat_to_transfer)

func set_on_fire():
	push_warning("function set_on_fire not overrided");
	pass
