extends Entity
class_name Human

const FaceColors = ["#E9CDA1", "#CFA07C", "#F8DEC5", "#F8E3AB", "#CF9763", "#75451F", "#301E11"]
const BodyColors = ["#32a852", "#6d3dba", "#1d65b3", "#d17e11", "#d64fae", "#db2323", "#34d185"]

onready var roads = $"../../Roads"

var walk_time
var wait_time
var angle

func rand_location():
	randomize()
	walk_time = randf() * 2.5 + 0.5
	angle = randf() * 2 * PI

func find_valid_location():
	rand_location()
	while collision():
		rand_location()
	print(grid_pos(position + Vector2(sin(angle), cos(angle)) * walk_time * speed))

const STEPS = 5

func collision():
	var movement = Vector2(sin(angle), cos(angle)) * walk_time * speed
	for i in range(1, STEPS + 1):
		if not roads.is_road(grid_pos(position + movement * i/STEPS).floor()):
			return true
	return false

func _ready():
	$Parts/Face.color = FaceColors[floor(rand_range(0, FaceColors.size()))]
	$Parts/Body.color = BodyColors[floor(rand_range(0, BodyColors.size()))]
	
	speed = rand_range(10, 20)
	find_valid_location()
	wait_time = 0

func _process(delta):
	if wait_time > 0:
		wait_time -= delta
		
		if wait_time < 0:
			find_valid_location()
	else:
		walk_time -= delta
		
		position += Vector2(sin(angle), cos(angle)) * speed * delta
		
		if walk_time < 0:
			wait_time = randf() * 2.5 + 0.5
	
	set_z()
