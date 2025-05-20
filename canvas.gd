extends Control
class_name canvas

@export var defences : Array[PackedScene]
@export var description : NinePatchRect
@export var wave_text : Label
@export var coin_text : Label
var selected_item : Item

var desc_active := false

static var public : canvas



func _enter_tree() -> void:
	public = self

func set_description(item : Item):
	selected_item = item
	if item != null:
		description.find_child("Name").text = item.title
		description.find_child("Description").text = item.description
		description.find_child("Cost").text = "Cost: " + str(item.cost)
	else:
		description.find_child("Name").text = ""
		description.find_child("Description").text = ""
		description.find_child("Cost").text = ""

func hide_defences() -> void:
	description.get_parent().hide()
	desc_active = false


func _on_defences_button_button_down() -> void:
	if desc_active == false:
		description.get_parent().show()
		desc_active = true
	else:
		hide_defences()
