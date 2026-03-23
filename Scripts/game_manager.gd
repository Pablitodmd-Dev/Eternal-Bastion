extends Node2D

@export var mana_regeneration_rate: float = 2.5
@export var game_over_scene: PackedScene 

@onready var mana_label: Label = $ItemShop/PanelContainer/VBoxContainer/FilaMana/ManaLabel
@onready var gold_label: Label = $ItemShop/PanelContainer/VBoxContainer/FilaOro/GoldLabel 
@onready var shop = $ItemShop

var current_pending_item = null
var scene_cache: Dictionary = {}
var preview_indicator: Polygon2D = null


func _ready() -> void:
	GameManager.reset_level()
	
	GameManager.current_level_path = scene_file_path
	
	if shop.has_signal("item_selected"):
		shop.item_selected.connect(_on_item_selected_from_shop)

func _process(delta: float) -> void:
	if current_pending_item != null and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		cancel_placement()
		return
		
	if GameManager.mana < GameManager.max_mana:
		GameManager.mana += mana_regeneration_rate * delta
		GameManager.mana = clamp(GameManager.mana, 0.0, GameManager.max_mana)
	
	mana_label.text = "Mana: " + str(int(GameManager.mana))
	gold_label.text = "Oro: " + str(GameManager.coins)
	
	update_preview()

func show_game_over() -> void:
	if game_over_scene:
		var menu = game_over_scene.instantiate()
		add_child(menu)
		get_tree().paused = true 
	else:
		print("Error: No has asignado la escena de Game Over en el Inspector")

func _on_item_selected_from_shop(item_data) -> void:
	current_pending_item = item_data
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	create_preview()

func create_preview() -> void:
	if preview_indicator:
		preview_indicator.queue_free()
	
	var item_range = 50.0
	if current_pending_item.has("range"):
		item_range = float(current_pending_item["range"])
	
	preview_indicator = Polygon2D.new()
	var points = PackedVector2Array()
	var quality = 64 
	for i in range(quality + 1):
		var angle = deg_to_rad(i * 360.0 / quality)
		points.append(Vector2(cos(angle), sin(angle)) * item_range)
	
	preview_indicator.polygon = points
	preview_indicator.z_index = 10
	preview_indicator.color = Color(1, 1, 1, 0.15)
	add_child(preview_indicator)

func update_preview() -> void:
	if current_pending_item == null or preview_indicator == null:
		return
		
	var mouse_pos = get_global_mouse_position()
	var cost = float(current_pending_item["cost"])
	
	if current_pending_item["type"] == "spell":
		preview_indicator.global_position = mouse_pos
		if is_on_path(mouse_pos) and GameManager.mana >= cost:
			preview_indicator.color = Color(0, 1, 0, 0.15)
		else:
			preview_indicator.color = Color(1, 0, 0, 0.15)
	else:
		var platform = get_platform_at_position(mouse_pos)
		if platform != null and platform.can_build_here() and GameManager.coins >= int(cost):
			preview_indicator.global_position = platform.global_position + Vector2(0, -40)
			preview_indicator.color = Color(0, 1, 0, 0.15)
		else:
			preview_indicator.global_position = mouse_pos
			preview_indicator.color = Color(1, 0, 0, 0.15)

func _unhandled_input(event: InputEvent) -> void:
	if current_pending_item == null: 
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var pos = get_global_mouse_position()
		var cost = float(current_pending_item["cost"])
		
		if current_pending_item["type"] == "spell":
			if is_on_path(pos) and GameManager.mana >= cost:
				spawn_item(pos)
				GameManager.mana -= cost
				cancel_placement()
		else:
			var platform = get_platform_at_position(pos)
			if platform != null and platform.can_build_here() and GameManager.coins >= int(cost):
				var spawn_pos = platform.global_position + Vector2(0, -40) 
				spawn_item(spawn_pos)
				platform.is_occupied = true
				GameManager.coins -= int(cost)
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
	instance.position = pos
	add_child(instance)

	if instance.has_method("setup_unit"):
		instance.setup_unit(current_pending_item)

func cancel_placement() -> void:
	current_pending_item = null
	if preview_indicator:
		preview_indicator.queue_free()
		preview_indicator = null
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func get_platform_at_position(pos: Vector2) -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true
	var results = space_state.intersect_point(query)
	for result in results:
		var collider = result.collider
		if collider.is_in_group("Platforms"):
			return collider
	return null
