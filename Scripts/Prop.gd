extends "res://Scripts/Building.gd"
class_name Prop

export var cost: int = 0


func set_z():
	var pos = grid_pos()
	var fx = floor(pos.x)
	var fy = floor(pos.y)
	z_index = (fx + 0.8 * fy + 0.2 * (pos.y)) + 0.1
