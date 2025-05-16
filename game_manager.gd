extends Node2D

class_name game_manager

@export var perlin_noise : Node2D
@export var spawner : Node2D
@export var player : CharacterBody2D
@export var camera : Camera2D

@export var cannon : PackedScene
@onready var mouse_collision =  $MouseArea

var defences: Dictionary = {}

@export var map_width: int = 40
@export var map_height: int = 28
@export var tile_size: int = 16

static var public : game_manager

func _enter_tree() -> void:
	public = self

func _ready() -> void:
	public = self
	perlin_noise.generate_map()
	spawner.start_next_wave()
	

func _process(delta: float) -> void:
	mouse_collision.global_position = get_global_mouse_position()
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if mouse_collision.get_overlapping_areas().size() > 0:
			if !defences.has(mouse_collision.get_overlapping_areas()[0].global_position):
				spawn_cannon(mouse_collision.get_overlapping_areas()[0])
			

func spawn_cannon(pos : Node2D):
	var can : Node2D = cannon.instantiate()
	can.global_position = pos.global_position
	
	pos.add_child(can)
	can.position = Vector2.ZERO
	defences.set(pos.global_position, can)
	print(defences)
