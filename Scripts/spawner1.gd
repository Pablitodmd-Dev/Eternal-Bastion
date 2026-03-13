extends Node2D

@export var monster_scene: PackedScene
@onready var path = get_node_or_null("../Path2D") # Usamos or_null para evitar el crash

func _on_timer_timeout() -> void:
	if not monster_scene: return
	
	# Creamos el monstruo
	var monster = monster_scene.instantiate()
	
	# ¿Hay camino y tiene longitud?
	if path and path.curve.get_baked_length() > 0:
		# Si hay camino, usamos el seguidor
		var new_follower = PathFollow2D.new()
		new_follower.loop = false
		path.add_child(new_follower)
		new_follower.add_child(monster)
		
		# Lo movemos con un Tween
		var tween = create_tween()
		tween.tween_property(new_follower, "progress_ratio", 1.0, 4.0)
		tween.finished.connect(new_follower.queue_free)
		print("Caminando por el Path...")
	else:
		# Si NO hay camino, solo lo spawneamos aquí para que no de error
		add_child(monster)
		monster.position = Vector2.ZERO
		print("No encontré el Path, spawneo estático.")
	
	monster.z_index = 10
