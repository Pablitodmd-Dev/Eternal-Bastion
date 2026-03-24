extends CanvasLayer

@onready var time_label = $MarginContainer/PanelContainer/HBoxContainer/TimeLabel
@onready var level_timer = get_node("../LevelTimer")

var time_is_up: bool = false
var win_triggered: bool = false

func _ready() -> void:
	GameManager.reset_level()
	
	var current_path = get_tree().current_scene.scene_file_path
	GameManager.update_current_index(current_path)
	
	if level_timer and not level_timer.timeout.is_connected(_on_timer_timeout):
		level_timer.timeout.connect(_on_timer_timeout)

func _process(_delta: float) -> void:
	if not time_is_up:
		update_ui()
	elif not win_triggered:
		check_final_victory()

func update_ui() -> void:
	var time_left = level_timer.time_left
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]

func _on_timer_timeout() -> void:
	time_is_up = true
	time_label.text = "00:00"

func check_final_victory() -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	if enemies.size() == 0:
		win_triggered = true
		show_win_screen()

func show_win_screen() -> void:
	get_tree().paused = false 
	
	if GameManager.is_last_level():
		get_tree().change_scene_to_file("res://Scenes/you_won_end.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/you_won.tscn")
