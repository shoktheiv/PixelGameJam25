extends Node2D

class_name game_manager

@export var perlin_noise : Node2D
@export var spawner : Node2D
@export var player : CharacterBody2D
@export var camera : Camera2D

@export var cannon : Node2D
@onready var mouse_collision =  $MouseArea

var defences: Dictionary = {}

@export var map_width: int = 40
@export var map_height: int = 28
@export var tile_size: int = 16

static var public : game_manager

var player_coins := 1000

func _enter_tree() -> void:
	public = self

func _ready() -> void:
	public = self
	perlin_noise.generate_map()
	spawner.start_next_wave()
	

func _process(delta: float) -> void:
	mouse_collision.global_position = get_global_mouse_position()
	if cannon != null:
		if mouse_collision.get_overlapping_areas().size() > 0:
			cannon.global_position = mouse_collision.get_overlapping_areas()[0].global_position
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				if !defences.has(mouse_collision.get_overlapping_areas()[0].global_position):
					spawn_cannon(mouse_collision.get_overlapping_areas()[0])
			

func spawn_cannon(pos : Node2D):
	cannon.global_position = pos.global_position
	defences.set(pos.global_position, cannon)
	cannon.set_state(defence.State.DEPLOYED)
	cannon.reparent(pos)
	cannon = null

func set_picking_cannon(item : Item):
	cannon = item.scene.instantiate()
	get_tree().current_scene.add_child(cannon)
	cannon.set_state(defence.State.BEING_LOCATED)
