extends defence

@export var shootPoint : Node2D


func shoot():
	
	if get_closest_enemy() != null:
		var enem = get_closest_enemy().global_position
		
		sprite.play("fire")
		
		await get_tree().create_timer(animation_time).timeout
		
		var b = bullet.instantiate()
		get_tree().current_scene.add_child(b)
		b.start_position = shootPoint.global_position
		b.target_position = enem
		b.damage = damage
	
	await get_tree().create_timer(time_between_attacks).timeout
	should_attack = true
	attack()

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if should_attack == false:
		should_attack = true
		attack()
