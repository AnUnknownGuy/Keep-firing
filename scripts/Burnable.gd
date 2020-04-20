extends Node2D
class_name Burnable

var buildings
var entities
var props

export var max_heat_transmitted: int = 3
export var max_heat_resist: float = 20

export var time_alive_on_fire: int = 0
var time_remaining: int = 0

export var can_be_on_fire: bool = true

export var current_heat: float = 0
var added_heat: int = 0
var cooling: int = 0
export var on_fire = false

var state: int = 0
var nb_state: int = 2

export var height = 1
export var width = 1


func _ready():
	time_remaining = time_alive_on_fire
	if has_node("Sprite"):
		nb_state = $Sprite.vframes * $Sprite.hframes -1
	if nb_state < 1: nb_state = 2
	if on_fire: set_on_fire()

func post_init():
	buildings = owner.get_node("Navigation2D/Buildings")
	entities = owner.get_node("Entities")
	props = owner.get_node("Props")
	set_z()

func grid_pos(pos: Vector2 = position):
	return s_grid_pos(pos)

static func s_grid_pos(pos: Vector2):
	var pixel_scale = 3
	
	var y = pos.y / (12 * pixel_scale)
	var x = (pos.x + pos.y / 2) / (16 * pixel_scale)
	return Vector2(x, y).floor()

static func pos_from_grid(pos: Vector2):
	var pixel_scale = 3
	
	var y = pos.y * 12 * pixel_scale
	var x = pos.x * 16 * pixel_scale - y / 2
	return Vector2(x, y).round()

func set_z():
	var pos = grid_pos()
	var fx = floor(pos.x)
	var fy = floor(pos.y)
	z_index = fx + 0.8 * fy + 0.2 * (pos.y)

func add_heat(heat: float):
	
	if heat > 0:
		added_heat += heat
	else:
		cooling += heat

func set_new_heat():
	
	if on_fire && can_be_on_fire:
		time_remaining -= 1
		if time_remaining < 0:
			time_remaining = time_alive_on_fire
			inc_state()
		if cooling < 0:
			current_heat += cooling
			if (current_heat < 0):
				current_heat = 0
				stop_fire()
	else:
		if (can_be_on_fire && added_heat != 0):
			current_heat += added_heat
			current_heat += cooling
			if current_heat < 0:
				current_heat = 0
			var c: float = current_heat / max_heat_resist
			modulate = Color(1, 1 - 0.3 * c, 1 - 0.3 * c, 1)
			
		if (current_heat > max_heat_resist):
			modulate = Color(1, 1, 1, 1)
			if (not on_fire):
				set_on_fire()
	if not on_fire:
		added_heat = -2
	else:
		added_heat = 0

func set_on_fire():
	if can_be_on_fire:
		on_fire = true
		inc_state()
		current_heat = max_heat_resist


func stop_fire():
	on_fire = false
	$Fire.emitting = false
	state = 0
	$Sprite.frame = state
	

func inc_state():
	state += 1
	if (state < nb_state):
		$Sprite.frame = state
		$Fire.emitting = true
	
	elif (state == nb_state):
		$Sprite.frame = state
		terminated()
	elif (state > nb_state):
		terminated()
	
	$Fire.set_state(state, nb_state)

func terminated():
		modulate = Color(0.9, 0.9, 0.9, 1)
		on_fire = false
		can_be_on_fire = false
		current_heat = 0

func transfer_heat():
	var heat_to_transfer = current_heat
	if (heat_to_transfer >= max_heat_transmitted):
		heat_to_transfer = max_heat_transmitted
	
	for x in range(0, width):
		intern_transfer(Vector2(x, -1), heat_to_transfer)
		intern_transfer(Vector2(x, height), heat_to_transfer)
		pass
	
	for y in range(0, height):
		intern_transfer(Vector2(-1, -y), heat_to_transfer)
		intern_transfer(Vector2(width, y), heat_to_transfer)
		pass
		
	intern_transfer(Vector2(0, 0), heat_to_transfer)
	

func intern_transfer(vec: Vector2, heat_to_transfer: int):
	var building_next_to = buildings.get_building_at(grid_pos() + vec)
	if building_next_to != null:
		building_next_to.add_heat(heat_to_transfer)
	
	var prop_next_to = props.get_building_at(grid_pos() + vec)
	if prop_next_to != null:
		prop_next_to.add_heat(heat_to_transfer)
	
	var entities_next_to = entities.get_entities_at(grid_pos() + vec)
	if entities_next_to != null:
		for entity in entities_next_to:
			entity.add_heat(heat_to_transfer)
