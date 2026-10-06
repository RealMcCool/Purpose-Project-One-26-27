extends Node


func _ready() -> void:
	for i in get_tree().get_nodes_in_group("goal"):
		if i.has_signal("goal_reached"):
			i.goal_reached.connect(_on_goal_reached)


func _on_goal_reached(_next_level : String) -> void:
	print(_next_level)
	switch_levels(_next_level)


func switch_levels(new_level : String) -> void:
	for i in %Level.get_children():
		i.queue_free()
	var level_scene : PackedScene = load(new_level)
	var level : Node = level_scene.instantiate()
	%Level.add_child(level)
