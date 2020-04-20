extends Node2D

onready var nav = $Navigation2D
onready var entities = $Entities
onready var human_scene = preload("res://Scenes/Human.tscn")

onready var cursor = preload("res://Resources/Images/Sprite/cursor.png")
onready var cursor_click = preload("res://Resources/Images/Sprite/cursor_click.png")

func _input(event):
	if event is InputEventMouseButton and not event.is_echo():
		Input.set_custom_mouse_cursor(cursor_click if event.pressed else cursor)

func rand_pos():
	return Vector2(rand_range(0, 1024), rand_range(0, 600))

func _ready():
	for i in range(0):
		var pos = rand_pos()
		while not nav.is_in_nav(pos):
			pos = rand_pos()
		
		var human = human_scene.instance()
		human.position = pos
		entities.add_child(human)
		entities.declare(human)
