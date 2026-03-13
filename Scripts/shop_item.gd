extends PanelContainer

func _ready() -> void:
	pivot_offset = size / 2

func _on_mouse_entered() -> void:
	z_index = 1
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	modulate = Color(1.1, 1.1, 1.1)

func _on_mouse_exited() -> void:
	z_index = 0
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_QUAD)
	modulate = Color(1, 1, 1)
