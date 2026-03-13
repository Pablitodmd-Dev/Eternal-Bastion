extends Node2D

@export var health: int = 100
@export var damage: int = 5
@export var speed: float = 50.0
@export var attack_speed: float = 2

var target_castle = null
var is_attacking: bool = false
var movement_tween: Tween
var attack_timer: float = 0.0

@onready var sprite = $AnimatedSprite2D

func _process(delta: float) -> void:
	if is_attacking:
		if sprite.animation != "Attack":
			sprite.play("Attack")
		
		attack_timer += delta
		if attack_timer >= attack_speed:
			perform_attack_logic()
			attack_timer = 0.0
	else:
		if sprite.animation != "Walk":
			sprite.play("Walk")

func perform_attack_logic() -> void:
	if target_castle and target_castle.has_method("take_damage"):
		target_castle.take_damage(damage)

func stop_and_attack(area: Area2D) -> void:
	if not is_attacking:
		is_attacking = true
		target_castle = area
		attack_timer = attack_speed
		if movement_tween:
			movement_tween.kill()

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Castle"):
		stop_and_attack(area)
