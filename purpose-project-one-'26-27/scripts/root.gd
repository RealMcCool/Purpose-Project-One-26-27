extends Node


func _ready() -> void:
	connect_goal_signal()


func _on_goal_reached(next_level : String) -> void:
	%Level.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	await %GUI.get_node("%AnimationPlayer").animation_finished
	switch_levels(next_level)
	%Level.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)


func switch_levels(new_level : String) -> void:
	for i in %Level.get_children():
		i.queue_free()
	var level_scene : PackedScene = load(new_level)
	var level : Node = level_scene.instantiate()
	%Level.add_child(level)
	connect_goal_signal()


func connect_goal_signal() -> void:
	for i in get_tree().get_nodes_in_group("goal"):
		if i is Goal:
			if not i.goal_reached.is_connected(_on_goal_reached):
				i.goal_reached.connect(_on_goal_reached)
