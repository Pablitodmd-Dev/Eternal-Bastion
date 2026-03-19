extends Node2D

var radius: float = 0
var color: Color = Color(1, 1, 1, 0.2)
func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)
	draw_arc(Vector2.ZERO, radius, 0, TAU, 32, Color(1, 1, 1, 0.5), 1.0)

func update_radius(new_radius: float):
	radius = new_radius
	queue_redraw()
