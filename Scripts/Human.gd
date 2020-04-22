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
var stop_moving = false
var timer_falling: float = 0.5
var time_to_fall: float = 0.5
var goal
var goal_random
var goal_building

func find_random_location(angle: float, variation: float, times: int) -> float:
	randomize()
	walk_time = randf() * 2.5 + 0.5
	
	var temp_angle = (randf() - 0.5) * variation
	
	var ran_direction = Vector2(cos(angle + temp_angle), sin(angle + temp_angle))
	
	var direction = ran_direction * walk_time * speed
	
	if collision_with(direction) && times > 0:
		return find_random_location(angle, variation+0.0, times-1)
	else:
		return temp_angle + angle

func next_movement():
	set_goal(goal_building)
	if randf() < -1 or goal_building == null:
		angle = find_random_location(0, 2 * PI, 150)
	else:
		get_next_goal()
		angle = goal.angle_to_point(position)
		if (path.size() > 1):
			angle = find_random_location(angle, 0.5, 150)
		else:
			randomize()
			walk_time =  position.distance_to(goal) / speed

const STEPS = 3

func collision_with(direction: Vector2):
	for i in range(1, STEPS + 1):
		if not nav.is_in_nav(position + (direction * float(i)/STEPS)):
			return true
	return false

func _ready():
	$Parts/Face.color = FaceColors[floor(rand_range(0, FaceColors.size()))]
	$Parts/Body.color = BodyColors[floor(rand_range(0, BodyColors.size()))]
	
	nav = $"../../Navigation2D"
	
	randomize()
	speed = rand_range(speed, speed*2)
	wait_time = 0
	
	time_remaining = time_alive_on_fire
	nb_state = 3

func inc_state():
	state += 1
	$Fire.emitting = true
	if (state == 1):
		goal_building = null
		path = null
	if (state == 2):
		dead()
	if (state >= nb_state):
		terminated()
		
	$Fire.set_state(state, nb_state)

func stop_fire():
	on_fire = false
	speed /= 1.5
	$Fire.emitting = false
	state = 0
	

func dead() -> void:
	is_dead = true
	pass
	
func set_on_fire():
	if can_be_on_fire:
		speed *= 1.5
		on_fire = true
		inc_state()
		current_heat = max_heat_resist
		
		goal_building = null
		next_movement()
		
		

func get_next_goal():
	if on_goal():
		path.remove(0)
		if path == []:
			when_on_goal()
		else:
			goal = path[0]

func on_goal():
	return stepify(goal.angle_to_point(position), 0.01) != stepify(angle, 0.01)

func when_on_goal():
	goal_building.add_human(self)
	entities.remove(self)
	queue_free()

func set_goal(b):
	goal_building = b
	
	if b != null:
		if path == null:
			path = []
		var exit_pos = b.exit_pos()
		if stepify(position.x, 1) == stepify(exit_pos.x, 1) and stepify(position.y, 1) == stepify(exit_pos.y, 1):
			path.remove(0)
			if path == []:
				when_on_goal()
				
		path = nav.get_actual_path(position, b.exit_pos())
		if (path.size() != 0):
			path.remove(0)
			goal = path[0]
			angle = goal.angle_to_point(position)
		else:
			goal_building = null
			angle = find_random_location(angle, 0.5, 150)
			
	else:
		pass

func rand_wait_time():
	return 2.0 * randf()

func _process(delta):
	if not is_dead:
		if not stop_moving:
			if wait_time >= 0:
				wait_time -= delta
				
				if wait_time < 0:
					next_movement()
					
			else:
				walk_time -= delta 
				
				var old_pos = position 
				position = position + Vector2(cos(angle), sin(angle)) * speed * delta 
				
				if grid_pos() != grid_pos(old_pos):
					entities.change_pos_of(self, grid_pos(old_pos))
				
				if walk_time < 0:
					if on_fire:
						wait_time = 0
					else:
						wait_time = rand_wait_time()
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
