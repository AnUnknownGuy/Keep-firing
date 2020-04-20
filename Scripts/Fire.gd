extends Particles2D


onready var sprite = $"../Sprite"

var mat = process_material

func _ready():
	process_material = mat.duplicate(true)
	
	process_material.emission_sphere_radius = (sprite.get_rect().size.length()/2)

func set_ammout(state: int, states: int) -> void:
	if state == 0:
		amount = (sprite.get_rect().size.length()) * 0.5
	else:
		amount = (sprite.get_rect().size.length()) * state / states
		

func set_color(state: int, states: int) -> void:
	if (state != states):
		var color = Color(225.0/255,115.0/255,0,1)
		color = color.darkened(float(state)/states)
		process_material.color_ramp.gradient.colors[1] = color
	else:
		process_material.color_ramp.gradient.colors[0] = Color(0,0,0,0.3)
		process_material.color_ramp.gradient.colors[1] = Color(0,0,0,0.3)

func set_state(state: int, states: int) -> void:
	
	if (state > 0 && state < states):
		set_ammout(state, states)
	elif (state == states):
		set_ammout(0, 4)
	
	
	set_color(state, states)
