extends Burnable
class_name Building

export var max_people_inside = 0
var actual_people_inside = max_people_inside


export var can_be_on_fire = false

func set_on_fire():
	if (can_be_on_fire):
		on_fire = true
		#THINGS
