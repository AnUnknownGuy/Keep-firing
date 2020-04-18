extends Node2D


var entities_dictionnary = {}


func declare_at_pos(entity: Entity, pos: Vector2):
	if entities_dictionnary[pos] == null:
		entities_dictionnary[pos] = [entity]
	else:
		entities_dictionnary[pos].append(entity)

func change_pos_of(entity: Entity, old_pos: Vector2, new_pos: Vector2):
	entities_dictionnary[old_pos].erase(entity)
	declare_at_pos(entity, new_pos)

func get_entitites_at(pos: Vector2):
	return entities_dictionnary[pos]

func add_heat_at(pos: Vector2, heat: int):
	var entities = get_entitites_at(pos)
	if (entities != null):
		for entity in entities:
			entity.heat_up(heat)
