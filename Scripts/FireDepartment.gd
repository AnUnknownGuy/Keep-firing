extends Building

var has_spawned = false

onready var fireman_scene = preload("res://Scenes/Fireman.tscn")

var goal
var firemen = []
export var cooling_power = 0

func set_goal():
	goal = get_parent().get_random_building_on_fire()
	for f in firemen:
		f.set_goal(goal)
		f.reset()

func _process(delta):
	if not has_spawned and get_parent().has_building_on_fire():
		for i in range(8):
			var fireman = fireman_scene.instance()
			fireman.cooling_power = cooling_power
			fireman.position = exit_pos()
			entities.add_child(fireman)
			entities.declare(fireman)
			fireman.set_owner(owner)
			fireman.post_init()
			
			firemen.append(fireman)
		set_goal()
		has_spawned = true
	
	if (goal != null and not goal.on_fire) or \
		(goal == null and get_parent().has_building_on_fire()):
		set_goal()

