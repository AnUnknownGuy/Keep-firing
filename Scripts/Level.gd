extends Node2D

onready var buildings = $"Navigation2D/Buildings".get_children()
onready var entities = $Entities.get_children()
onready var props = $Props.get_children()

onready var tile_highlight = preload("res://Resources/Images/Sprite/tile_border.png")

var burn_timer_max: float = 0.5
var burn_timer = burn_timer_max

export(int) var nb_cardboard = 0
export(int) var nb_jerrycan = 0
export(int) var nb_grass = 0
export(int) var nb_forest = 0
export(int) var nb_house = 0
export(int) var nb_building = 0
export(int) var nb_gas_station = 0
export(int) var nb_hospital = 0

var selected_scene = null
var selected_type = 0
var selected_width = 1
var clicked_button = null

func set_scene(scene, type, width, button):
	if button.get_count() > 0:
		clicked_button = button
		selected_type = type
		selected_scene = scene
		selected_width = width
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
var setting_fire = false
var placable = false

onready var cursor = preload("res://Resources/Images/Sprite/cursor.png")
onready var cursor_click = preload("res://Resources/Images/Sprite/cursor_click.png")
onready var cursor_fire = preload("res://Resources/Images/Sprite/cursor_fire.png")

func _input(event):
	if event is InputEventMouseMotion:
		var pos = Burnable.s_grid_pos(event.position)
		$TilePreview.position = Burnable.pos_from_grid(pos)
		
		if selected_scene != null:
			var no_building = true
			var no_props = true
			var all_in_nav = true
			var none_in_nav = true
			for i in range(selected_width):
				var p = pos + Vector2(i, 0)
				if $Navigation2D/Buildings.get_building_at(p) != null:
					no_building = false
					
				if $Props.get_building_at(p) != null:
					no_props = false
					
				if $Navigation2D.is_in_nav(Burnable.pos_from_grid(p) + Vector2(0.1, 0.1)):
					none_in_nav = false
				else:
					all_in_nav = false
			
			if no_props and (no_building or selected_type == 2):
				if selected_type == 0: # Building
					placable = none_in_nav
				elif selected_type == 1: # Prop
					placable = all_in_nav
				elif selected_type == 2: # SProp
					var b = $Navigation2D/Buildings.get_building_at(pos)
					placable = all_in_nav or (b != null and b.max_people_inside > 0)
			else:
				placable = false
				
			$TilePreview.self_modulate = Color(0.211, 1, 0.211, 0.784) if placable \
				else Color(1, 0.211, 0.211, 0.784)
	
	elif event is InputEventMouseButton and not event.is_echo():
		if setting_fire and event.pressed:
			var pos = Burnable.s_grid_pos($TilePreview.position)
			var build = $Navigation2D/Buildings.get_building_at(pos)
			if build != null and build.can_be_on_fire:
				build.set_on_fire()
				setting_fire = false
				get_tree().paused = false
				$Buttons.show()
		
		if not setting_fire:
			Input.set_custom_mouse_cursor(cursor_click if event.pressed else cursor)
		
		if event.pressed and not ignore_click and selected_scene != null and placable:
			var placed = selected_scene.instance()
			placed.position = $TilePreview.position
			var coll = $Navigation2D/Buildings if selected_type == 0 else $Props
			coll.add_child(placed)
			coll.declare(placed)
			placed.set_owner(self)
			placed.post_init()
			
			var n_count = clicked_button.get_count() - 1
			clicked_button.set_count(n_count)
			
			if n_count == 0:
				highlight()
				selected_scene = null
	
	elif event is InputEventKey and event.pressed and not event.is_echo():
		if event.scancode == KEY_SPACE:
			get_tree().paused = not get_tree().paused

func _ready():
	VisualServer.set_default_clear_color(Color(0.654,0.654,0.654,1.0))
	highlight()
	
	init_counts()
	
	Input.set_custom_mouse_cursor(cursor_fire, Input.CURSOR_ARROW, Vector2(3, 6))
	get_tree().paused = true
	setting_fire = true

func init_counts():
	$Buttons/CardboardButton.set_count(nb_cardboard)
	$Buttons/JerrycanButton.set_count(nb_jerrycan)
	$Buttons/GrassButton.set_count(nb_grass)
	$Buttons/ForestButton.set_count(nb_forest)
	$Buttons/HouseButton.set_count(nb_house)
	$Buttons/BuildingButton.set_count(nb_building)
	$Buttons/GasStationButton.set_count(nb_gas_station)
	$Buttons/HosiptalButton.set_count(nb_hospital)

func _process(delta):
	entities = $Entities.get_children()
	props = $Props.get_children()
	buildings = $"Navigation2D/Buildings".get_children()
	ignore_click = false
	
	burn_timer -= delta
	if burn_timer < 0:
		burn_timer += burn_timer_max
		
		for b in buildings:
			b.transfer_heat()

		for e in entities:
			e.transfer_heat()
			if "stop_moving" in e:
				if e.stop_moving:
					if e.goal_building != null:
						e.goal_building.add_heat(-e.cooling_power)
		
		for p in props:
			p.transfer_heat()
		
		for b in buildings:
			b.set_new_heat()
			
		for e in entities:
			e.set_new_heat()
		
		for p in props:
			p.set_new_heat()
