extends Area2D

@export var damage: float = 15.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	anim.animation_finished.connect(queue_free)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies") and area.has_method("take_damage"):
		area.take_damage(damage)
		print("¡Spike impacted: ", area.name, "!")
