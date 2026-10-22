class_name LevelSelectButton extends Button

@export_file("*.tscn") var level : String

func _on_pressed() -> void:
	var root = get_tree().get_first_node_in_group("root")
	if root is Root:
		root.change_menu_state(Root.MenuState.LEVEL)
		root.call_deferred("switch_levels",level)
		#root.switch_levels(level)
