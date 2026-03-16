extends Area2D

@export var mana_cost: float = 20.0
@export var damage: float = 2000.0

@onready var anim = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

var can_damage = false

func cast_lightning(mana_manager):
	if mana_manager.current_mana >= mana_cost:
		mana_manager.use_mana(mana_cost)
		execute_spell()
	else:
		print("Not enough mana")

func execute_spell():
	anim.play("strike")
	collision.disabled = false
	
	await get_tree().create_timer(0.2).timeout
	
	collision.disabled = true
	
func _on_body_entered(body):
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
