extends Node2D
class_name Burnable

var pixel_scale = 3

onready var buildings = $"../../Buildings"
onready var entities = $"../../Entities"

export var max_heat_transmitted = 3
export var max_heat_resist = 20

export var time_alive_on_fire = 0
var time_remaining = 0

export var can_be_on_fire = true

export var current_heat = 0
var added_heat = 0
export var on_fire = false

var state = 0
var nb_state = 2

func _ready():
	set_z()
	time_remaining = time_alive_on_fire
	#if $Sprite != null:
		#nb_state = $Sprite.vframes * $Sprite.hframes

func grid_pos():
	var y = position.y / (12 * pixel_scale)
	var x = (position.x + y * 18) / (16 * pixel_scale)
	return Vector2(x, y)

func set_z():
	var pos = grid_pos()
	var fx = floor(pos.x)
	var fy = floor(pos.y)
	z_index = fx + 0.8 * fy + 0.2 * (pos.y)

func add_heat(heat: float):
	added_heat += heat

func set_new_heat():
	
	if on_fire && can_be_on_fire:
		time_remaining -= added_heat
		print(time_remaining)
		print(added_heat)
		if time_remaining < 0:
			time_remaining = time_alive_on_fire
			inc_state()
			
	elif not on_fire && can_be_on_fire:
		
		if (can_be_on_fire && added_heat != 0):
			current_heat += added_heat
			var c = current_heat / max_heat_resist
			modulate = Color(1, 1 - 0.6 * c, 1 - 0.6 * c, 1)
		
		if (current_heat > max_heat_resist):
			if (not on_fire):
				set_on_fire()
			current_heat = max_heat_resist
		
		
	added_heat = 0

func set_on_fire():
	if can_be_on_fire:
		on_fire = true
		inc_state()

func inc_state():
	print(state)
	print(nb_state)
	state += 1
	if (state < nb_state):
		#$Sprite.frame = state
		pass
		
	elif (state == nb_state):
		#$Sprite.frame = state
		terminated()
	elif (state > nb_state):
		terminated()

func terminated():
		modulate = Color(0.4, 0.4, 0.4, 1)
		on_fire = false
		can_be_on_fire = false
		current_heat = 0

func transfer_heat():
	var heat_to_transfer = current_heat
	if (heat_to_transfer >= max_heat_transmitted):
		heat_to_transfer = max_heat_transmitted
	
	for x in range(-1, 2):
		for y in range(-1, 2):
			var building_next_to = buildings.get_building_at(grid_pos() + Vector2(x,y))
			if building_next_to != null:
				building_next_to.add_heat(heat_to_transfer)
				print(Vector2(x,y))
					
			var entities_next_to = entities.get_entities_at(grid_pos() + Vector2(x,y))
			if entities_next_to != null:
				for entity in entities_next_to:
					entity.heat_up(heat_to_transfer)

