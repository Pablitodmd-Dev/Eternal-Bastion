extends Area2D

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
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Castle"):
		is_attacking = true
		target_castle = area
		attack_timer = attack_speed
		
		if movement_tween:
			movement_tween.kill()
