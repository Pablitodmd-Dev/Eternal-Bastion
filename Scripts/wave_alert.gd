extends CanvasLayer

func _ready() -> void:
	$AnimationPlayer.play("mostrar_anuncio")
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_anim_name: String) -> void:
	queue_free() 
