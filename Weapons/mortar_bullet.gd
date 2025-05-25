extends Sprite2D

@export var flight_time := 1.0  # seconds
@export var max_height := 100.0  # how high the arc goes
@export var target_position: Vector2
@export var area : Area2D
@export var exp_fx :PackedScene

var start_position: Vector2
var time_passed := 0.0

var damage : float = 1

func _ready():
	start_position = global_position

func _process(delta):
	time_passed += delta
	var t = clamp(time_passed / flight_time, 0, 1)

	# Linear horizontal interpolation
	var horizontal_pos = start_position.lerp(target_position, t)

	# Parabolic height offset (0 at ends, 1 in middle)
	var height_offset = -4 * (t - 0.5) ** 2 + 1
	var y_offset = -height_offset * max_height  # Negative because Y+ is down in Godot

	# Combine
	global_position = horizontal_pos + Vector2(0, y_offset)

	if t >= 1.0:
		explode()

func explode():
	for i in area.get_overlapping_areas():
		i.get_parent().take_damage(damage, global_position, 5)
	mainCamera.shake_once(0.4, 10)
	var b = exp_fx.instantiate()
	get_tree().current_scene.add_child(b)
	b.global_position = global_position
	queue_free()
	
