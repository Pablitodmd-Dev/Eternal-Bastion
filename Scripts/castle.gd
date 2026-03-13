extends Area2D 

@export var health: int = 100
@onready var health_bar = $TextureProgressBar

func _ready():
	health_bar.max_value = health
	health_bar.value = health

func take_damage(amount: int):
	health -= amount
	health_bar.value = health
	modulate = Color(1, 0.5, 0.5) 
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1)

	if health <= 0:
		die()

func die():
	print("¡El castillo ha sido destruido!")
