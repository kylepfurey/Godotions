extends Sprite3D

@onready var this_enemey := $"."
@onready var this_enemy_text := $"../Label3D"

var max_health := 30
var health := max_health
@export var taking_damage: bool
@export var idle_sprite: Texture2D
@export var hit_sprite: Texture2D

@export var hit_message: Array[String]
@export var death_message: Array[String]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test_hit"):
		take_damage(3)

func _process(delta: float) -> void:
	if taking_damage:
		this_enemey.texture = hit_sprite
	else:
		this_enemey.texture = idle_sprite

func take_damage(amount: int):
	
	var hit_text = hit_message.pick_random()
	this_enemy_text.text = hit_text
	
	this_enemey.texture = hit_sprite
	taking_damage = true
	health -= amount
	if health <= 0:
		die()
	await get_tree().create_timer(0.2).timeout
	taking_damage = false

func die():
	this_enemy_text.text = death_message.pick_random()
	await get_tree().create_timer(0.2).timeout
	this_enemy_text.text = ""
	queue_free()
	


	
