extends Node2D

@export var monster_scene: PackedScene
@export var wave_scene: PackedScene 

@onready var path = get_node_or_null("../Path2D")
@onready var spawn_sound = $AudioStreamPlayer2D
@onready var level_timer = get_node("../LevelTimer") 

var wave_3_done: bool = false
var wave_2_done: bool = false
var wave_1_done: bool = false 

func _process(_delta: float) -> void:
	if not level_timer or level_timer.is_stopped():
		return
	
	var time_left = level_timer.time_left
	
	if time_left <= 180.0 and not wave_3_done:
		mostrar_alerta_visual()
		spawn_special_wave(5, 6) 
		wave_3_done = true

	if time_left <= 120.0 and not wave_2_done:
		mostrar_alerta_visual()
		spawn_special_wave(6, 7)
		wave_2_done = true

	if time_left <= 60.0 and not wave_1_done:
		mostrar_alerta_visual()
		spawn_special_wave(8, 10)
		wave_1_done = true

func _on_timer_timeout() -> void:
	if level_timer and level_timer.time_left <= 0:
		return
		
	if not monster_scene: return
	spawn_monster()

func mostrar_alerta_visual() -> void:
	if wave_scene:
		var anuncio = wave_scene.instantiate()
		get_tree().root.add_child(anuncio)

func spawn_special_wave(min_enemies: int, max_enemies: int) -> void:
	var amount = randi_range(min_enemies, max_enemies)
	for i in range(amount):
		spawn_monster()
		await get_tree().create_timer(0.4).timeout

func spawn_monster() -> void:
	var monster = monster_scene.instantiate()
	
	if spawn_sound:
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
