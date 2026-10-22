class_name Root extends Node


enum MenuState {LEVEL, TITLE_SCREEN, LEVEL_SELECT_SCREEN}

@export_global_dir var save_data_path := "user://save_data.tres"
@export var save_data : SaveData

func save_save_data() -> void:
		ResourceSaver.save(save_data, save_data_path)


func load_save_data() -> void:
	#print("loading")
	save_data = ResourceLoader.load(save_data_path)
	if save_data == null:
		save_data = load("res://resources/default_save_data.tres")
	%LevelSelectScreen.unlocked_levels = save_data.available_levels
	#print("loaded")


func _ready() -> void:
	#connect_goal_signal()
	change_menu_state(MenuState.TITLE_SCREEN, false)
	#change_menu_state(MenuState.LEVEL_SELECT_SCREEN)
	#change_menu_state(MenuState.LEVEL)
	load_save_data()



func _on_goal_reached(next_level : String) -> void:
	%Level.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	await %GUI.get_node("%AnimationPlayer").animation_finished
	call_deferred("switch_levels",next_level)
	%Level.set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)


func switch_levels(new_level : String) -> void:
	
	if not save_data.available_levels.has(new_level): #not save_data == null and 
		save_data.available_levels.append(new_level)
		save_save_data()
	
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
	%GUI.connect_goal_signal()


func change_menu_state(new_state : MenuState, with_transition := true) -> void:
	if with_transition:
		%GUI.get_node("%AnimationPlayer").play("screen_transition_enter")
		await %GUI.get_node("%AnimationPlayer").animation_finished
	for i in get_tree().get_nodes_in_group("menu_type"):
		if not i is GUI:
			i.process_mode = Node.PROCESS_MODE_DISABLED
			if i is Control:
				i.hide()
	match new_state:
		MenuState.LEVEL:
			#%GUI.process_mode = Node.PROCESS_MODE_INHERIT
			#%GUI.show()
			connect_goal_signal()
			if with_transition:
				%GUI.get_node("%AnimationPlayer").play("screen_transition_exit")
				await %GUI.get_node("%AnimationPlayer").animation_finished
			for i in get_tree().get_nodes_in_group("player"):
				if i is Player:
					i.can_move = true
			%Level.process_mode = Node.PROCESS_MODE_INHERIT
		MenuState.TITLE_SCREEN:
			%TitleScreen.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			if with_transition:
				%GUI.get_node("%AnimationPlayer").play("screen_transition_exit")
				await %GUI.get_node("%AnimationPlayer").animation_finished
			%TitleScreen.process_mode = Node.PROCESS_MODE_INHERIT
		MenuState.LEVEL_SELECT_SCREEN:
			#%GUI.get_node("%AnimationPlayer").play("screen_transition_enter")
			#await %GUI.get_node("%AnimationPlayer").animation_finished
			load_save_data()
			%LevelSelectScreen.set_level_availability()
			%LevelSelectScreen.show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			%LevelSelectScreen.level_select_buttons[0].grab_focus()
			if with_transition:
				%GUI.get_node("%AnimationPlayer").play("screen_transition_exit")
				await %GUI.get_node("%AnimationPlayer").animation_finished
			%LevelSelectScreen.process_mode = Node.PROCESS_MODE_INHERIT



static func get_root_node(node_array:Array[Node]) -> Root:
	for i in node_array:
		if i is Root:
			return i
	return null
