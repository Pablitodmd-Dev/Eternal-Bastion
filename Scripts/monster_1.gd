extends Area2D

@export var spawn_audio: AudioStream 
@export var health: float = 100.0
@export var damage: float = 5.0
@export var speed: float = 50.0
@export var attack_speed: float = 2.0

var target_castle: Area2D = null
var is_attacking: bool = false
var attack_timer: float = 0.0
var movement_tween: Tween 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: TextureProgressBar = $HealthBar
@export var coin_value: int = 15

func _ready() -> void:
	health_bar.max_value = health
	health_bar.value = health

func _process(delta: float) -> void:
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
	
	if health <= 0:
		GameManager.coins += coin_value
		queue_free()

func resume_movement():
	is_attacking = false
	target_castle = null
	
	var main_path = get_parent()
	if main_path is PathFollow2D:
		var distance_left = 1.0 - main_path.progress_ratio
		var duration = distance_left * 20.0
		
		movement_tween = create_tween()
		movement_tween.tween_property(main_path, "progress_ratio", 1.0, duration)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Castle") or area.is_in_group("allies"):
		is_attacking = true
		target_castle = area
		attack_timer = attack_speed
		
		if movement_tween:
			movement_tween.kill()
