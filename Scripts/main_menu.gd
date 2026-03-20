extends CanvasLayer

var tutorial_scene_path = "res://Scenes/tutorial.tscn" 

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(tutorial_scene_path)

func _on_options_button_pressed() -> void:
	print("Abriendo opciones...")
