extends Control


#var scores : Dictionary


func _ready() -> void:
	connect_goal_signal()


func _on_goal_reached(_next_level : String) -> void:
	for i in get_tree().get_nodes_in_group("player"):
		if i is Player:
			i.can_move = false
	%AnimationPlayer.play("screen_transition_enter")
	await %AnimationPlayer.animation_finished
	
	#This is the period of time where the screen is black; more can be done here (displaying stats, etc.)
	
	%AnimationPlayer.play("screen_transition_exit")
	await %AnimationPlayer.animation_finished
	for i in get_tree().get_nodes_in_group("player"):
		if i is Player:
			i.can_move = true
	connect_goal_signal()

func connect_goal_signal() -> void:
	for i in get_tree().get_nodes_in_group("goal"):
		if i.has_signal("goal_reached"):
			if not i.goal_reached.is_connected(_on_goal_reached):
				i.goal_reached.connect(_on_goal_reached)
