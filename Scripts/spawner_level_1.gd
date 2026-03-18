extends Node2D

@export var monster_scenes: Array[PackedScene] = []
@onready var path = get_node_or_null("../Path2D")
@onready var spawn_sound = $AudioStreamPlayer2D

func _on_timer_timeout() -> void:
	if monster_scenes.is_empty(): return
	spawn_monster()

func spawn_monster() -> void:
	var random_index = randi() % monster_scenes.size()
	var selected_scene = monster_scenes[random_index]
	
	if not selected_scene: return
	
	var monster = selected_scene.instantiate()
	
	if spawn_sound:
		spawn_sound.play()
	
	if path and path.curve.get_baked_length() > 0:
		var new_follower = PathFollow2D.new()
		new_follower.loop = false
		path.add_child(new_follower)
		new_follower.add_child(monster)
		
		if monster is Node2D:
			monster.position = Vector2.ZERO
		
		new_follower.z_index = 10
		
		var travel_time = path.curve.get_baked_length() / monster.speed
		
		var tween = create_tween()
		tween.tween_property(new_follower, "progress_ratio", 1.0, travel_time)
		
		monster.movement_tween = tween
	else:
		add_child(monster)
		monster.position = Vector2.ZERO
