extends Control


func _on_continue_button_pressed() -> void:
	%AnimationPlayer.play("continue")
	await %AnimationPlayer.animation_finished
	get_root_node().change_menu_state(Root.MenuState.LEVEL)
	get_root_node().switch_levels(get_root_node().save_data.available_levels[-1]) 


func _on_level_select_menu_button_pressed() -> void:
	%AnimationPlayer.play("levelselect")
	await %AnimationPlayer.animation_finished
	get_root_node().change_menu_state(Root.MenuState.LEVEL_SELECT_SCREEN)


func _on_quit_button_pressed() -> void:
	%AnimationPlayer.play("quit")
	await %AnimationPlayer.animation_finished
	get_tree().quit()


func get_root_node() -> Root:
	for i in get_tree().get_nodes_in_group("root"):
		if i is Root:
			return i
	return null
