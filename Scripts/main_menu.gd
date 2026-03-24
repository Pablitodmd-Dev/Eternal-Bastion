extends CanvasLayer

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/tutorial.tscn" )

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/options.tscn")
