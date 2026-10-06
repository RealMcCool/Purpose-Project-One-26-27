extends Area3D

@export_file_path var next_level : String
signal goal_reached(next_level : String)


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		goal_reached.emit(next_level)
		body.can_move = false


func _physics_process(delta: float) -> void:
	%Mesh.rotate(Vector3(0,0,1), PI*delta)
	%Mesh.rotate(Vector3(0,1,0), PI*delta)
	%Mesh.rotate(Vector3(1,0,0), PI*delta)
