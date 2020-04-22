extends Sprite
class_name _Button

var mouse_pos = Vector2(0, 0)
var is_in = false

func handle_click():
	$"../../".reset()
	pass

func _input(event):
	if event is InputEventMouseButton and is_in and get_parent().visible and event.pressed:
		handle_click()
	elif event is InputEventMouseMotion:
		mouse_pos = event.position
		var s = scale * get_rect().size / 2
		is_in = position.x - s.x < mouse_pos.x and mouse_pos.x < position.x + s.x \
			and position.y - s.y < mouse_pos.y and mouse_pos.y < position.y + s.y

func _process(delta):
	frame = 1 if is_in else 0
