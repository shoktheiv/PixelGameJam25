extends defence

@export var shooters : Node2D

func shoot():
	for i : Node2D in shooters.get_children():
		var b : Node2D = bullet.instantiate()
		b.global_position = i.global_position
