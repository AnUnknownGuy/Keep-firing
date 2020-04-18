extends Node2D
class_name Building

onready var buildings = $"../../Buildings"

export var max_people_inside = 0
var actual_people_inside = max_people_inside

export var time_alive_on_fire = 0
var time_remaining = time_alive_on_fire

export var can_be_on_fire = false
var on_fire = false

export var heat_resist = 0
var current_heat = 0

var nb_states = 1

func _ready():
	set_z()

func grid_pos():
	return position/64

func set_z():
	z_index = position.y

func heat_up(heat: float):
	if (can_be_on_fire):
		current_heat += heat
		if (current_heat > heat_resist):
			set_on_fire()
	

func set_on_fire():
	if (can_be_on_fire):
		on_fire = true
		#THINGS
