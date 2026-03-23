extends Node2D

@export var monster_scenes: Array[PackedScene] = []
@export var monster_final_boss: PackedScene 

@onready var level_timer = get_node("../LevelTimer") 
@onready var path = get_node_or_null("../Path2D")
@onready var spawn_sound = $AudioStreamPlayer2D

var monster4_spawned: bool = false # Control para que solo salga UNA vez

func _process(_delta: float) -> void:
	if not level_timer or level_timer.is_stopped():
		return

	# 1. Control del Jefe Final (Aparece una sola vez al minuto 1)
	if level_timer.time_left <= 60.0 and not monster4_spawned:
		spawn_specific_monster(monster_final_boss)
		monster4_spawned = true
		print("¡EL JEFE HA APARECIDO!")

func _on_timer_timeout() -> void:
	if level_timer and level_timer.time_left <= 0:
		return
		
	if monster_scenes.is_empty(): return
	
	spawn_monster()

func spawn_monster() -> void:
	var random_index = randi() % monster_scenes.size()
	spawn_specific_monster(monster_scenes[random_index])

func spawn_specific_monster(selected_scene: PackedScene) -> void:
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
