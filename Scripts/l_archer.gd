extends Area2D

var damage: float = 0
var attack_range: float = 0
var attack_rate: float = 0
@export var arrow_scene: PackedScene


@onready var timer: Timer = $AttackTimer
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var range_shape: CollisionShape2D = $CollisionShape2D

var target: Node2D = null
var is_attacking: bool = false
@export var rotation_speed: float = 15.0

func setup_unit(data: Dictionary):
	damage = data["damage"]
	attack_range = data["range"]
	attack_rate = data["attack_rate"]
	
	if range_shape.shape is CircleShape2D:
		range_shape.shape.radius = attack_range
	
	timer.wait_time = 1.0 / attack_rate
	timer.start()

func _physics_process(_delta: float) -> void:
	if not _is_target_valid():
		target = _get_nearest_enemy()
	
	if target and _is_target_valid():
		var direction = (target.global_position - global_position).normalized()
		
		
		if direction.x < 0:
			anim.flip_h = true 
		else:
			anim.flip_h = false 
			
		is_attacking = true
	else:
		is_attacking = false
		anim.flip_h = false

	_update_animations()

func _is_target_valid() -> bool:
	return is_instance_valid(target) and target.is_inside_tree()

func _get_nearest_enemy() -> Node2D:
	var enemies = get_overlapping_areas()
	var nearest = null
	var min_dist = attack_range + 10.0 
	
	for e in enemies:
		if e.is_in_group("enemies") and e.has_method("take_damage"):
			var dist = global_position.distance_to(e.global_position)
			if dist < min_dist:
				min_dist = dist
				nearest = e
	return nearest

func _update_animations():
	if target and _is_target_valid():
		if anim.animation != "attack":
			anim.play("attack")
	else:
		if anim.animation != "idle":
			anim.play("idle")

func _on_attack_timer_timeout() -> void:
	if target and _is_target_valid() and is_attacking:
		disparar_flecha()

func disparar_flecha():
	if not arrow_scene:
		push_error("¡Falta asignar arrow_scene en el editor!")
		return
		
	var arrow = arrow_scene.instantiate()
	var arrow_offset = Vector2(10, -10)
	
	if anim.flip_h:
		arrow_offset.x = -25
		
	arrow.global_position = global_position + arrow_offset
	
	if is_instance_valid(target):
		arrow.setup_arrow(damage, target)
	
	get_parent().add_child(arrow)
