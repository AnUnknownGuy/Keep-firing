extends Entity
class_name Human

const FaceColors = ["#E9CDA1", "#CFA07C", "#F8DEC5", "#F8E3AB", "#CF9763", "#75451F", "#301E11"]
const BodyColors = ["#32a852", "#6d3dba", "#1d65b3", "#d17e11", "#d64fae", "#db2323", "#34d185"]

var nav

var walk_time: float
var wait_time: float
var angle: float
var path
var goal
var goal_building

func rand_location():
	randomize()
	walk_time = randf() * 2.5 + 0.5
	angle = randf() * 2 * PI

func find_valid_location():
	rand_location()
	while collision():
		rand_location()

func target_pos():
	return Vector2(sin(angle), cos(angle)) * walk_time * speed

const STEPS = 5

func collision():
	for i in range(1, STEPS + 1):
		if not nav.is_in_nav(position + target_pos() * i/STEPS):
			return true
	return false

func _ready():
	$Parts/Face.color = FaceColors[floor(rand_range(0, FaceColors.size()))]
	var bodycol = BodyColors[floor(rand_range(0, BodyColors.size()))]
	$Parts/Body.color = bodycol
	$Line2D.default_color = bodycol
	
	nav = $"../../Navigation2D"
	
	speed = rand_range(10, 20)
	find_valid_location()
	wait_time = 0

func get_next_goal():
	goal = path[0]
	path.remove(0)

func set_goal(b):
	goal_building = b
	path = nav.get_actual_path(position, b.exit_pos())
	path.remove(0)
	get_next_goal()
	find_valid_location()

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
		
		if path != null:
			var shift_path = []
			for p in path:
				shift_path.append(p - position)
			$Line2D.points = shift_path
	set_z()
