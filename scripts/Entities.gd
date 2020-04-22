extends Node2D

var entities_dictionnary = {}

func _ready():
	for e in get_children():
		declare(e)
		e.post_init()

func declare(entity: Entity):
	var pos = entity.grid_pos().floor()
	if not pos in entities_dictionnary:
		entities_dictionnary[pos] = [entity]
	else:
		entities_dictionnary[pos].append(entity)

func remove(entity: Entity):
	entities_dictionnary[entity.grid_pos()].erase(entity)

func remove_all():
	entities_dictionnary.clear()

func change_pos_of(entity: Entity, old_pos: Vector2):
	entities_dictionnary[old_pos].erase(entity)
	declare(entity)

func get_entities_at(pos: Vector2):
	return entities_dictionnary.get(pos)

func add_heat_at(pos: Vector2, heat: int):
	var entities = get_entities_at(pos)
	if (entities != null):
		for entity in entities:
			entity.heat_up(heat)
