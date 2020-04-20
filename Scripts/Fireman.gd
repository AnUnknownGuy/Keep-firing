extends Human

var cooling_power = 0

func _ready():
	$Water.process_material = $Water.process_material.duplicate(true)
	speed = rand_range(35, 45)

func rand_wait_time():
	if goal_building == null:
		return .rand_wait_time()
	else:
		return 0

func when_on_goal():
	stop_moving = true
	var angle = position.angle_to_point(goal_building.position)
	$Water.process_material.direction = Vector3(-cos(angle), -sin(angle), 0)
	$Water.emitting = true

func reset():
	stop_moving = false
	$Water.emitting = false

func dead():
	.dead()
	$Water.emitting = false
