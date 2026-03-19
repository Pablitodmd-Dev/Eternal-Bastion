extends CanvasLayer

@onready var time_label = $MarginContainer/PanelContainer/HBoxContainer/TimeLabel
@onready var level_timer = get_node("../LevelTimer")
@export var win_screen_scene: PackedScene

func _process(_delta: float) -> void:
	if not level_timer.is_stopped():
		update_ui()

func update_ui() -> void:
	var time_left = level_timer.time_left
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	time_label.text = "%02d:%02d" % [minutes, seconds]

func _on_timer_timeout() -> void:
	show_win_screen()

func show_win_screen() -> void:
	if win_screen_scene:
		var win_screen = win_screen_scene.instantiate()
		add_child(win_screen)
		get_tree().paused = true
