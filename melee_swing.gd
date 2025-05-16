extends Weapon

@export var attack_speed: float 
@export var spread: float
@export var attack_duration: float
@export var damage:float = 100

var attack_remaining: float = 0.0
var starting_rotation: float = 0.0
var end_rotation: float = 0.0

var is_attacking = false

func attack(dir: Vector2, friendly: bool = true):
	is_attacking = true
	var spread_angle = deg_to_rad(spread)
	var direction = -1 if sprite.flip_h else 1

	var base_rot = get_parent().rotation
	starting_rotation = base_rot + direction * -spread_angle
	end_rotation = base_rot + direction * spread_angle
	
	attack_remaining = attack_duration

func _physics_process(delta: float) -> void:
	if attack_remaining > 0:
		var progress := 1.0 - (attack_remaining / attack_duration)
		var new_rot = lerp(starting_rotation, end_rotation, progress)
		get_parent().rotation = new_rot 
		attack_remaining -= delta
		for i in $HurtBox.get_overlapping_areas():
			i.get_parent().take_damage(damage)
	else:
		is_attacking = false

func _on_fire_rate_timeout() -> void:
	can_attack = true 
