extends Node2D



func get_block_at(pos):
	for b in get_children():
		if (b.grid_pos() == pos):
			return b
	return null

func get_under_block(block: Building):
	for b in get_children():
		if (b.grid_pos() == block.grid_pos() && b != block):
			return b
	return null

