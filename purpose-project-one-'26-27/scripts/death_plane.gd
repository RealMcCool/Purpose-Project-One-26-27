extends Area3D



func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		var spawn_position : SpawnPosition = get_parent().get_node("%SpawnPosition")
		body.velocity = Vector3.ZERO
		body.can_move = false
		var animation_player = get_tree().get_first_node_in_group("gui").get_node("%AnimationPlayer")
		animation_player.play("screen_transition_enter")
		await animation_player.animation_finished
		body.position = spawn_position.position
		body.reset_camera(spawn_position.look_direction)
		animation_player.play("screen_transition_exit")
		await animation_player.animation_finished
		body.can_move = true
