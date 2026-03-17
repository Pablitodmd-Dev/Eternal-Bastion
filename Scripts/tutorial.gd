extends Node2D

var mana: float = 50.0
var max_mana: float = 100.0
var mana_regeneration_rate: float = 2.5

@onready var mana_label: Label = $ItemShop/PanelContainer/VBoxContainer/FilaMana/ManaLabel
@onready var shop = $ItemShop

var current_pending_item = null
var scene_cache: Dictionary = {}
var preview_indicator: Polygon2D = null

func _ready() -> void:
	if shop.has_signal("item_selected"):
		shop.item_selected.connect(_on_item_selected_from_shop)

func _process(delta: float) -> void:
	if mana < max_mana:
		mana += mana_regeneration_rate * delta
		mana = clamp(mana, 0.0, max_mana)
		mana_label.text = "Mana: " + str(int(mana))
	
	update_preview()

func _on_item_selected_from_shop(item_data) -> void:
	current_pending_item = item_data
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	create_preview()

func create_preview() -> void:
	if preview_indicator:
		preview_indicator.queue_free()
	
	preview_indicator = Polygon2D.new()
	var points = PackedVector2Array()
	for i in range(32):
		var angle = deg_to_rad(i * 360.0 / 32.0)
		points.append(Vector2(cos(angle), sin(angle)) * 40.0)
	
	preview_indicator.polygon = points
	preview_indicator.z_index = 10
	add_child(preview_indicator)

func update_preview() -> void:
	if current_pending_item == null or preview_indicator == null:
		return
		
	var mouse_pos = get_global_mouse_position()
	preview_indicator.global_position = mouse_pos
		
	if current_pending_item["type"] == "spell":
		if is_on_path(mouse_pos):
			preview_indicator.color = Color(0, 1, 0, 0.3)
		else:
			preview_indicator.color = Color(1, 0, 0, 0.3)
	else:
		preview_indicator.color = Color(1, 1, 1, 0.3)

func _unhandled_input(event: InputEvent) -> void:
	if current_pending_item == null: 
		return
	
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			cancel_placement()
		elif event.button_index == MOUSE_BUTTON_LEFT:
			var pos = get_global_mouse_position()
			
			if current_pending_item["type"] == "spell" and not is_on_path(pos):
				return
				
			var cost = float(current_pending_item["cost"])
			if mana >= cost:
				spawn_item(pos)
				mana -= cost
				if current_pending_item["type"] == "spell":
					cancel_placement()
			else:
				cancel_placement()

func is_on_path(pos: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true
	
	var results = space_state.intersect_point(query)
	for result in results:
		if result.collider.is_in_group("Path"):
			return true
	return false

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
	if preview_indicator:
		preview_indicator.queue_free()
		preview_indicator = null
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
