extends Node2D

onready var buildings = $Buildings.get_children()

export var burn_timer_max = 500
var burn_timer = burn_timer_max

func _process(delta):
	burn_timer -= delta
	if burn_timer < 0:
		burn_timer += burn_timer_max
		
		for b in buildings:
			if b.on_fire:
				b.transfer_heat()
		
		for b in buildings:
			b.set_new_heat()
