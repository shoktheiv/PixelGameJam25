extends Node2D

@export var speed := 20.0
@export var attack_range := 8.0
@export var attack_cooldown := 1.0
@export var damage:float = 10

@export var max_health : float = 100
var health : float = 0

var speed_multiplier : float = 1.0

var target: Node2D
var time_since_attack := 0.0

func _ready() -> void:
	health = max_health

func _physics_process(delta):
	if target == null: 
		target = spawner.public.find_closest_fence(global_position)
	
	if target == null: 
		queue_free()
		return
	var direction = (target.global_position - global_position).normalized()
	var distance = global_position.distance_to(target.global_position)

	if distance > attack_range:
		position += direction * speed * delta * speed_multiplier
	else:
		time_since_attack += delta
		if time_since_attack >= attack_cooldown:
			attack_target()
			time_since_attack = 0.0

func attack_target():
	if target.has_method("take_damage"):
		target.take_damage(damage)

func set_target(t: Node2D):
	target = t
	
func take_damage(damage : float):
	health -= damage
	
	if health <= 0:
		queue_free()
