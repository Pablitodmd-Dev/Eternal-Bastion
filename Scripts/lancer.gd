extends Area2D

var damage: float = 0
var attack_range: float = 0
var attack_rate: float = 0

@onready var timer: Timer = $AttackTimer
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var range_shape: CollisionShape2D = $CollisionShape2D

var current_target: Node2D = null
var is_ready_to_attack: bool = false

func setup_unit(data: Dictionary):
	damage = data["damage"]
	attack_range = data["range"]
	attack_rate = data["attack_rate"]
	
	if range_shape.shape is CircleShape2D:
		range_shape.shape.radius = attack_range
	
	timer.wait_time = 1.0 / attack_rate
	timer.start()
	
	if has_node("RangeIndicator"):
		$RangeIndicator.update_radius(attack_range)

func _physics_process(_delta: float) -> void:
	if not _is_target_valid() or _is_target_out_of_range():
		current_target = _get_nearest_enemy()
	
	if current_target and _is_target_valid():
		var dir_x = current_target.global_position.x - global_position.x
		anim.flip_h = dir_x < 0
		
		if anim.animation != "attack":
			anim.play("attack")
		is_ready_to_attack = true
	else:
		if anim.animation != "idle":
			anim.play("idle")
		is_ready_to_attack = false

func _is_target_valid() -> bool:
	return is_instance_valid(current_target) and current_target.is_inside_tree()

func _is_target_out_of_range() -> bool:
	if current_target:
		var distance = global_position.distance_to(current_target.global_position)
		return distance > (attack_range + 5.0)
	return true

func _get_nearest_enemy() -> Node2D:
	var enemies = get_overlapping_areas()
	var nearest = null
	var min_dist = attack_range + 10.0 
	
	for enemy in enemies:
		if enemy.is_in_group("enemies") and enemy.has_method("take_damage"):
			var dist = global_position.distance_to(enemy.global_position)
			if dist < min_dist:
				min_dist = dist
				nearest = enemy
	return nearest

func _on_attack_timer_timeout() -> void:
	if current_target and _is_target_valid() and is_ready_to_attack:
		current_target.take_damage(damage)
		print("Stabbed: ", current_target.name)
