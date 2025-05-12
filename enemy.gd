extends Node2D

@export var speed := 20.0
@export var attack_range := 8.0
@export var attack_cooldown := 1.0

var target: Node2D = null
var time_since_attack := 0.0

func _process(delta):
	if target == null: return
	
	var direction = (target.global_position - global_position).normalized()
	var distance = global_position.distance_to(target.global_position)

	if distance > attack_range:
		position += direction * speed * delta
	else:
		time_since_attack += delta
		if time_since_attack >= attack_cooldown:
			attack_target()
			time_since_attack = 0.0

func attack_target():
	if target.has_method("take_damage"):
		target.take_damage(1)

func set_target(t: Node2D):
	target = t
