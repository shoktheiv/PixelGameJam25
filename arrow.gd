extends Area2D

var velocity : Vector2
var damage : float
var bullet_lifetime : float

func start(vel: Vector2, dmg: float, lfetme: float):
	velocity = vel
	damage = dmg
	bullet_lifetime = lfetme
	
	rotation = atan2(vel.normalized().y, vel.normalized().x) + deg_to_rad(90)
	
	$Timer.start(lfetme)

func _physics_process(delta: float) -> void:
	global_position += velocity
	

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	area.get_parent().take_damage(damage)
	queue_free()
