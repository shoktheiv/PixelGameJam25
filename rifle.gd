extends Weapon

@export var bullet : PackedScene
@export var bullet_speed: float 
@export var spread: float
@export var shootPoint: Node2D
@export var spin_bullet: bool = false

func attack(dir: Vector2, friendly: bool = true):
	var b : Area2D = bullet.instantiate()
	get_parent().get_parent().get_parent().add_child(b)
	b.global_position = shootPoint.global_position
	b.set_vel(dir.normalized() * bullet_speed)
	b.set_torque(20)
	
	if friendly:
		b.collision_mask = 2
		
func _on_fire_rate_timeout() -> void:
	can_attack = true 
