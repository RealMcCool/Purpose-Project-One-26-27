extends Control


#var scores : Dictionary


func _ready() -> void:
	for i in get_tree().get_nodes_in_group("goal"):
		if i.has_signal("goal_reached"):
			i.goal_reached.connect(_on_goal_reached)


func _on_goal_reached(_next_level : String) -> void:
	%AnimationPlayer.play("screen_transition_enter")
	await %AnimationPlayer.animation_finished
	%AnimationPlayer.play("screen_transition_exit")
