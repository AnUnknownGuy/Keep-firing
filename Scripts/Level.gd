extends Node2D

onready var buildings = $"Navigation2D/Buildings".get_children()
onready var entities = $Entities.get_children()
onready var props = $Props.get_children()

onready var tile_highlight = preload("res://Resources/Images/Sprite/tile_border.png")

var burn_timer_max: float = 0.25
var burn_timer = burn_timer_max

export(int) var nb_cardboard = 0
export(int) var nb_jerrycan = 0
export(int) var nb_grass = 0
export(int) var nb_forest = 0
export(int) var nb_house = 0
export(int) var nb_building = 0
export(int) var nb_gas_station = 0
export(int) var nb_hospital = 0
export(int) var objective_timer = 0

var current_timer = objective_timer

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
		var tilePreview = $"GUI/TilePreview"
		tilePreview.texture = spr.texture
		tilePreview.offset = spr.offset
		tilePreview.centered = spr.centered
		tilePreview.hframes = spr.hframes
		tilePreview.vframes = spr.vframes

func highlight():
	var tilePreview = $"GUI/TilePreview"
	tilePreview.texture = tile_highlight
	tilePreview.offset = Vector2(-5, 0)
	tilePreview.centered = false
	tilePreview.self_modulate = Color(0.211, 1, 0.211, 0.784)
	tilePreview.hframes = 1
	tilePreview.vframes = 1

var ignore_click = false
var setting_fire = false
var placable = false

onready var cursor = preload("res://Resources/Images/Sprite/cursor.png")
onready var cursor_click = preload("res://Resources/Images/Sprite/cursor_click.png")
onready var cursor_fire = preload("res://Resources/Images/Sprite/cursor_fire.png")

func start():
	setting_fire = true
	Input.set_custom_mouse_cursor(cursor_fire, Input.CURSOR_ARROW, Vector2(3, 6 ))

func reset():
	entities = $Entities.get_children()
	props = $Props.get_children()
	buildings = $"Navigation2D/Buildings".get_children()
	
	get_tree().paused = true
	$Entities.remove_all()
	
	$"GUI/Buttons".show()
	$"GUI/TilePreview".show()
	$"GUI/Reset".hide()
		
	for b in buildings:
		b.reset()
		
	for e in entities:
		e.queue_free()
		
	for p in props:
		p.reset()
	
	current_timer = 0
	
	updateObjective()


func _input(event):
	if event is InputEventMouseMotion:
		var pos = Burnable.s_grid_pos(event.position)
		$"GUI/TilePreview".position = Burnable.pos_from_grid(pos)
		
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
			
			if no_props :
				if selected_type == 0: # Building
					placable = none_in_nav and no_building and not $Navigation2D/Roads.is_road(pos)
				elif selected_type == 1: # Prop
					placable = all_in_nav or $Navigation2D/Roads.is_road(pos)
				elif selected_type == 2: # SProp
					var b = $Navigation2D/Buildings.get_building_at(pos)
					placable = all_in_nav or (b != null and b.max_people_inside > 0) or $Navigation2D/Roads.is_road(pos)
			else:
				placable = false
				
			$"GUI/TilePreview".self_modulate = Color(0.211, 1, 0.211, 0.784) if placable \
				else Color(1, 0.211, 0.211, 0.784)

	elif event is InputEventMouseButton and not event.is_echo():
		
		if setting_fire and event.pressed and event.button_index == 1 :
			var pos = Burnable.s_grid_pos($"GUI/TilePreview".position)
			var build = $Navigation2D/Buildings.get_building_at(pos)
			if build != null and build.can_be_on_fire:
				build.set_on_fire()
				setting_fire = false
				get_tree().paused = false
				$"GUI/Buttons".hide()
				$"GUI/TilePreview".hide()
				$"GUI/Reset".show()
				Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(3, 6 ))
		
		if not setting_fire:
			Input.set_custom_mouse_cursor(cursor_click if event.pressed else cursor)
		
		if event.pressed and not ignore_click and selected_scene != null and placable and event.button_index == 1 :
			var placed = selected_scene.instance()
			placed.position = $"GUI/TilePreview".position
			var coll = $Navigation2D/Buildings if selected_type == 0 else $Props
			coll.add_child(placed)
			coll.declare(placed)
			placed.set_owner(self)
			placed.post_init()
			placed.removable = true
			
			var n_count = clicked_button.get_count() - 1
			clicked_button.set_count(n_count)
			
			if n_count == 0:
				highlight()
				selected_scene = null
		
		elif event.pressed and not ignore_click and event.button_index == 2 :
			print("clic droit")
			var position = Burnable.s_grid_pos($"GUI/TilePreview".position)
			var prop = $Props.get_building_at(position)
			if prop != null:
				if prop.removable:
					$Props.remove(prop)
					var path = prop.get_node("Sprite").texture.get_path()
					var button
					if "cardboard" in path:
						button = $GUI/Buttons/CardboardButton
					elif "jerrycan" in path:
						button = $GUI/Buttons/JerrycanButton
					
					button.set_count(button.get_count()+1)
					
					prop.queue_free()
			else:
				var building = $"Navigation2D/Buildings".get_building_at(position)
				if building != null:
					if building.removable:
						$"Navigation2D/Buildings".remove(building)
						
						var path = building.get_node("Sprite").texture.get_path()
						var button
						if "grass" in path:
							button = $GUI/Buttons/GrassButton
						elif "forest" in path:
							button = $GUI/Buttons/ForestButton
						elif "house" in path:
							button = $GUI/Buttons/HouseButton
						elif "building" in path:
							button = $GUI/Buttons/BuildingButton
						elif "gas_station" in path:
							button = $GUI/Buttons/GasStationButton
						elif "hospital" in path:
							button = $GUI/Buttons/HosiptalButton
					
						button.set_count(button.get_count()+1)
					
						building.queue_free()
		updateObjective()

func _ready():
	VisualServer.set_default_clear_color(Color(0.654,0.654,0.654,1.0))
	highlight()
	get_tree().paused = true
	init_counts()
	updateObjective()

func updateObjective():
	entities = $Entities.get_children()
	props = $Props.get_children()
	buildings = $"Navigation2D/Buildings".get_children()
	
	var current = 0
	var nb_total = 0
	
	for b in buildings:
		if b.to_burn:
			nb_total += 1
			if b.burned:
				current += 1
	
	for p in props:
		if p.to_burn:
			nb_total += 1
			if p.burned:
				current += 1
	
	
	$GUI/Counter/Objective.set_number(current)
	$GUI/Counter/Max.set_number(nb_total)
	$GUI/Timer/Objective.set_number(int(current_timer))
	$GUI/Timer/Max.set_number(int(objective_timer))

func init_counts():
	$GUI/Buttons/CardboardButton.set_count(nb_cardboard)
	$GUI/Buttons/JerrycanButton.set_count(nb_jerrycan)
	$GUI/Buttons/GrassButton.set_count(nb_grass)
	$GUI/Buttons/ForestButton.set_count(nb_forest)
	$GUI/Buttons/HouseButton.set_count(nb_house)
	$GUI/Buttons/BuildingButton.set_count(nb_building)
	$GUI/Buttons/GasStationButton.set_count(nb_gas_station)
	$GUI/Buttons/HosiptalButton.set_count(nb_hospital)

func _process(delta):
	ignore_click = false
	if not get_tree().paused:
		entities = $Entities.get_children()
		props = $Props.get_children()
		buildings = $"Navigation2D/Buildings".get_children()
		
		current_timer += delta
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
	updateObjective()
