extends CanvasLayer

@export var mortar : PackedScene
@export var rook : PackedScene
@export var bishop : PackedScene




func _on_mortar_pressed() -> void:
	game_manager.public.cannon = mortar


func _on_rook_pressed() -> void:
	game_manager.public.cannon = rook


func _on_bishop_pressed() -> void:
	game_manager.public.cannon = bishop
