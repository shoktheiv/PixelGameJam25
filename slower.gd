extends defence

func _physics_process(delta: float) -> void:
	
	if current_state != State.DEPLOYED:
		return
	for i in get_overlapping_areas():
		i.get_parent().speed_multiplier = 0.2
		
func on_area_exited(area: Area2D):
	area.get_parent().speed_multiplier = 1

func set_state(new_state: State) -> void:
	current_state = new_state
	
	match current_state:
		State.BEING_LOCATED:
			var color = modulate
			color.a = 0.5
			modulate = color
		
		State.DEPLOYED:
			var color = modulate
			color.a = 1.0
			modulate = color
