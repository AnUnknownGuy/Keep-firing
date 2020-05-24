extends Building



func intern_transfer(vec: Vector2, heat_to_transfer: float):
	var building_next_to = buildings.get_building_at(grid_pos() + vec)
	if building_next_to != null:
		building_next_to.cool(heat_to_transfer)
	
	var prop_next_to = props.get_building_at(grid_pos() + vec)
	if prop_next_to != null:
		prop_next_to.cool(heat_to_transfer)
	
	var entities_next_to = entities.get_entities_at(grid_pos() + vec)
	if entities_next_to != null:
		for entity in entities_next_to:
			entity.cool(heat_to_transfer)
