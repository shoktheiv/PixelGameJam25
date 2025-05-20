extends PanelContainer

@export var item : Item:
	set(value):
		item = value
		$ICON.texture = item.icon

func _on_mouse_entered() -> void:
	if item!= null:
		owner.set_description(item)



func _on_button_pressed() -> void:
	if game_manager.public.player_coins < item.cost:
		return
	
	game_manager.public.set_picking_cannon(item)
	get_parent().get_parent().get_parent().hide_defences()


func _on_mouse_exited() -> void:
	owner.set_description(null)
