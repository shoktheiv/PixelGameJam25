extends Node2D

class_name spawner

@export var zombie_scene: PackedScene
@export var spawn_interval := 1.5
@export var time_between_waves := 20
@export var zombies_per_wave := 1
@export var max_waves := 10
@export var spawn_radius := 25

var current_wave := 0
var zombies_spawned := 0
var spawning := false

static var public : spawner

var map_width : int
var map_height : int

func _enter_tree() -> void:
	public = self

func _ready():
	map_height = game_manager.public.map_height
	map_width = game_manager.public.map_width
	start_next_wave()

func start_next_wave():
	while true:
		current_wave += 1
		zombies_spawned = 0
		spawning = true
		
		canvas.public.wave_text.text = "Wave " + str(current_wave)
		
		await spawn_wave()
		
		spawning = false
		await get_tree().create_timer(time_between_waves).timeout

func spawn_wave():
	while zombies_spawned < zombies_per_wave + current_wave:
		spawn_zombie()
		zombies_spawned += 1
		await get_tree().create_timer(spawn_interval).timeout

func spawn_zombie():
	var zombie = zombie_scene.instantiate()
	get_tree().current_scene.add_child(zombie)
	
	var n = randf_range(-PI, PI)

	var spawn_pos = Vector2(sin(n), cos(n)) * spawn_radius 
	zombie.global_position = spawn_pos + (Vector2(map_width / 2, map_height / 2) * game_manager.public.tile_size) 

func find_closest_fence(from_pos: Vector2) -> Node2D:
	var closest_fence = null
	var min_dist = INF
	for node in game_manager.public.perlin_noise.walkable_tiles:
		var dist = from_pos.distance_to(node.global_position)
		if dist < min_dist:
			closest_fence = node
			min_dist = dist
	return closest_fence


	
