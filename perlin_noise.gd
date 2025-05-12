extends Node2D

@export var tile_size: int = 16
@export var grass_scene: PackedScene
@export var water_scene: PackedScene
@export var mountain_scene: PackedScene
@export var island_radius_factor := 0.3

@export var game_manager : Node2D

var noise = FastNoiseLite.new()

var map_height : int
var map_width : int

var walkable_tiles := []

func generate_map():
	
	map_height = game_manager.map_height
	map_width = game_manager.map_width
	
	noise.seed = randi()
	noise.frequency = 0.1
	var center = Vector2(map_width / 2, map_height / 2)
	game_manager.camera.global_position = center * tile_size
	
	var max_dist = center.length() * island_radius_factor
	
	for x in range(map_width):
		for y in range(map_height):
			var pos = Vector2(x, y)

			if x == 0 or y == 0 or x == map_width - 1 or y == map_height - 1:
				spawn_tile(water_scene, pos)
				continue

			var noise_val = noise.get_noise_2d(x, y)

			var dist = pos.distance_to(center)
			var falloff = pow(dist / max_dist, 2.5)
			noise_val -= falloff

			var tile_scene = get_tile_scene(noise_val)
			spawn_tile(tile_scene, pos)
			
	game_manager.player.global_position = walkable_tiles.pick_random().global_position
func spawn_tile(scene: PackedScene, pos: Vector2):
	var tile = scene.instantiate()
	
	add_child(tile)
	tile.position = pos * tile_size
	
	if scene == grass_scene:
		walkable_tiles.append(tile)

func get_tile_scene(value: float) -> PackedScene:
	if value < -0.3:
		return water_scene
	elif value < 0.6:
		return grass_scene
	
	return mountain_scene
