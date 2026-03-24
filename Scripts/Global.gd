extends Node

var coins: int = 0
var mana: float = 50.0
var max_mana: float = 100.0
var current_level_path: String = ""

func reset_level():
	coins = 100
	mana = 50.0

var level_sequence: Array = [
	"res://Scenes/tutorial.tscn",
	"res://Scenes/level1.tscn",
	"res://Scenes/level2.tscn"
]

var current_level_index: int = 0

func update_current_index(path: String) -> void:
	var index = level_sequence.find(path)
	if index != -1:
		current_level_index = index
	else:
		return

func is_last_level() -> bool:
	return current_level_index >= level_sequence.size() - 1

func go_to_next_level() -> void:
	var next_index = current_level_index + 1
	if next_index < level_sequence.size():
		get_tree().change_scene_to_file(level_sequence[next_index])
