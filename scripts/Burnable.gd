extends Node2D
class_name Burnable

var pixel_scale = 3

onready var buildings = $"../../Buildings"
onready var entities = $"../../Entities"

export var max_heat_transmitted = 3
export var max_heat_resist = 20

export var time_alive_on_fire = 0
var time_remaining = time_alive_on_fire

export var can_be_on_fire = true

export var current_heat = 0
var added_heat = 0
export var on_fire = false

var state setget set_state

func _ready():
	set_z()

func grid_pos():
	var y = position.y / (12 * pixel_scale)
	var x = (position.x + y * 18) / (16 * pixel_scale)
	return Vector2(x, y)

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
	
	var c = current_heat / max_heat_resist
	modulate = Color(1, 1 - 0.6 * c, 1 - 0.6 * c, 1)

func set_state(state: int):
	state = state
	$Sprite.frame = state

func transfer_heat():
	var heat_to_transfer = current_heat
	if (heat_to_transfer >= max_heat_transmitted):
		heat_to_transfer = max_heat_transmitted
	
	for x in range(-1, 2):
		for y in range(-1, 2):
			if x != 0 or y != 0:
				var building_next_to = buildings.get_building_at(grid_pos() + Vector2(x,y))
				if building_next_to != null:
					building_next_to.add_heat(heat_to_transfer)
					
				var entities_next_to = entities.get_entities_at(grid_pos() + Vector2(x,y))
				if entities_next_to != null:
					for entity in entities_next_to:
						entity.heat_up(heat_to_transfer)

func set_on_fire():
	if can_be_on_fire:
		on_fire = true
		state += 1
