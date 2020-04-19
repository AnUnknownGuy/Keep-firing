extends Node2D

onready var buildings = $Navigation2D/Buildings.get_children()

export var burn_timer_max = 0.5
var burn_timer = burn_timer_max

func _ready():
	VisualServer.set_default_clear_color(Color(0.878,0.749,0.596,1.0))

func _process(delta):
	burn_timer -= delta
	if burn_timer < 0:
		burn_timer += burn_timer_max
		
		for b in buildings:
			if b.on_fire:
				b.transfer_heat()
		
		for b in buildings:
			b.set_new_heat()
