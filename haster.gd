extends defence

func on_area_exited(area: Area2D):
	area.get_parent().attack_speed_multiplier = 1

func set_state(new_state: State) -> void:
	current_state = new_state
	
	match current_state:
		State.BEING_LOCATED:
			var color = modulate
			color.a = 0.5
			modulate = color
		
		State.DEPLOYED:
			
			for i in get_overlapping_areas():
				if i is defence:
					i.attack_speed_multiplier = 0.2
			
			var color = modulate
			color.a = 1.0
			modulate = color


func _on_area_entered(area: Area2D) -> void:
	if current_state != State.DEPLOYED:
		return
	if area is defence:
		if area.get_state() == defence.State.DEPLOYED:
			area.attack_speed_multiplier = 0.2
