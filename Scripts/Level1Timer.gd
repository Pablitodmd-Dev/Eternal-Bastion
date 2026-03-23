extends CanvasLayer

@onready var level_timer = get_node("../LevelTimer")
@onready var time_label = $MarginContainer/PanelContainer/HBoxContainer/TimeLabel

func _process(_delta: float) -> void:
	if level_timer and not level_timer.is_stopped():
		update_timer_display(level_timer.time_left)

func update_timer_display(time_remaining: float) -> void:
	var minutes = int(time_remaining) / 60
	var seconds = int(time_remaining) % 60
	
	time_label.text = "%02d:%02d" % [minutes, seconds]
