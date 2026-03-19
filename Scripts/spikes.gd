extends Area2D

@export var damage: float = 5.0
@export var damage_interval: float = 1.5

@onready var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.wait_time = damage_interval
	timer.timeout.connect(_on_damage_tick)
	timer.start()

func _on_damage_tick() -> void:
	var overlapping_areas = get_overlapping_areas()

	for area in overlapping_areas:
		if area.is_in_group("enemies") and area.has_method("take_damage"):
			area.take_damage(damage)
			print("Daño continuo a: ", area.name)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies") and area.has_method("take_damage"):
		area.take_damage(damage)
