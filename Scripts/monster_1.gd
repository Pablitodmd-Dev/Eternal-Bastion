extends Node2D

@export var health: int = 100
@export var damage: int = 10
@export var speed: float = 50.0

var target_castle = null
var is_attacking: bool = false
var movement_tween: Tween

@onready var sprite = $AnimatedSprite2D

func _process(_delta: float) -> void:
	# Lógica de animaciones basada en el estado
	if is_attacking:
		if sprite.animation != "Attack":
			sprite.play("Attack")
		perform_attack_logic()
	else:
		if sprite.animation != "Walk":
			sprite.play("Walk")

func perform_attack_logic() -> void:
	# Aquí irá el daño al castillo más adelante
	pass

func stop_and_attack(area: Area2D) -> void:
	if not is_attacking:
		is_attacking = true
		target_castle = area
		if movement_tween:
			movement_tween.kill()

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Castle"):
		stop_and_attack(area)
