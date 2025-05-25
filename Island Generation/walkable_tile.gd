extends Area2D

@export var max_health : float = 100
var health : float = 0

var grid_pos : Vector2i

func _ready() -> void:
	health = max_health

func take_damage(damage: float):
	health -= damage
	
	if health <= 0:
		perlin_noise.public.tile_remove(self)
		queue_free()
