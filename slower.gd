extends Area2D

func _physics_process(delta: float) -> void:
	for i in get_overlapping_areas():
		i.get_parent().speed_multiplier = 0.2
		
func on_area_exited(area: Area2D):
	area.get_parent().speed_multiplier = 1
