extends Node2D

var entities_dictionnary = {}

#var human_scene = preload("res://Scenes/Human.tscn")

func declare_at_pos(entity: Entity, pos: Vector2):
	if entities_dictionnary[pos] == null:
		entities_dictionnary[pos] = [entity]
	else:
		entities_dictionnary[pos].append(entity)

func change_pos_of(entity: Entity, old_pos: Vector2, new_pos: Vector2):
	entities_dictionnary[old_pos].erase(entity)
	declare_at_pos(entity, new_pos)

func get_entities_at(pos: Vector2):
	return entities_dictionnary.get(pos)

func add_heat_at(pos: Vector2, heat: int):
	var entities = get_entities_at(pos)
	if (entities != null):
		for entity in entities:
			entity.heat_up(heat)

#func _ready():
#	for i in range(50):
#		for j in range(50):
#			var human = human_scene.instance()
#			human.position = Vector2(i, j) * 10
#			add_child(human)
