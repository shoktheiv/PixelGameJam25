extends Control

@export var main_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var current : float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current += delta
	
	$NinePatchRect/Title.position.y = sin(current) * 20
	$ss.position = Vector2(831.0 + sin(current) * 15, 488.0 + cos(current) * 20)


func _on_play_pressed() -> void:
	$ColorRect.show()
	call_deferred("_delayed_function")

func _delayed_function():
	await get_tree().change_scene_to_packed(main_scene)
	
