extends CanvasLayer

signal item_selected(item_data)

var catalog = {}

func _ready() -> void:
	load_data()

func load_data():
	var file = FileAccess.open("res://catalog.json", FileAccess.READ)
	if file:
		var text = file.get_as_text()
		catalog = JSON.parse_string(text)
		print("Catálogo cargado: ", catalog.keys())

func _on_button_pressed(id: String):
	print("Botón presionado con ID: ", id)
	if catalog.has(id):
		emit_signal("item_selected", catalog[id])





func _on_texture_button_3_pressed(id: String = "rayo"): 
	print("Botón presionado: ", id)
	if catalog.has(id):
		item_selected.emit(catalog[id])
