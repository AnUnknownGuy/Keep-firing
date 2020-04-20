extends TileMap
tool

export (int) var number = 0 setget set_number
export (int, "Left", "Center", "Right") var align = 0 setget set_align

func digit_count(n):
	return floor(log(n) / log(10)) + 1 if n != 0 else 1

func set_align(a):
	align = a
	var size = -8 * digit_count(number) + 2
	var v
	if a == 0:
		v = Vector2.ZERO
	elif a == 1:
		v = Vector2(size/2, 0)
	else:
		v = Vector2(size, 0)
	
	cell_custom_transform = Transform2D(Vector2.ZERO, Vector2.ZERO, v)

func set_number(num):
	number = num
	
	clear()
	
	if num == 0:
		set_cell(0, 0, 0)
	else:
		var digits = []
		for i in range(digit_count(num)):
			digits.push_front(num % 10)
			num /= 10
		
		var i = 0
		for d in digits:
			set_cell(i, 0, d)
			i += 1
	
	set_align(align)
