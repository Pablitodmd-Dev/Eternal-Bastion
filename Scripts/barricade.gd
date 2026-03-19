extends Area2D

@export var max_health: float = 150.0
@export var contact_damage: float = 10.0
var current_health: float

@onready var health_bar: TextureProgressBar = $TextureProgressBar
@onready var smoke_particles = $SmokeParticles 
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("allies") 
	
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	area_entered.connect(_on_area_entered)
	
	if anim.sprite_frames.has_animation("default"):
		anim.play("default")
	
	if smoke_particles:
		smoke_particles.emitting = false

func take_damage(amount: float) -> void:
	current_health -= amount
	health_bar.value = current_health
	
	var health_percentage = (current_health / max_health) * 100.0
	
	if health_percentage <= 30.0 and smoke_particles:
		if not smoke_particles.emitting:
			smoke_particles.emitting = true
	
	if current_health <= 0:
		die()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies") and area.has_method("take_damage"):
		area.take_damage(contact_damage)

func die() -> void:
	var overlapping_areas = get_overlapping_areas()
	
	for area in overlapping_areas:
		if area.is_in_group("enemies") and area.has_method("resume_movement"):
			area.resume_movement()
	
	print("Barrera rota, enemigos avisados.")
	queue_free()
