extends Node2D

onready var buildings = $"Navigation2D/Buildings".get_children()
onready var entities = $Entities.get_children()
onready var props = $Props.get_children()

export var burn_timer_max: float = 0.5
var burn_timer = burn_timer_max

func _input(event):
	if event is InputEventMouseMotion:
		var pos = Burnable.s_grid_pos(event.position)
		$Highlight.position = Burnable.pos_from_grid(pos)

func _ready():
	VisualServer.set_default_clear_color(Color(0.878,0.749,0.596,1.0))

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
