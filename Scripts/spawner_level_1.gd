extends Node2D

@export var monster_scenes: Array[PackedScene] = []
@onready var path = get_node_or_null("../Path2D")
@onready var spawn_sound = $AudioStreamPlayer2D
@onready var level_timer = get_node("../LevelTimer") 

var final_wave_done: bool = false

func _process(_delta: float) -> void:
	if not level_timer or level_timer.is_stopped():
		return
	
	if level_timer.time_left <= 60.0 and not final_wave_done:
		spawn_final_wave()
		final_wave_done = true

func _on_timer_timeout() -> void:
	if level_timer and level_timer.time_left <= 0:
		return
		
	if monster_scenes.is_empty(): return
	spawn_monster()

func spawn_final_wave() -> void:
	var amount = randi_range(7, 8)
	for i in range(amount):
		spawn_monster()
		await get_tree().create_timer(0.5).timeout

func spawn_monster() -> void:
	var random_index = randi() % monster_scenes.size()
	var selected_scene = monster_scenes[random_index]
	
	if not selected_scene: return
	
	var monster = selected_scene.instantiate()
	
	if spawn_sound:
		if "spawn_audio" in monster and monster.spawn_audio != null:
			spawn_sound.stream = monster.spawn_audio
		spawn_sound.play()
	
	if path and path.curve.get_baked_length() > 0:
		var new_follower = PathFollow2D.new()
		new_follower.loop = false
		new_follower.rotates = false
		
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
