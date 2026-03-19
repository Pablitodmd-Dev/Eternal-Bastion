extends Area2D

@export var speed: float = 600.0 

var damage: float = 0
var target: Node2D = null
var direction: Vector2 = Vector2.RIGHT

func setup_arrow(dmg: float, target_node: Node2D):
	damage = dmg
	target = target_node
	
	if is_instance_valid(target):
		direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()

func _physics_process(delta: float) -> void:
	if is_instance_valid(target) and target.is_inside_tree():
		direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()
	
	global_position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies") and area.has_method("take_damage"):
		area.take_damage(damage)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
