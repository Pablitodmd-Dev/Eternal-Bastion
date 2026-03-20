extends Area2D

@export var spawn_audio: AudioStream 
@export var health: float = 350.0 
@export var damage: float = 15.0  
@export var speed: float = 30.0   
@export var attack_speed: float = 3.0 
@export var coin_value: int = 40 

var target_castle: Area2D = null
var is_attacking: bool = false
var attack_timer: float = 0.0
var movement_tween: Tween 
var last_x: float = 0.0

# Referencias actualizadas al contenedor Visuals
@onready var visuals: Node2D = $Visuals
@onready var sprite: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var health_bar: TextureProgressBar = $Visuals/HealthBar

func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health
	sprite.play("Walk")
	last_x = global_position.x

func _process(delta: float) -> void:
	# Lógica de volteo (Flip) usando el contenedor Visuals
	if not is_attacking:
		if global_position.x < last_x - 0.1: # Se mueve a la izquierda
			visuals.scale.x = -1 # Esto voltea al bicho Y a la barra
		elif global_position.x > last_x + 0.1: # Se mueve a la derecha
			visuals.scale.x = 1
		last_x = global_position.x

	if is_attacking:
		if sprite.animation != "Attack":
			sprite.play("Attack")
		
		attack_timer += delta
		if attack_timer >= attack_speed:
			perform_attack()
			attack_timer = 0.0
	else:
		if sprite.animation != "Walk":
			sprite.play("Walk")

func perform_attack() -> void:
	if target_castle and target_castle.has_method("take_damage"):
		target_castle.take_damage(damage)

func take_damage(amount: float) -> void:
	health -= amount
	health_bar.value = health
	
	var flash_tween = create_tween()
	sprite.modulate = Color(10, 10, 10) 
	flash_tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.1)
	
	if health <= 0:
		die()

func die() -> void:
	GameManager.coins += coin_value
	queue_free()

func resume_movement():
	is_attacking = false
	target_castle = null
	
	var main_path = get_parent()
	if main_path is PathFollow2D:
		var distance_left = 1.0 - main_path.progress_ratio
		var duration = (distance_left * 1000.0) / speed 
		
		movement_tween = create_tween()
		movement_tween.tween_property(main_path, "progress_ratio", 1.0, duration)
		last_x = global_position.x

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Castle") or area.is_in_group("allies"):
		is_attacking = true
		target_castle = area
		attack_timer = attack_speed
		
		if movement_tween:
			movement_tween.kill()
