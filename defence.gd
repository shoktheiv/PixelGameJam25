extends Area2D
class_name defence

@export var bullet : PackedScene
@export var bullet_speed : float
@export var damage : float
@export var spread : float
@export var bullet_lifetime : float
@export var detect_radius : Area2D
@export var time_between_attacks : float
@export var animation_time : float
@export var sprite : AnimatedSprite2D
@export var animation_fps : int = 5

enum State { BEING_LOCATED, DEPLOYED }
var current_state : State = State.BEING_LOCATED

var should_attack = false
var attack_speed_multiplier = 1

func _physics_process(delta: float) -> void:
	if current_state == State.BEING_LOCATED:
		return

	if detect_radius == null:
		return

	if detect_radius.get_overlapping_areas().is_empty():
		should_attack = false

func attack():
	if current_state != State.DEPLOYED:
		return

	if not should_attack:
		return

	call("shoot")
	should_attack = false

func get_closest_enemy() -> Node2D:
	if current_state != State.DEPLOYED:
		return null

	var closest_fence = null
	var min_dist = INF
	for node in detect_radius.get_overlapping_areas():
		var dist = global_position.distance_to(node.global_position)
		if dist < min_dist:
			closest_fence = node
			min_dist = dist
	return closest_fence

func set_state(new_state: State) -> void:
	current_state = new_state
	
	match current_state:
		State.BEING_LOCATED:
			should_attack = false
			if sprite:
				var color = sprite.modulate
				color.a = 0.5
				sprite.modulate = color
		
		State.DEPLOYED:
			if sprite:
				var color = sprite.modulate
				should_attack = true
				attack()
				color.a = 1.0
				sprite.modulate = color
