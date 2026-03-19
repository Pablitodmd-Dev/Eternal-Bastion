extends Area2D

@export var damage: float = 150.0
@onready var timer = $ExplosionTimer
@onready var particles = $CPUParticles2D
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	timer.timeout.connect(_on_explode)
	timer.start()
	
	var tween = create_tween().set_loops()
	tween.tween_property(sprite, "modulate", Color.RED, 0.2)
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.2)

func _on_explode() -> void:
	sprite.visible = false
	
	var targets = get_overlapping_areas()
	
	for area in targets:
		if area.is_in_group("enemies") and area.has_method("take_damage"):
			area.take_damage(damage)
			print("Bomba dañó a: ", area.name)
	
	if particles:
		particles.emitting = true

	await get_tree().create_timer(0.5).timeout
	queue_free()
