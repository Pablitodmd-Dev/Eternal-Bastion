extends Node2D

@export var monster_scene: PackedScene
@onready var path = get_node_or_null("../Path2D")

func _on_timer_timeout() -> void:
	if not monster_scene: return
	spawn_monster()

func spawn_monster() -> void:
	var monster = monster_scene.instantiate()
	
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
