extends Node2D

var mana: float = 50.0
var max_mana: float = 100.0
var mana_regeneration_rate: float = 2.5
@onready var mana_label: Label = $CanvasLayer/ManaLabel

func _process(delta):
	if mana < max_mana:
		mana += mana_regeneration_rate * delta
		mana = clamp(mana, 0, max_mana)
		mana_label.text = "Mana: " + str(int(mana))

func can_cast_spell(cost: float) -> bool:
	return mana >= cost

func consume_mana(amount: float):
	mana -= amount
