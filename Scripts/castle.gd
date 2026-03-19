extends Area2D 

@export var health: int = 100
@export var damaged_sprite: Texture2D 
@export var destroyed_sprite: Texture2D 
@export var damaged_scale: Vector2 = Vector2(1.5, 1.5) 
@export var destroyed_scale: Vector2 = Vector2(2.0, 2.0)

@onready var health_bar = $TextureProgressBar
@onready var sprite = $Sprite2D
@onready var smoke = $SmokeParticles
@onready var death_sound = $AudioStreamPlayer2D
@onready var damaged_sound = $AudioStreamPlayer2D2

var is_dead: bool = false
var damaged_sound_played: bool = false

func _ready():
	health_bar.max_value = health
	health_bar.value = health
	if smoke:
		smoke.emitting = false

func take_damage(amount: int):
	if is_dead: return
	
	health -= amount
	health_bar.value = health
	
	modulate = Color(1, 0.5, 0.5) 
	await get_tree().create_timer(0.1).timeout
	modulate = Color(1, 1, 1)

	if health <= 30 and health > 0:
		activate_damaged_state()

	if health <= 0:
		die()

func activate_damaged_state():
	if damaged_sprite and sprite:
		sprite.texture = damaged_sprite
		sprite.scale = damaged_scale
	
	if smoke and not smoke.emitting:
		smoke.emitting = true
	
	if damaged_sound and not damaged_sound_played:
		damaged_sound.play()
		damaged_sound_played = true

func die():
	if is_dead: return
	is_dead = true
	
	if sprite and destroyed_sprite:
		var current_rect = sprite.get_rect()
		var ground_y = sprite.position.y + (current_rect.size.y * sprite.scale.y / 2)
		
		sprite.texture = destroyed_sprite
		sprite.scale = destroyed_scale
		
		var new_rect = sprite.get_rect()
		sprite.position.y = ground_y - (new_rect.size.y * destroyed_scale.y / 2)
		
		if smoke:
			smoke.position.y = sprite.position.y + (new_rect.size.y * destroyed_scale.y / 4)
	
	if health_bar:
		health_bar.hide()
		
	if death_sound:
		death_sound.play()
