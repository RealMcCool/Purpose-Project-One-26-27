extends Area3D



func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		var spawn_position : SpawnPosition = get_parent().get_node("%SpawnPosition")
		body.velocity = Vector3.ZERO
		body.position = spawn_position.position
		body.reset_camera(spawn_position.look_direction)
