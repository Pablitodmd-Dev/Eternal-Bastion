extends CanvasLayer

@onready var time_label = $MarginContainer/PanelContainer/HBoxContainer/TimeLabel
@onready var level_timer = get_node("../LevelTimer")

var time_is_up: bool = false

func _process(_delta: float) -> void:
	if not time_is_up:
		update_ui()
	
	if time_is_up:
		check_final_victory()

func update_ui() -> void:
	var time_left = level_timer.time_left
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]

func check_final_victory() -> void:
	var enemies_remaining = get_tree().get_nodes_in_group("enemies")
	if enemies_remaining.size() == 0:
		show_win_screen()

func show_win_screen() -> void:
	get_tree().paused = false 
	
	get_tree().change_scene_to_file("res://scenes/you_won.tscn")

func _on_level_timer_timeout() -> void:
	time_is_up = true
	time_label.text = "00:00"
	print("¡Tiempo agotado! Limpia los enemigos restantes...")
