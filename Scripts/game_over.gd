extends CanvasLayer

func _on_texture_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

func _on_texture_button_2_pressed() -> void:
	get_tree().paused = false 
	if GameManager.current_level_path != "":
		get_tree().change_scene_to_file(GameManager.current_level_path)
	else:
		get_tree().reload_current_scene()
