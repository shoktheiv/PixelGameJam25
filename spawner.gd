extends Node2D

@export var zombie_scene: PackedScene
@export var spawn_interval := 1.5
@export var time_between_waves := 5.0
@export var zombies_per_wave := 3
@export var max_waves := 10
@export var spawn_radius := 25

var current_wave := 0
var zombies_spawned := 0
var spawning := false

@export var game_manager : Node2D

var map_width : int
var map_height : int

func _ready():
	map_height = game_manager.map_height
	map_width = game_manager.map_width
	start_next_wave()

func start_next_wave():
	if current_wave >= max_waves:
		return

	current_wave += 1
	zombies_spawned = 0
	spawning = true
	
	await spawn_wave()
	
	spawning = false
	await get_tree().create_timer(time_between_waves).timeout
	start_next_wave()

func spawn_wave():
	while zombies_spawned < zombies_per_wave + current_wave * 2: # Increasing difficulty
		spawn_zombie()
		zombies_spawned += 1
		await get_tree().create_timer(spawn_interval).timeout

func spawn_zombie():
	var zombie = zombie_scene.instantiate()
	get_tree().current_scene.add_child(zombie)
	
	var n = randf_range(-PI, PI)

	var spawn_pos = Vector2(sin(n), cos(n)) * spawn_radius 
	zombie.global_position = spawn_pos + (Vector2(map_width / 2, map_height / 2) * game_manager.tile_size) 
	
	zombie.target = find_closest_fence(zombie.global_position)

func find_closest_fence(from_pos: Vector2) -> Node2D:
	var closest_fence = null
	var min_dist = INF
	for node in game_manager.perlin_noise.walkable_tiles:
		var dist = from_pos.distance_to(node.global_position)
		if dist < min_dist:
			closest_fence = node
			min_dist = dist
	return closest_fence
