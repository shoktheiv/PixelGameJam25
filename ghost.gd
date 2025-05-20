extends Node2D

@export var speed := 20.0
@export var attack_range := 8.0
@export var attack_cooldown := 1.0
@export var damage:float = 10
@export var coins_dropped_range : Array[int]

@export var max_health : float = 100
var health : float = 0

var speed_multiplier : float = 1.0

var is_visible : bool = false

var target: Node2D
var time_since_attack := 0.0

var is_attacking = false

func _ready() -> void:
	health = max_health

func _physics_process(delta):
	if target == null: 
		target = spawner.public.find_closest_fence(global_position)
		var flip = target.global_position.x < global_position.x
		$sprite.flip_h = flip
	
	if target == null: 
		queue_free()
		return
	var direction = (target.global_position - global_position).normalized()
	var distance = global_position.distance_to(target.global_position)

	if distance > attack_range:
		is_visible = false
		if is_attacking == true:
			$sprite.play("default")
			is_attacking = false
		position += direction * speed * delta * speed_multiplier
	else:
		is_visible = true
		if (is_attacking == false):
			$sprite.play("attack")
			is_attacking = true
		
		time_since_attack += delta
		if time_since_attack >= attack_cooldown:
			attack_target()
			time_since_attack = 0.0
	
	if is_visible == false:
		$Area2D.monitorable = false
		modulate.a = lerp(modulate.a, 0.0, 0.1)
	else:
		$Area2D.monitorable = true
		modulate.a = lerp(modulate.a, 1.0, 0.1)

func attack_target():
	if target.has_method("take_damage"):
		target.take_damage(damage)

	
func take_damage(damage : float):
	health -= damage
	
	if health <= 0:
		die()

func die():
	game_manager.public.player_coins += randf_range(coins_dropped_range[0], coins_dropped_range[1])
	canvas.public.coin_text.text = str(game_manager.public.player_coins)
	queue_free()
