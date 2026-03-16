extends Node2D

var mana: float = 50.0
var max_mana: float = 100.0
var mana_regeneration_rate: float = 2.5

@onready var mana_label: Label = $ItemShop/PanelContainer/VBoxContainer/FilaMana/ManaLabel
@onready var shop = $ItemShop

var current_pending_item = null
var scene_cache: Dictionary = {}

func _ready() -> void:
	if shop.has_signal("item_selected"):
		shop.item_selected.connect(_on_item_selected_from_shop)

func _process(delta: float) -> void:
	if mana < max_mana:
		mana += mana_regeneration_rate * delta
		mana = clamp(mana, 0.0, max_mana)
		mana_label.text = "Mana: " + str(int(mana))

func _on_item_selected_from_shop(item_data) -> void:
	print("¡Señal recibida! Datos: ", item_data)
	current_pending_item = item_data
	
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)

func _unhandled_input(event: InputEvent) -> void:
	if current_pending_item == null: 
		return
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			cancel_placement()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			var cost = float(current_pending_item["cost"])
			if mana >= cost:
				spawn_item(get_global_mouse_position())
				mana -= cost
				if current_pending_item["type"] == "spell":
					cancel_placement()
			else:
				print("Sin maná: Necesitas ", cost, " y tienes ", int(mana))
				cancel_placement()

func spawn_item(pos: Vector2) -> void:
	var path = current_pending_item["scene_path"]
	
	if not scene_cache.has(path):
		scene_cache[path] = load(path)
		
	var instance = scene_cache[path].instantiate()
	
	if current_pending_item["type"] == "structure":
		instance.position = (pos / 64).floor() * 64 + Vector2(32, 32)
	else:
		instance.position = pos
		
	add_child(instance)

func cancel_placement() -> void:
	current_pending_item = null
	
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
