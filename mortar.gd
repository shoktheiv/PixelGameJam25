extends defence

@export var shootPoint : Node2D
@export var sprite : Node2D

func shoot():
	
	var enem = get_closest_enemy().global_position
	
	sprite.play("fire")
	
	await get_tree().create_timer(0.9).timeout
	
	var b = bullet.instantiate()
	get_tree().current_scene.add_child(b)
	b.start_position = shootPoint.global_position
	b.target_position = enem
	b.damage = damage

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if should_attack == false:
		should_attack = true
		attack()
