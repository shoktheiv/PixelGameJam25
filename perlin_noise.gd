extends Node2D

@export var map_width: int = 25
@export var map_height: int = 15
@export var tile_size: int = 16

@export var grass_scene: PackedScene
@export var water_scene: PackedScene
@export var mountain_scene: PackedScene
@export var island_radius_factor := 0.5

var noise = FastNoiseLite.new()


func _ready():
	noise.seed = randi()
	noise.frequency = 0.1
	generate_map()

func generate_map():
	var center = Vector2(map_width / 2, map_height / 2)
	$Player.global_position = center * tile_size
	var max_dist = center.length() * island_radius_factor
	
	for x in range(map_width):
		for y in range(map_height):
			var pos = Vector2(x, y)

			# Force water at borders
			if x == 0 or y == 0 or x == map_width - 1 or y == map_height - 1:
				spawn_tile(water_scene, pos)
				continue

			var noise_val = noise.get_noise_2d(x, y)

			var dist = pos.distance_to(center)
			var falloff = pow(dist / max_dist, 2.5)
			noise_val -= falloff

			var tile_scene = get_tile_scene(noise_val)
			spawn_tile(tile_scene, pos)

func spawn_tile(scene: PackedScene, pos: Vector2):
	var tile = scene.instantiate()
	add_child(tile)
	tile.position = pos * tile_size

func get_tile_scene(value: float) -> PackedScene:
	if value < -0.3:
		return water_scene
	elif value < 0.6:
		return grass_scene
	
	return mountain_scene
