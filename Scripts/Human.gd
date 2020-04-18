extends Entity
class_name Human

const FaceColors = ["#E9CDA1", "#CFA07C", "#F8DEC5", "#F8E3AB", "#CF9763", "#75451F", "#301E11"]
const BodyColors = ["#32a852", "#6d3dba", "#1d65b3", "#d17e11", "#d64fae", "#db2323", "#34d185"]

var path

func _ready():
	randomize()
	speed = rand_range(0.5, 3)
	$Parts/Face.color = FaceColors[floor(rand_range(0, FaceColors.size()))]
	$Parts/Body.color = BodyColors[floor(rand_range(0, BodyColors.size()))]
	
	path = $"../../Navigation2D".get_actual_path(position, Vector2(50, 100))
	$"../../Line2D".points = path
	print(path)

func _process(delta):
	#var angle = rand_range(0, 2 * PI)
	#position += Vector2(sin(angle), cos(angle)) * speed
	set_z()
