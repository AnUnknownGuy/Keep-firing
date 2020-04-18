extends Node2D


var speed = 0
var on_fire = false

export var heat_resist = 0
var current_heat = 0

var nb_states = 1

func _ready():
	set_z()

func grid_pos():
	return (position/64).floor()

func set_z():
	z_index = position.y

func heat_up(heat: float):
	current_heat += heat
	if (current_heat > heat_resist):
		set_on_fire()
	

func set_on_fire():
	on_fire = true
	#THINGS
