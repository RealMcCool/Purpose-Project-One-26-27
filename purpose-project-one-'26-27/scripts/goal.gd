class_name Goal extends Area3D

@export_file("*.tscn") var next_level : String
signal goal_reached(next_level : String)


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		
		#MAKE SURE TO SAVE/LOAD DATA?
		"""
	@export_global_dir var save_data_path := "user://save_data.tres"
	@export var save_data : SaveData
	
	func save() -> void:
		ResourceSaver.save(save_data, save_data_path)
	
	func load() -> void:
		#print("loading")
		inventory = ResourceLoader.load(inventory_path)
		stats = ResourceLoader.load(stats_path)
		if inventory == null:
			inventory = load("res://assets/default_inventory.tres")
		#print("loaded")
		"""
		
		
		goal_reached.emit(next_level)
		body.can_move = false


func _physics_process(delta: float) -> void:
	%Mesh.rotate(Vector3(0,0,1), PI*delta)
	%Mesh.rotate(Vector3(0,1,0), PI*delta)
	%Mesh.rotate(Vector3(1,0,0), PI*delta)
