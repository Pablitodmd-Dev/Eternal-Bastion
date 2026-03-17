extends CanvasLayer

signal item_selected(item_data: Dictionary)

var catalog: Dictionary = {}

func _ready() -> void:
	load_catalog()

func load_catalog() -> void:
	var file = FileAccess.open("res://catalog.json", FileAccess.READ)
	if file:
		catalog = JSON.parse_string(file.get_as_text())
		print("Catalog loaded: ", catalog.keys())

func _on_texture_button_6_pressed(id: String = "lightning") -> void: 
	if catalog.has(id):
		item_selected.emit(catalog[id])
		
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner:
			focus_owner.release_focus()


func _on_texture_button_5_pressed(id: String = "spike") -> void:
	if catalog.has(id):
		item_selected.emit(catalog[id])
	
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner:
			focus_owner.release_focus()


func _on_texture_button_7_pressed(id: String = "barricade") -> void:
	if catalog.has(id):
		item_selected.emit(catalog[id])
	
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner:
			focus_owner.release_focus()

func _on_texture_button_8_pressed(id: String = "bomb") -> void:
	if catalog.has(id):
		item_selected.emit(catalog[id])
	
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner:
			focus_owner.release_focus()	
