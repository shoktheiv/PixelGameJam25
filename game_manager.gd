extends Node2D

@export var perlin_noise : Node2D
@export var spawner : Node2D
@export var player : CharacterBody2D
@export var camera : Camera2D

@export var map_width: int = 40
@export var map_height: int = 28
@export var tile_size: int = 16

func _ready() -> void:
	await perlin_noise.generate_map()
	spawner.start_next_wave()
