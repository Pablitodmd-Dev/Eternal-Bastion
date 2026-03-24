extends Area2D

var is_occupied: bool = false 

func can_build_here() -> bool:
	return !is_occupied
