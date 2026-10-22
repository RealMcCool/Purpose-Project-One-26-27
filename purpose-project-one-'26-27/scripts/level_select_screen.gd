extends Control


var level_select_buttons : Array[LevelSelectButton]
var unlocked_levels : Array[String] = ["uid://cref300uwmmwn"]


func _ready() -> void:
	fill_level_button_array()
	set_level_availability()


func _physics_process(delta: float) -> void:
	pass


func fill_level_button_array() -> void:
	for i in $VBoxContainer.get_children():
		for level in i.get_children():
			if level is LevelSelectButton:
				level_select_buttons.append(level)


func set_level_availability() -> void:
	for i in level_select_buttons:
		if unlocked_levels.has(i.level):
			i.disabled = false
		else:
			i.disabled = true
