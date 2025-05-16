extends defence

@export var shooters : Node2D

func _ready() -> void:
	should_attack = true
	attack()

func shoot():
	sprite.play("fire")
	
	await get_tree().create_timer(animation_time).timeout
	
	for i : Node2D in shooters.get_children():
		var b : Node2D = bullet.instantiate()
		get_tree().current_scene.add_child(b)
		b.global_position = i.global_position
		var vel = (i.global_position - shooters.global_position).normalized() * bullet_speed
		b.start(vel, damage, bullet_lifetime)
	
	await get_tree().create_timer(time_between_attacks).timeout
	
	should_attack = true
	attack()
