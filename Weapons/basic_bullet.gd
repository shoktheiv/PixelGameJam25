extends Sprite2D

var vel : Vector2
var damage : float

func set_target(v : Vector2, d : float):
	vel = (v - global_position).normalized()
	rotation = atan2(vel.y, vel.x)
	damage = d

func _physics_process(delta: float) -> void:
	global_position += vel


func _on_area_2d_area_entered(area: Area2D) -> void:
	area.get_parent().take_damage(damage)
