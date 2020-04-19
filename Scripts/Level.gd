extends Node2D

onready var buildings = $Buildings.get_children()
onready var entities = $Entities.get_children()
onready var props = $Props.get_children()

export var burn_timer_max: float = 0.5
var burn_timer = burn_timer_max

func _process(delta):
	burn_timer -= delta
	if burn_timer < 0:
		burn_timer += burn_timer_max
		
		for b in buildings:
			if b.on_fire:
				b.transfer_heat()

		for e in entities:
			if e.on_fire:
				e.transfer_heat()
		
		for p in props:
			if p.on_fire:
				p.transfer_heat()
		
		for b in buildings:
			b.set_new_heat()
			
		for e in entities:
			e.set_new_heat()
		
		for p in props:
			p.set_new_heat()
