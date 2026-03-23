extends Node

var coins: int = 0
var mana: float = 50.0
var max_mana: float = 100.0
var current_level_path: String = ""

func reset_level():
	coins = 100
	mana = 50.0

var current_level_index = 0
var level_sequence = [
	"res://scenes/tutorial.tscn",
	"res://scenes/level1.tscn",
	"res://scenes/level2.tscn"
]

func go_to_next_level():
	current_level_index += 1
	
	if current_level_index < level_sequence.size():
		get_tree().change_scene_to_file(level_sequence[current_level_index])
	else:
		print("¡Juego completado!")
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
