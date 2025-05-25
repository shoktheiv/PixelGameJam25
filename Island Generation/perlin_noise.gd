extends Node2D
class_name perlin_noise

@export var tile_size: int = 16
@export var tilemap : TileMapLayer
@export var island_radius_factor := 0.3

@export var grass_tile_id := Vector2i(1,1)
@export var water_tile_id := Vector2i(1,17)
@export var trans_tile_id := Vector2i(1, 7)
@export var walkable_tile : PackedScene
@export var water_tile : PackedScene

static var public : perlin_noise

var noise = FastNoiseLite.new()
var map_height : int
var map_width : int

var walkable_tiles := []
var walkable_tiles_id := []

func _enter_tree() -> void:
	public = self

func generate_map():
	map_height = game_manager.public.map_height
	map_width = game_manager.public.map_width
	
	noise.seed = randi()
	noise.frequency = 0.05
	var center = Vector2(map_width / 2, map_height / 2)
	game_manager.public.camera.global_position = center * tile_size
	
	var max_dist = center.length() * island_radius_factor
	
	for x in range(map_width):
		for y in range(map_height):
			var pos = Vector2i(x, y)

			if x == 0 or y == 0 or x == map_width - 1 or y == map_height - 1:
				tilemap.set_cell(pos, -1, water_tile_id)
				continue

			var noise_val = noise.get_noise_2d(x, y)

			var dist = pos.distance_to(center)
			var falloff = pow(dist / max_dist, 2.5)
			noise_val -= falloff

			spawn_tile(pos, get_tile_id(noise_val))

	var player_spawn = walkable_tiles.pick_random()
	game_manager.public.player.global_position = player_spawn.global_position
	
func spawn_tile(pos : Vector2, tile_id : Vector2i):
	if tile_id == grass_tile_id:
		tilemap.set_cell(pos, -1, tile_id)
		var tile = walkable_tile.instantiate()
		
		add_child(tile)
		tile.position = pos * tile_size
		tile.grid_pos = pos
		walkable_tiles_id.append(pos)
		walkable_tiles.append(tile)
		tilemap.set_cells_terrain_connect([pos], 0, 0, false)
	else:
		var tile = water_tile.instantiate()
		
		add_child(tile)
		tile.position = pos * tile_size
	

func get_tile_id(value: float) -> Vector2i:
	if value < -0.3:
		return water_tile_id
	elif value < 0.6:
		return grass_tile_id
	
	return water_tile_id

func tile_remove(tile: Node2D):
	if tile in walkable_tiles:
		walkable_tiles.erase(tile)
		walkable_tiles_id.erase(tile.grid_pos)

		# Remove the tile from the TileMap (layer 0)
		tilemap.erase_cell(tile.grid_pos)

		tilemap.set_cells_terrain_connect([tile.grid_pos], 0, -1, false)
		spawn_tile(tile.grid_pos, water_tile_id)
