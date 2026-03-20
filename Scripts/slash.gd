extends Area2D

@export var speed: float = 400.0
var damage: float = 15
var direction: Vector2 = Vector2.RIGHT

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	print("¡He aparecido en la posición: ", global_position)
	await get_tree().create_timer(5).timeout
	queue_free()

func setup_projectile(dm: float, dir: Vector2):
	damage = dm
	direction = dir.normalized()
	rotation = direction.angle()
	
	#if anim == null:
	#	anim = $AnimatedSprite2D
	
	#anim.play("slash")

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies") and area.has_method("take_damage"):
		area.take_damage(damage)
		
		print("Slash hit enemy!")
		
		queue_free()
