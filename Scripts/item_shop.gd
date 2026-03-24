extends CanvasLayer

signal item_selected(item_data: Dictionary)

var catalog: Dictionary = {}

@onready var info_display: RichTextLabel = $PanelContainer2/RichTextLabel

const BASE_PATH = "PanelContainer/HBoxContainer/"
var button_map: Dictionary = {
	"lancer": BASE_PATH + "PanelContainer2/TextureButton",
	"short_archer": BASE_PATH + "PanelContainer3/TextureButton2",
	"long_archer": BASE_PATH + "PanelContainer4/TextureButton3",
	"warrior": BASE_PATH + "PanelContainer5/TextureButton4",
	"spike": BASE_PATH + "PanelContainer6/TextureButton5",
	"lightning": BASE_PATH + "PanelContainer7/TextureButton6",
	"barricade": BASE_PATH + "PanelContainer8/TextureButton7",
	"bomb": BASE_PATH + "PanelContainer9/TextureButton8"
}

var extra_info: Dictionary = {
	"warrior": {"color": "yellow", "currency": "Coins"},
	"lancer": {"color": "yellow", "currency": "Coins"},
	"short_archer": {"color": "yellow", "currency": "Coins"},
	"long_archer": {"color": "yellow", "currency": "Coins"},
	"spike": {"color": "cyan", "currency": "Mana"},
	"barricade": {"color": "cyan", "currency": "Mana"},
	"bomb": {"color": "cyan", "currency": "Mana"},
	"lightning": {"color": "cyan", "currency": "Mana"}
}

func _ready() -> void:
	info_display.bbcode_enabled = true
	load_catalog()
	setup_shop()

func load_catalog() -> void:
	var file = FileAccess.open("res://catalog.json", FileAccess.READ)
	if file:
		catalog = JSON.parse_string(file.get_as_text())
		print("Catalog loaded: ", catalog.keys())

func setup_shop() -> void:
	clear_info()
	
	for item_id in button_map.keys():
		var btn_path = button_map[item_id]
		var btn = get_node_or_null(btn_path)
		
		if btn is TextureButton:
			btn.pressed.connect(buy.bind(item_id))
			btn.mouse_entered.connect(show_info.bind(item_id))
			btn.mouse_exited.connect(clear_info)
		else:
			print("Error: No se encontró el botón en la ruta ", btn_path)

func show_info(item_id: String) -> void:
	if not catalog.has(item_id) or not extra_info.has(item_id):
		return
		
	var item_data = catalog[item_id]
	var extra = extra_info[item_id]
	
	var text = "[color=%s][b]%s[/b][/color]\n" % [extra["color"], item_data["name"].to_upper()]
	text += "Cost: %d %s\n" % [item_data["cost"], extra["currency"]]
	
	if item_data.has("damage"):
		var dmg = item_data["damage"]
		if item_id == "spike":
			text += "Damage: %d per second\n" % dmg
		elif item_id == "barricade":
			text += "Damage: %d on contact\n" % dmg
		else:
			text += "Damage: %d\n" % dmg
	
	if item_data.has("attack_rate"):
		text += "Attack Rate: %.1fs\n" % item_data["attack_rate"]
	
	if item_data.has("range"):
		text += "Range: %d\n" % item_data["range"]
	
	info_display.text = text

func clear_info() -> void:
	info_display.text = "[color=gray][i]Hover over an item to see its details.[/i][/color]"

func buy(id: String) -> void:
	if catalog.has(id):
		item_selected.emit(catalog[id])
		
		var focus_owner = get_viewport().gui_get_focus_owner()
		if focus_owner:
			focus_owner.release_focus()
