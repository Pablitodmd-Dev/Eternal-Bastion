extends Area2D

@export var speed: float = 400.0
var damage: float = 15
var direction: Vector2 = Vector2.RIGHT

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	await get_tree().create_timer(1.5).timeout
	queue_free()

func setup_projectile(dm: float, dir: Vector2):
	damage = dm
	direction = dir.normalized()
	
	rotation = direction.angle()
	
	if anim:
		anim.play("fly")

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies") and area.has_method("take_damage"):
		area.take_damage(damage)
		
		print("Slash hit enemy!")
		
		queue_free()
