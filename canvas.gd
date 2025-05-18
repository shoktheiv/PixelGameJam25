extends Control

@export var defences : Array[PackedScene]
@export var description : NinePatchRect
var selected_item : Item

func set_description(item : Item):
	selected_item = item
	if item != null:
		description.find_child("Name").text = item.title
		description.find_child("Description").text = item.description
		description.find_child("Cost").text = str(item.cost)
	else:
		description.find_child("Name").text = ""
		description.find_child("Description").text = ""
		description.find_child("Cost").text = ""
func hide_defences() -> void:
	description.get_parent().hide()


func _on_defences_button_button_down() -> void:
	if description.get_parent().hidden:
		description.get_parent().show()
	elif description.get_parent().hidden == false:
		hide_defences()
