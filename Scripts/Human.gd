extends Entity
class_name Human

const FaceColors = ["#E9CDA1", "#CFA07C", "#F8DEC5", "#F8E3AB", "#CF9763", "#75451F", "#301E11"]
const BodyColors = ["#32a852", "#6d3dba", "#1d65b3", "#d17e11", "#d64fae", "#db2323", "#34d185"]

var nav

var walk_time: float
var wait_time: float
var angle: float
var path
var is_dead = false
var timer_falling: float = 0.5
var time_to_fall: float = 0.5
var goal
var goal_random
var goal_building

func rand_direction() -> Vector2:
	randomize()
	var temp_angle = randf() * 2 * PI
	return Vector2(cos(temp_angle), sin(temp_angle))

func find_random_location():
	var ran_direction = rand_direction()
	
	if collision_with(ran_direction):
		find_random_location()
	else:
		goal_random = position + ran_direction


func next_movement():
	randomize()
	if randf() < -1 or goal_building == null:
		print("pas bon L43")
		find_random_location()
		angle = goal_random.angle_to_point(position)
	else:
		get_next_goal()
		angle = goal.angle_to_point(position)


const STEPS = 5

func collision_with(direction: Vector2):
	for i in range(1, STEPS + 1):
		if not nav.is_in_nav(position + (direction * i/STEPS)):
			return true
	return false

func _ready():
	$Parts/Face.color = FaceColors[floor(rand_range(0, FaceColors.size()))]
	var bodycol = BodyColors[floor(rand_range(0, BodyColors.size()))]
	$Parts/Body.color = bodycol
	$Line2D.default_color = bodycol
	
	nav = $"../../Navigation2D"
	
	speed = rand_range(20, 40)
	wait_time = 0
	
	time_remaining = time_alive_on_fire
	nb_state = 3


func inc_state():
	state += 1
	$Fire.emitting = true
	if (state == 1):
		speed = 20
	if (state == 2):
		dead()
	if (state >= nb_state):
		terminated()
		
	$Fire.set_state(state, nb_state)

func dead() -> void:
	is_dead = true
	pass


func get_next_goal():
	if on_goal():
		path.remove(0)
		if path == []:
			goal_building.add_human(self)
			queue_free()
		else:
			goal = path[0]

func on_goal():
	return stepify(goal.angle_to_point(position), 0.01) != stepify(angle, 0.01)

func set_goal(b):
	goal_building = b
	if b != null:
		path = nav.get_actual_path(position, b.exit_pos())
		path.remove(0)
		goal = path[0]
		angle = goal.angle_to_point(position)
	else:
		pass

func _process(delta):
	if not is_dead:
		if wait_time >= 0:
			wait_time -= delta
			
			if wait_time < 0:
				next_movement()
				
				
		else:
			walk_time -= delta

			position += Vector2(cos(angle), sin(angle)) * speed * delta 
			#print("position :", position, " goal :", goal, " angle :", angle)
			
			if walk_time < 0:
				if not on_fire:
					wait_time = 0
				else:
					wait_time = 0
			
			if path != null:
				var shift_path = []
				for p in path:
					shift_path.append(p - position)
				$Line2D.points = shift_path
		set_z()
	else:
		if timer_falling >  0:
			timer_falling -= delta
			if timer_falling < 0:
				timer_falling = 0
			var rot = pow(sin(((time_to_fall - timer_falling) / time_to_fall) * PI/2),20)
			rotation_degrees = -90 * rot
			$Fire.process_material.direction.x = rot
			$Fire.process_material.direction.y = -1 + rot
