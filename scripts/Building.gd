extends Burnable
class_name Building

onready var human_scene = preload("res://Scenes/Human.tscn")
var nav

export var max_people_inside: int = 0
var people_inside = 0
var people_timer = 0
export var door_location: Vector2 = Vector2(0,0)

func reset():
	.reset()
	people_inside = round(max_people_inside / 2)
	

func reset_timer():
	if people_inside == 0:
		people_timer = 0
	else:
		people_timer = float(rand_range(1, 15)) / people_inside
		if on_fire:
			people_timer = 0.2

var grid_pos_buffer = null

func grid_pos(pos: Vector2 = position):
	if pos != position:
		return .grid_pos(pos)
	
	if grid_pos_buffer == null:
		grid_pos_buffer = .grid_pos()
	return grid_pos_buffer

func _ready():
	people_inside = round(max_people_inside / 2)
	reset_timer()

func post_init():
	nav = owner.get_node("Navigation2D")
	.post_init()

func _process(delta):
	if people_inside > 0:
		people_timer -= delta

		if people_timer < 0:
			reset_timer()
			spawn_human()

func exit_pos():
	var disp
	var found = false
	if nav.is_in_nav(position + door_location):
		disp = door_location
	else:
		if not found:
			for x in range(0, width):
				var pos_test = grid_pos() + Vector2(x, height-1)
				if nav.is_in_nav(pos_from_grid(pos_test) + Vector2(12, 36)):
					disp = pos_from_grid(Vector2(x, height-1)) + Vector2(12, 36)
					found = true
					break
		if not found:
			for y in range(0, height):
				var pos_test = grid_pos() + Vector2(width-1, y)
				if nav.is_in_nav(pos_from_grid(pos_test) + Vector2(39, 21)):
					disp = pos_from_grid(Vector2(width-1, y)) + Vector2(39, 21)
					found = true
					break
		if not found:
			for y in range(0, height):
				var pos_test = grid_pos() + Vector2(0, y)
				if nav.is_in_nav(pos_from_grid(pos_test) + Vector2(-15, 18)):
					disp = pos_from_grid(Vector2(0, y)) + Vector2(-15, 18)
					found = true
					break
		if not found:
			for x in range(0, width):
				var pos_test = grid_pos() + Vector2(x, 0)
				if nav.is_in_nav(pos_from_grid(pos_test) + Vector2(18, -6)):
					disp = pos_from_grid(Vector2(x, 0)) + Vector2(18, -6)
					found = true
					break
	
	if disp == null:
		return null
	else:
		return position + disp

func spawn_human():
	var exit_pos = exit_pos()
	
	if exit_pos != null:
		randomize()
		people_inside -= 1
		var human = human_scene.instance()
		human.position = exit_pos
		entities.add_child(human)
		entities.declare(human)
		human.set_owner(owner)
		human.post_init()
		var b = buildings.get_random_building(grid_pos())
		human.set_goal(b)
		if on_fire:
			human.set_on_fire()

func add_human(human: Human):
	people_inside += 1
	if human.on_fire:
		add_heat(human.max_heat_transmitted)

func _to_string():
	return "Building(" + str(people_inside) + "/" + str(max_people_inside) + ")"
