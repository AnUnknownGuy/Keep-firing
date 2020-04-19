extends Node2D

onready var nav = $Navigation2D
onready var entities = $Entities
onready var human_scene = preload("res://Scenes/Human.tscn")

func rand_pos():
	return Vector2(rand_range(0, 1024), rand_range(0, 600))

func _ready():
	for i in range(150):
		var pos = rand_pos()
		while not nav.is_in_nav(pos):
			pos = rand_pos()
		
		var human = human_scene.instance()
		human.position = pos
		entities.add_child(human)
		entities.declare(human)
