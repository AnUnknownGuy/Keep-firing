extends TileMap

func is_road(pos: Vector2) -> bool:
	return get_cellv(pos) != -1
