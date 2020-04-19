extends Burnable
class_name Building

onready var nav = owner.get_node("Navigation2D")
onready var human_scene = preload("res://Scenes/Human.tscn")

export var max_people_inside: int = 0
var people_inside = 0
var people_timer = 0

func reset_timer():
	if people_inside == 0:
		people_timer = 0
	else:
		people_timer = rand_range(20, 30) / people_inside

var grid_pos_buffer = null

func grid_pos(pos: Vector2 = position):
	if pos != position:
		return .grid_pos(pos)
	
	if grid_pos_buffer == null:
		grid_pos_buffer = .grid_pos()
	return grid_pos_buffer

func _ready():
	people_inside = round(max_people_inside / 2)
	people_timer = rand_range(0, 15)

func _process(delta):
	if people_inside > 0:
		people_timer -= delta
		
		if people_timer < 0:
			reset_timer()
			spawn_human()

func exit_pos():
	var disp
	if nav.is_in_nav(position + Vector2(21, 36)):
		disp = Vector2(21, 36)
	elif nav.is_in_nav(position + Vector2(39, 21)):
		disp = Vector2(39, 21)
	elif nav.is_in_nav(position + Vector2(-15, 18)):
		disp = Vector2(-15, 18)
	else:
		disp = Vector2(18, -6)
	
	return position + disp

func spawn_human():
	people_inside -= 1
	
	var human = human_scene.instance()
	human.position = exit_pos()
	entities.add_child(human)
	entities.declare(human)
	human.set_owner(owner)
	human.post_init()
	
	human.set_goal(buildings.get_random_building(grid_pos()))

func _to_string():
	return "Building(" + str(people_inside) + "/" + str(max_people_inside) + ")"
