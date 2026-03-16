extends Node2D

var mana: float = 50.0
var max_mana: float = 100.0
var mana_regeneration_rate: float = 2.5

@onready var mana_label: Label = $ItemShop/PanelContainer/VBoxContainer/FilaMana/ManaLabel
@onready var shop = $ItemShop

var current_pending_item = null
var ghost_sprite: Sprite2D = null

func _ready():
	if shop.has_signal("item_selected"):
		shop.item_selected.connect(_on_item_selected_from_shop)

func _process(delta):
	if mana < max_mana:
		mana += mana_regeneration_rate * delta
		mana = clamp(mana, 0, max_mana)
		mana_label.text = "Mana: " + str(int(mana))
	
	if ghost_sprite:
		var mouse_pos = get_global_mouse_position()
		if current_pending_item and current_pending_item["type"] == "structure":
			ghost_sprite.position = (mouse_pos / 64).floor() * 64 + Vector2(32, 32)
		else:
			ghost_sprite.position = mouse_pos

func _on_item_selected_from_shop(item_data):
	print("¡Señal recibida! Datos: ", item_data)
	current_pending_item = item_data
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	
	if ghost_sprite: ghost_sprite.queue_free()
	ghost_sprite = Sprite2D.new()
	ghost_sprite.texture = load("res://icon.svg") 
	ghost_sprite.modulate = Color(1, 1, 1, 0.5)
	add_child(ghost_sprite)

func _input(event):
	if current_pending_item == null: return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		cancel_placement()
		return

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# if shop.get_region_rect().has_point(event.position): return

		var cost = float(current_pending_item["cost"])
		if mana >= cost:
			spawn_item(get_global_mouse_position())
			mana -= cost
			if current_pending_item["type"] == "spell":
				cancel_placement()
		else:
			print("Sin maná: Necesitas ", cost, " y tienes ", int(mana))

func spawn_item(pos):
	var scene = load(current_pending_item["scene_path"])
	var instance = scene.instantiate()
	
	if current_pending_item["type"] == "structure":
		instance.position = (pos / 64).floor() * 64 + Vector2(32, 32)
	else:
		instance.position = pos
		
	add_child(instance)

func cancel_placement():
	current_pending_item = null
	if ghost_sprite:
		ghost_sprite.queue_free()
		ghost_sprite = null
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
