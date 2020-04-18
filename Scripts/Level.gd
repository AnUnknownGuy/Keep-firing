extends Node2D

onready var buildings = $Buildings.get_children()

export var burn_timer_max = 0.5
var burn_timer = burn_timer_max

func _ready():
	generate_roads()

func generate_roads():
	pass
#	var roads = []
#	for i in range(20):
#		roads[i] = []
#		for j in range(20):
#			roads[i][j] = ""
#
#	for i in range(4):
#		var ax = floor(randf() * 19)
#		var ay = floor(randf() * 19)
#		var sx = floor(randf() * (20 - ax))
#		var sy = floor(randf() * (20 - ay))
#
#		for x in range(sx):
#			for y in range(sy):
#				pass

func _process(delta):
	burn_timer -= delta
	if burn_timer < 0:
		burn_timer += burn_timer_max
		
		for b in buildings:
			if b.on_fire:
				b.transfer_heat()
		
		for b in buildings:
			b.set_new_heat()
