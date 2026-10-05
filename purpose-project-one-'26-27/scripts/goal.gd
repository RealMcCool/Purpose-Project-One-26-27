extends Area3D


signal goal_reached


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		goal_reached.emit()
		#print("Yay")


func _physics_process(delta: float) -> void:
	%Mesh.rotate(Vector3(0,0,1), PI*delta)
	%Mesh.rotate(Vector3(0,1,0), PI*delta)
	%Mesh.rotate(Vector3(1,0,0), PI*delta)
