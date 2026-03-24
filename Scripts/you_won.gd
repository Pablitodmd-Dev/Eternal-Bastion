extends CanvasLayer




func _on_texture_button_pressed() -> void:
	GameManager.go_to_next_level()

func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
