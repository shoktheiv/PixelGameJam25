extends defence

@export var shootPoint : Node2D


func shoot():
	if get_closest_enemy() != null && should_attack:
		var enem = get_closest_enemy().global_position
		
		sprite.speed_scale = 1.0 / attack_speed_multiplier
		sprite.play("fire")
		
		await get_tree().create_timer(animation_time * attack_speed_multiplier).timeout
		
		var b = bullet.instantiate()
		get_tree().current_scene.add_child(b)
		b.start_position = shootPoint.global_position
		b.target_position = enem
		b.damage = damage
		should_attack = false
	
	await get_tree().create_timer(time_between_attacks * attack_speed_multiplier).timeout
	attack()  
