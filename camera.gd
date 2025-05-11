extends Camera2D

class_name mainCamera

@export var player: CharacterBody2D
var default_zoom : float = 100
var zoom_speed : float = 0.05

static var shake_duration : float = 0
static var shake_amount : float = 0.7

func _physics_process(delta: float) -> void:
	var player_speed : float = player.velocity.length()
	var pos_offset : Vector2 = player.velocity / 5
	var my_pos : Vector2 = player.global_position + pos_offset
	
	global_position = lerp(global_position, my_pos, 0.05)
	
	var desired_zoom : float = default_zoom / (player_speed + 1)
	desired_zoom = clamp(desired_zoom, 8, 10)
	zoom = lerp(zoom, Vector2(desired_zoom, desired_zoom), zoom_speed)
	
	if shake_duration > 0:
		var new_pos : Vector2 = Vector2(sin(deg_to_rad(randf_range(0, 360))), 
				cos(deg_to_rad(randf_range(0, 360)))) * shake_amount
		var desired_pos : Vector2 = new_pos + player.global_position
		
		global_position = lerp(global_position, desired_pos, 0.05)
		
		shake_duration -= delta
		shake_amount = lerp(shake_amount, 0.0, delta)

static func shake_once(duration: float, power: float):
	shake_duration += duration
	shake_amount += power
