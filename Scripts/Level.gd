extends Node2D

onready var buildings = $"Navigation2D/Buildings".get_children()
onready var entities = $Entities.get_children()
onready var props = $Props.get_children()

onready var tile_highlight = preload("res://Resources/Images/Sprite/tile_border.png")

export var burn_timer_max: float = 0.5
var burn_timer = burn_timer_max

var selected_scene = null

func set_scene(scene):
	selected_scene = scene
	var spr = scene.instance().get_node("Sprite")
	$TilePreview.texture = spr.texture
	$TilePreview.offset = spr.offset
	$TilePreview.centered = spr.centered
	$TilePreview.hframes = spr.hframes
	$TilePreview.vframes = spr.vframes

func highlight():
	$TilePreview.texture = tile_highlight
	$TilePreview.offset = Vector2(-5, 0)
	$TilePreview.centered = false
	$TilePreview.self_modulate = Color(0.211, 1, 0.211, 0.784)
	$TilePreview.hframes = 1
	$TilePreview.vframes = 1

var ignore_click = false
var placable = false

onready var cursor = preload("res://Resources/Images/Sprite/cursor.png")
onready var cursor_click = preload("res://Resources/Images/Sprite/cursor_click.png")

func _input(event):
	if event is InputEventMouseMotion:
		var pos = Burnable.s_grid_pos(event.position)
		$TilePreview.position = Burnable.pos_from_grid(pos)
		
		if selected_scene != null:
			if $Navigation2D.is_in_nav(event.position) and $Props.get_building_at(pos) == null:
				$TilePreview.self_modulate = Color(0.211, 1, 0.211, 0.784)
				placable = true
			else:
				$TilePreview.self_modulate = Color(1, 0.211, 0.211, 0.784)
				placable = false
	
	elif event is InputEventMouseButton and not event.is_echo():
		Input.set_custom_mouse_cursor(cursor_click if event.pressed else cursor)
		
		if event.pressed and not ignore_click and selected_scene != null and placable:
			var placed = selected_scene.instance()
			placed.position = $TilePreview.position
			$Props.add_child(placed)
			$Props.declare(placed)
			placed.set_owner(self)
			placed.post_init()
			
			highlight()
			selected_scene = null
	
	elif event is InputEventKey and event.pressed and not event.is_echo():
		if event.scancode == KEY_SPACE:
			get_tree().paused = not get_tree().paused

func _ready():
	VisualServer.set_default_clear_color(Color(0.824,0.824,0.824,1.0))
	highlight()

func _process(delta):
	ignore_click = false
	
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
