extends Particles2D


var mat = process_material

func _ready():
	
	process_material = mat.duplicate()
	process_material.color_ramp = mat.color_ramp.duplicate()
	process_material.color_ramp.gradient = mat.color_ramp.gradient.duplicate()


func set_color(state: int, states: int) -> void:
	if (state != states):
		var color = Color(225.0/255,115.0/255,0,1)
		color = color.darkened(float(state)/states)
		process_material.color_ramp.gradient.colors[1] = color
	else:
		process_material.color_ramp.gradient.colors[0] = Color(0,0,0,0.3)
		process_material.color_ramp.gradient.colors[1] = Color(0,0,0,0.3)

func set_state(state: int, states: int) -> void:
	
	set_color(state, states)
