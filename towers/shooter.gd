extends defence

@export var shooters : Node2D

func _ready() -> void:
	should_attack = true
	attack()

func shoot():
	sprite.speed_scale = 1.0 / attack_speed_multiplier
	sprite.play("fire")
	
	await get_tree().create_timer(animation_time * attack_speed_multiplier).timeout
	
	for i : Node2D in shooters.get_children():
		var b : Node2D = bullet.instantiate()
		get_tree().current_scene.add_child(b)
		b.global_position = i.global_position
		var vel = (i.global_position - shooters.global_position).normalized() * bullet_speed
		b.start(vel, damage, bullet_lifetime)
	
	await get_tree().create_timer(time_between_attacks * attack_speed_multiplier).timeout
	
	should_attack = true
	attack()
