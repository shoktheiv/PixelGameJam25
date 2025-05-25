extends Node2D

@export var speed := 20.0
@export var attack_range := 8.0
@export var attack_cooldown := 1.0
@export var damage:float = 10
@export var coins_dropped_range : Array[int]
@export var attack_effect : PackedScene

@export var max_health : float = 100
var health : float = 0

var speed_multiplier : float = 1.0

var target: Node2D
var time_since_attack := 0.0

var is_attacking = false

func _ready() -> void:
	health = max_health

func _physics_process(delta):
	if target == null: 
		target = spawner.public.find_closest_fence(global_position)
		if target == null:
			return
		var flip = target.global_position.x < global_position.x
		$sprite.flip_h = flip
	
	
	if target == null: 
		queue_free()
		return
	var direction = (target.global_position - global_position).normalized()
	var distance = global_position.distance_to(target.global_position)

	if distance > attack_range:
		if is_attacking == true:
			$sprite.play("default")
			is_attacking = false
		position += direction * speed * delta * speed_multiplier
	else:
		if (is_attacking == false):
			$sprite.play("attack")
			is_attacking = true
		
		time_since_attack += delta
		if time_since_attack >= attack_cooldown:
			attack_target()
			time_since_attack = 0.0

func attack_target():
	if target.has_method("take_damage"):
		var b = attack_effect.instantiate()
		add_child(b)
		b.global_position = $hand.global_position
		b.rotation = (target.global_position - global_position).normalized().angle()
		target.take_damage(damage)

	
func take_damage(damage : float, b_pos: Vector2, knock_back: float):
	health -= damage
	
	$sprite.modulate.v = 0.01
	await get_tree().create_timer(0.3).timeout
	$sprite.modulate.v = 1
	
	if health <= 0:
		die()

func die():
	game_manager.public.player_coins += randf_range(coins_dropped_range[0], coins_dropped_range[1])
	canvas.public.coin_text.text = str(game_manager.public.player_coins)
	queue_free()
